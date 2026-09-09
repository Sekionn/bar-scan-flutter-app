class ScanRecord {
  const ScanRecord({
    this.id,
    required this.username,
    required this.segment,
    required this.barcode,
    required this.enteredNumber,
    required this.createdAt,
  });

  final int? id;
  final String username;
  final String segment;
  final String barcode;
  final String enteredNumber;
  final DateTime createdAt;

  Map<String, Object?> toDatabase() {
    return {
      'id': id,
      'username': username,
      'segment': segment,
      'barcode': barcode,
      'entered_number': enteredNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, Object?> toQueuePayload() {
    return {
      'id': id,
      'username': username,
      'segment': segment,
      'barcode': barcode,
      'number': enteredNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScanRecord.fromDatabase(Map<String, Object?> row) {
    return ScanRecord(
      id: row['id'] as int,
      username: row['username'] as String,
      segment: row['segment'] as String,
      barcode: row['barcode'] as String,
      enteredNumber: row['entered_number'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
