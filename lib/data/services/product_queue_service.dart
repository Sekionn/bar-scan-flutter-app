import 'dart:async';
import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';

import '../../config/app_config.dart';
import '../models/scan_record.dart';

class ProductQueueService {
  Future<void> publishProductCreated(ScanRecord record) async {
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
        AppConfig.productCreatedExchange,
        ExchangeType.DIRECT,
        durable: true,
      );
      final queue = await channel.queue(
        AppConfig.productCreatedQueue,
        durable: true,
      );
      await queue.bind(exchange, AppConfig.productCreatedRoutingKey);

      final payload = jsonEncode(record.toProductCreatedEvent());
      final confirmation = Completer<void>();
      late final StreamSubscription<PublishNotification> subscription;
      subscription = channel.publishNotifier((notification) {
        if (notification.published) {
          confirmation.complete();
          return;
        }
        confirmation.completeError(const ProductPublishException());
      });

      exchange.publish(
        payload,
        AppConfig.productCreatedRoutingKey,
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

class ProductPublishException implements Exception {
  const ProductPublishException();
}
