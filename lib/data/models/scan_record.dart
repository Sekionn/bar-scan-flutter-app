class ScanRecord {
  const ScanRecord({
    this.id,
    required this.userId,
    required this.username,
    required this.segment,
    required this.barcode,
    required this.enteredNumber,
    required this.createdAt,
  });

  final int? id;
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
    String? userId,
    String? username,
    String? segment,
    String? barcode,
    String? enteredNumber,
    DateTime? createdAt,
  }) {
    return ScanRecord(
      id: id ?? this.id,
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
      'productId': null,
      'barcode': barcode,
      'shelfOfOrigin': shelfOfOrigin,
      'amountCounted': amountCounted,
    };
  }

  factory ScanRecord.fromDatabase(Map<String, Object?> row) {
    return ScanRecord(
      id: row['id'] as int,
      userId: row['user_id'] as String,
      username: row['username'] as String,
      segment: row['segment'] as String,
      barcode: row['barcode'] as String,
      enteredNumber: row['entered_number'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
