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
  static const productCreatedExchange = 'bar-scan.products';
  static const productCreatedQueue = 'bar-scan.product-created';
  static const productCreatedRoutingKey = 'product.created';
  static const syncBatchExchange = 'bar-scan.sync-batches';
  static const syncBatchStartedQueue = 'bar-scan.sync-batch-started';
  static const syncBatchStartedRoutingKey = 'sync-batch.started';
  static const syncBatchPublishCompletedQueue =
      'bar-scan.sync-batch-publish-completed';
  static const syncBatchPublishCompletedRoutingKey =
      'sync-batch.publish-completed';

  static const privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://bar-scan.juuls-trinkets.com/privacy',
  );
  static const termsUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://bar-scan.juuls-trinkets.com/terms',
  );
  static const supportUrl = String.fromEnvironment(
    'SUPPORT_URL',
    defaultValue: 'https://bar-scan.juuls-trinkets.com/support',
  );
  static const supportEmail = String.fromEnvironment(
    'SUPPORT_EMAIL',
    defaultValue: 'support@juuls-trinkets.com',
  );
}
