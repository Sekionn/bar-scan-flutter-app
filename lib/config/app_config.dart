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
  static const syncBatchExchange = String.fromEnvironment(
    'SYNC_BATCH_EXCHANGE',
    defaultValue: 'bar-scan.sync-batches',
  );
  static const syncBatchStartedQueue = String.fromEnvironment(
    'SYNC_BATCH_STARTED_QUEUE',
    defaultValue: 'bar-scan.sync-batch-started',
  );
  static const syncBatchStartedRoutingKey = String.fromEnvironment(
    'SYNC_BATCH_STARTED_ROUTING_KEY',
    defaultValue: 'sync-batch.started',
  );
  static const syncBatchPublishCompletedQueue = String.fromEnvironment(
    'SYNC_BATCH_PUBLISH_COMPLETED_QUEUE',
    defaultValue: 'bar-scan.sync-batch-publish-completed',
  );
  static const syncBatchPublishCompletedRoutingKey = String.fromEnvironment(
    'SYNC_BATCH_PUBLISH_COMPLETED_ROUTING_KEY',
    defaultValue: 'sync-batch.publish-completed',
  );

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
