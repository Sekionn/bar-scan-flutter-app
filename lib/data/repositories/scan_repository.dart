import '../models/scan_record.dart';
import '../services/queue_api_service.dart';
import '../services/scan_database_service.dart';

class ScanRepository {
  const ScanRepository({
    required this.databaseService,
    required this.queueApiService,
  });

  final ScanDatabaseService databaseService;
  final QueueApiService queueApiService;

  Future<int> addScan(ScanRecord record) {
    return databaseService.insert(record);
  }

  Future<List<ScanRecord>> pendingScans() {
    return databaseService.records();
  }

  Future<int> pendingCount() {
    return databaseService.count();
  }

  Future<int> syncPendingScans({
    required void Function(int synced, int total) onProgress,
  }) async {
    final records = await databaseService.records();
    var synced = 0;

    for (final record in records.reversed) {
      await queueApiService.send(record);
      await databaseService.delete(record.id!);
      synced += 1;
      onProgress(synced, records.length);
    }

    return synced;
  }
}
