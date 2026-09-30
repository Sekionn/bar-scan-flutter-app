import 'dart:math';

class ScanRecord {
  ScanRecord({
    this.id,
    String? messageId,
    required this.userId,
    required this.username,
    required this.segment,
    required this.barcode,
    required this.enteredNumber,
    required this.createdAt,
  }) : messageId = messageId ?? createMessageId();

  final int? id;
  final String messageId;
  final String userId;
  final String username;
  final String segment;
  final String barcode;
  final String enteredNumber;
  final DateTime createdAt;

  int get shelfOfOrigin => int.parse(segment);
  int get amountCounted => int.parse(enteredNumber);

  ScanRecord copyWith({
    int? id,
    String? messageId,
    String? userId,
    String? username,
    String? segment,
    String? barcode,
    String? enteredNumber,
    DateTime? createdAt,
  }) {
    return ScanRecord(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      segment: segment ?? this.segment,
      barcode: barcode ?? this.barcode,
      enteredNumber: enteredNumber ?? this.enteredNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toDatabase() {
    return {
      'id': id,
      'message_id': messageId,
      'user_id': userId,
      'username': username,
      'segment': segment,
      'barcode': barcode,
      'entered_number': enteredNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, Object?> toProductCreatedEvent() {
    return {
      'userId': userId,
      'messageId': messageId,
      'barcode': barcode,
      'shelfOfOrigin': shelfOfOrigin,
      'amountCounted': amountCounted,
    };
  }

  factory ScanRecord.fromDatabase(Map<String, Object?> row) {
    return ScanRecord(
      id: row['id'] as int,
      messageId: row['message_id'] as String,
      userId: row['user_id'] as String,
      username: row['username'] as String,
      segment: row['segment'] as String,
      barcode: row['barcode'] as String,
      enteredNumber: row['entered_number'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  static String createMessageId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
