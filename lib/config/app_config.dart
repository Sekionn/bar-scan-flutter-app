class AppConfig {
  const AppConfig._();

  static const backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'https://10.0.2.2:8080',
  );

  static const rabbitMqHost = String.fromEnvironment(
    'RABBITMQ_HOST',
    defaultValue: '10.0.2.2',
  );
  static const rabbitMqPort = int.fromEnvironment(
    'RABBITMQ_PORT',
    defaultValue: 5672,
  );
  static const rabbitMqUsername = String.fromEnvironment(
    'RABBITMQ_USERNAME',
    defaultValue: 'guest',
  );
  static const rabbitMqPassword = String.fromEnvironment(
    'RABBITMQ_PASSWORD',
    defaultValue: 'guest',
  );
  static const productCreatedExchange = String.fromEnvironment(
    'PRODUCT_CREATED_EXCHANGE',
    defaultValue: 'bar-scan.products',
  );
  static const productCreatedQueue = String.fromEnvironment(
    'PRODUCT_CREATED_QUEUE',
    defaultValue: 'bar-scan.product-created',
  );
  static const productCreatedRoutingKey = String.fromEnvironment(
    'PRODUCT_CREATED_ROUTING_KEY',
    defaultValue: 'product.created',
  );
}
