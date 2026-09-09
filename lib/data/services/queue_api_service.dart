import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/scan_record.dart';

const messageQueueEndpoint = String.fromEnvironment('MESSAGE_QUEUE_ENDPOINT');

class QueueApiService {
  QueueApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<void> send(ScanRecord record) async {
    if (messageQueueEndpoint.isEmpty) {
      throw const QueueConfigurationException();
    }

    final response = await _client.post(
      Uri.parse(messageQueueEndpoint),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(record.toQueuePayload()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QueueSendException(response.statusCode);
    }
  }
}

class QueueConfigurationException implements Exception {
  const QueueConfigurationException();
}

class QueueSendException implements Exception {
  const QueueSendException(this.statusCode);

  final int statusCode;
}
