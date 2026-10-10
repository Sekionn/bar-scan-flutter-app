import 'dart:async';
import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';

import '../../config/app_config.dart';

class SyncBatchQueueService {
  Future<void> publishStarted({
    required String messageId,
    required String syncBatchId,
    required String userId,
    required List<String> expectedMessageIds,
  }) {
    return _publish(
      queueName: AppConfig.syncBatchStartedQueue,
      routingKey: AppConfig.syncBatchStartedRoutingKey,
      payload: {
        'messageId': messageId,
        'syncBatchId': syncBatchId,
        'userId': userId,
        'expectedMessageIds': expectedMessageIds,
      },
    );
  }

  Future<void> publishCompleted({
    required String messageId,
    required String syncBatchId,
    required String userId,
    required List<String> unpublishedMessageIds,
  }) {
    return _publish(
      queueName: AppConfig.syncBatchPublishCompletedQueue,
      routingKey: AppConfig.syncBatchPublishCompletedRoutingKey,
      payload: {
        'messageId': messageId,
        'syncBatchId': syncBatchId,
        'userId': userId,
        'unpublishedMessageIds': unpublishedMessageIds,
      },
    );
  }

  Future<void> _publish({
    required String queueName,
    required String routingKey,
    required Map<String, Object?> payload,
  }) async {
    final settings = ConnectionSettings(
      host: AppConfig.rabbitMqHost,
      port: AppConfig.rabbitMqPort,
      authProvider: PlainAuthenticator(
        AppConfig.rabbitMqUsername,
        AppConfig.rabbitMqPassword,
      ),
    );
    final client = Client(settings: settings);

    try {
      final channel = await client.channel();
      await channel.confirmPublishedMessages();

      final exchange = await channel.exchange(
        AppConfig.syncBatchExchange,
        ExchangeType.DIRECT,
        durable: true,
      );
      final queue = await channel.queue(queueName, durable: true);
      await queue.bind(exchange, routingKey);

      final confirmation = Completer<void>();
      late final StreamSubscription<PublishNotification> subscription;
      subscription = channel.publishNotifier((notification) {
        if (notification.published) {
          confirmation.complete();
          return;
        }
        confirmation.completeError(const SyncBatchPublishException());
      });

      exchange.publish(
        jsonEncode(payload),
        routingKey,
        mandatory: true,
        properties: MessageProperties()..contentType = 'application/json',
      );

      await confirmation.future.timeout(const Duration(seconds: 10));
      await subscription.cancel();
    } finally {
      client.close();
    }
  }
}

class SyncBatchPublishException implements Exception {
  const SyncBatchPublishException();
}
