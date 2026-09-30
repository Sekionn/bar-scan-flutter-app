import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

class QueueStatusApiService {
  QueueStatusApiService({http.Client? client})
    : _client = client ?? http.Client();

  static const _messageIdChunkSize = 1000;

  final http.Client _client;

  Future<void> registerExpectedMessages({
    required String token,
    required String syncBatchId,
    required List<String> messageIds,
  }) async {
    return _sendMessageIds(
      token: token,
      path: '/queue-status/product-created/expected',
      syncBatchId: syncBatchId,
      messageIds: messageIds,
    );
  }

  Future<void> cancelUnpublishedMessages({
    required String token,
    required String syncBatchId,
    required List<String> messageIds,
  }) async {
    if (messageIds.isEmpty) {
      return;
    }

    return _sendMessageIds(
      token: token,
      path: '/queue-status/product-created/unpublished',
      syncBatchId: syncBatchId,
      messageIds: messageIds,
    );
  }

  Future<void> _sendMessageIds({
    required String token,
    required String path,
    required String syncBatchId,
    required List<String> messageIds,
  }) async {
    for (
      var start = 0;
      start < messageIds.length;
      start += _messageIdChunkSize
    ) {
      final chunk = messageIds
          .skip(start)
          .take(_messageIdChunkSize)
          .toList(growable: false);
      final response = await _client.post(
        Uri.parse('${AppConfig.backendBaseUrl}$path'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'syncBatchId': syncBatchId,
          'messageIds': chunk,
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw QueueStatusRequestException(response.statusCode);
      }
    }
  }
}

class QueueStatusRequestException implements Exception {
  const QueueStatusRequestException(this.statusCode);

  final int statusCode;
}
