# Barscan App

Flutter app for scanning store barcodes on Android and iOS, storing unsynced
scan rows locally, and syncing them to a RabbitMQ exchange consumed by the backend.

## Project Structure Rules

This app follows Flutter's recommended separation of concerns:

- `lib/main.dart` is only the entry point. Keep app setup in `lib/app/`.
- `lib/app/` contains root app composition, theme, and top-level dependency
  injection.
- `lib/features/<feature>/` contains user-facing screens for one feature.
- `lib/features/<feature>/widgets/` contains widgets only used by that feature.
- `lib/ui/core/` contains shared UI used across features, such as navigation.
- `lib/data/models/` contains plain data/domain objects.
- `lib/data/repositories/` contains app-facing data access APIs and business
  logic. UI should depend on repositories, not database/API services directly.
- `lib/data/services/` contains concrete external integrations, such as SQLite,
  HTTP APIs, platform plugins, or message queue adapters.
- `lib/utils/` contains small pure helpers. Do not put feature or business logic
  here.

## Dependency Direction

Keep dependencies flowing inward through stable boundaries:

- Features can import repositories, models, shared UI, and utils.
- Repositories can import models and services.
- Services can import models and third-party packages.
- Data code must not import feature screens or widgets.
- Shared UI must not depend on a specific feature unless it is explicitly a
  navigation component for the app shell.

## File Size Rule

Prefer one primary class per file. Small private helper widgets may live beside
their parent screen, but once a widget is reused or becomes non-trivial, move it
into a dedicated file.

## Running

Resolve dependencies:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat pub get
```

Run the app:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat run
```

Create a local Flutter define file from the example:

```powershell
Copy-Item env\example.json env\local.json
```

Run with backend and RabbitMQ configured from that file:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat run -d emulator-5554 --dart-define-from-file=env/local.json
```

For an Android emulator, `10.0.2.2` points back to the host machine. For a
physical Android phone, edit `env/local.json` and replace `10.0.2.2` with the
LAN IP address of the machine running the backend and RabbitMQ.

`env/local.json` is ignored by Git. Commit changes to `env/example.json` only
when adding or documenting new config keys.

The mobile app integration follows `mobile-integration-context.md`:

- Login calls `POST /auth/login` and stores the returned JWT in secure storage.
- JWT claims are decoded locally to get `userId`, `companyId`, `role`, and expiry.
- Local scan rows include `userId` so unsynced records can be sent after app restarts.
- Sync publishes RabbitMQ `product.created` messages to `bar-scan.products`.
- Product-created messages do not include `companyId`; the backend derives it from `userId`.

## Local SQLite Storage

Android and iOS use the phone's local SQLite database through `sqflite`.
Flutter web uses SQLite compiled to WebAssembly through `sqflite_common_ffi_web`.
That means Chrome can store pending scans locally without MySQL or a separate API.

The same `ScanDatabaseService` is used on every platform:

- Android/iOS: `barscan.sqlite` in the app's private database folder.
- Chrome/web: `barscan.sqlite` persisted in browser IndexedDB for the current origin.

Required web SQLite runtime files live in `web/`:

```text
web/sqlite3.wasm
web/sqflite_sw.js
```

If the SQLite web package is upgraded, regenerate those files with:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\dart.bat run sqflite_common_ffi_web:setup --force
```

Web storage is tied to the browser origin. For consistent testing, run Chrome on
the same port each time:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat run -d chrome --web-hostname 127.0.0.1 --web-port 53080 --dart-define-from-file=env/local.json
```

To inspect or clear the web database, use Chrome DevTools -> Application ->
IndexedDB for the running `127.0.0.1:53080` origin.

## VS Code

The project includes `.vscode/launch.json` profiles that automatically use
`env/local.json` through Flutter's `--dart-define-from-file` option.

In VS Code, open the Run and Debug panel and choose one of these profiles:

- `Barscan Chrome (local env)` targets Chrome on port `53080` for stable SQLite web storage.
- `Barscan (local env)` uses the currently selected Flutter device.
- `Barscan Android Emulator (local env)` targets `emulator-5554`.

## Verification

Before handing off changes, run:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\dart.bat format lib test
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat analyze
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat test
```









