# Mobile Integration Context

This file describes the connection points between the mobile app and the `bar-scan` backend.

## Backend Base

- Default HTTPS port: `8080`
- Local base URL: `https://<backend-host>:8080`
- Authentication type: JWT bearer token
- Auth header format: `Authorization: Bearer <token>`
- JSON content type: `Content-Type: application/json`

The backend stores data in MySQL and consumes product scan events from RabbitMQ.

## Environment

Backend database settings:

```properties
DB_URL=jdbc:mysql://localhost:3306/bar_scan?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
DB_USERNAME=bar_scan
DB_PASSWORD=bar_scan
JWT_SECRET=replace-with-a-long-secret-at-least-32-bytes
```

RabbitMQ settings:

```properties
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=guest
RABBITMQ_PASSWORD=guest
PRODUCT_CREATED_EXCHANGE=bar-scan.products
PRODUCT_CREATED_QUEUE=bar-scan.product-created
PRODUCT_CREATED_ROUTING_KEY=product.created
```

## Database Model

The mobile app should treat these IDs as UUID strings.

### Companies

Companies represent the paying customer/store context.

Fields:

```json
{
  "id": "00000000-0000-0000-0000-000000000001",
  "name": "Development Company",
  "allowedUserCount": 10,
  "locationName": "Development Store"
}
```

Database columns:

- `id`
- `name`
- `allowed_user_count`
- `location_name`

### Users

Users log in from the mobile app and belong to one company.

Database columns:

- `id`
- `username`
- `password_hash`
- `company_id`
- `role`

Passwords are stored as BCrypt hashes by the backend. The mobile app must only send plain passwords over HTTPS during registration/login.

### Products

Products are scan/count records scoped to a company.

Database columns:

- `company_id`
- `product_id`
- `barcode`
- `shelf_of_origin`
- `amount_counted`
- `counted_date`

Primary key:

```text
(company_id, product_id)
```

The mobile app may send `productId` as `null`. If missing, the backend generates it when handling the queue event.

## HTTP Endpoints

### Register User

Creates a user under the authenticated admin's company.

```http
POST /auth/register
```

Authentication: required, `ROLE_ADMIN`

Headers:

```http
Authorization: Bearer <admin-token>
Content-Type: application/json
```

Request:

```json
{
  "username": "scanner01",
  "password": "password123"
}
```

Validation:

- `username` is required.
- `password` is required and must be at least 8 characters.
- The authenticated user must have `ROLE_ADMIN`.
- The new user is always created under the admin's own `companyId`.
- Registration fails if the admin's company has reached `allowed_user_count`.

Success response:

```json
{
  "id": "user-uuid",
  "username": "scanner01",
  "companyId": "admin-company-uuid",
  "role": "ROLE_USER"
}
```

Possible errors:

- `400` validation failed
- `401` missing/invalid token
- `403` authenticated user is not an admin
- `404` admin company not found
- `409` username already exists or company user limit reached

### Login

Authenticates a user and returns a JWT.

```http
POST /auth/login
```

Authentication: none

Request:

```json
{
  "username": "scanner01",
  "password": "password123"
}
```

Success response:

```json
{
  "token": "jwt-token"
}
```

JWT claims currently include:

```json
{
  "sub": "scanner01",
  "userId": "user-uuid",
  "companyId": "company-uuid",
  "role": "ROLE_USER",
  "iat": 1788970000,
  "exp": 1789056400
}
```

Possible errors:

- `400` validation failed
- `401` invalid username or password

### Current User

Simple authenticated identity check.

```http
GET /auth/me
```

Authentication: required

Headers:

```http
Authorization: Bearer <token>
```

Success response:

```json
{
  "username": "scanner01"
}
```

### Get Products

Returns products for the logged-in user's company only.

```http
GET /products
```

Authentication: required

Headers:

```http
Authorization: Bearer <token>
```

Success response:

```json
[
  {
    "companyId": "company-uuid",
    "productId": "product-uuid",
    "barcode": "123456789",
    "shelfOfOrigin": 1,
    "amountCounted": 5,
    "countedDate": "2026-09-09T18:15:10"
  }
]
```

## Message Queue

Product creation is not done through an HTTP REST endpoint. The mobile app publishes product-created events to RabbitMQ, and the backend consumes them.

### Product Created Event

Exchange:

```text
bar-scan.products
```

Exchange type:

```text
direct
```

Queue:

```text
bar-scan.product-created
```

Routing key:

```text
product.created
```

Content type:

```text
application/json
```

Message body:

```json
{
  "userId": "user-uuid",
  "productId": null,
  "barcode": "123456789",
  "shelfOfOrigin": 1,
  "amountCounted": 5
}
```

Fields:

- `userId`: required UUID. Identifies the user who scanned/submitted the product event.
- `productId`: optional UUID. If `null`, the backend generates a UUID.
- `barcode`: required string.
- `shelfOfOrigin`: integer, minimum `0`.
- `amountCounted`: integer, minimum `0`.

Backend handling:

1. Receives the message from RabbitMQ.
2. Deserializes it into `ProductCreatedEventDTO`.
3. Looks up `userId` in the `users` table.
4. Reads the user's `company_id`.
5. Creates a product record under that company.
6. Stores it using `(company_id, product_id)` as the composite key.

Important: the event currently contains the user context through `userId`, but the `products` table does not store `created_by_user_id`. If scan history per user is needed later, add that column in a new Flyway migration.

## Mobile App Flow

Recommended flow:

1. Log in through HTTP.
2. Store the returned JWT securely on the device.
3. Decode the JWT or call `/auth/me` if the app needs current-user context.
4. Admin users may call `/auth/register` to create users for their own company.
5. For product scans, publish `product.created` messages to RabbitMQ with the logged-in user's `userId`.
6. Use `GET /products` with the bearer token to fetch products for the user's company.

The mobile app should not send `companyId` in product-created messages. The backend derives the company from `userId` to avoid trusting client-provided company context.

The mobile app should also not send `companyId` when registering users. The backend derives the target company from the authenticated admin token.

## Current Development Seed

Flyway seeds one development company:

```json
{
  "id": "00000000-0000-0000-0000-000000000001",
  "name": "Development Company",
  "allowedUserCount": 10,
  "locationName": "Development Store"
}
```

Use that company for local bootstrap/admin data until a company-management flow exists. Because `/auth/register` is admin-only, a first admin user must be inserted by migration, database seed, or a future company/admin management endpoint before normal user registration can happen.
