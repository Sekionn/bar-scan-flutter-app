import '../models/scan_record.dart';
import '../services/product_queue_service.dart';
import '../services/scan_database_service.dart';

class ScanRepository {
  const ScanRepository({
    required this.databaseService,
    required this.productQueueService,
  });

  final ScanDatabaseService databaseService;
  final ProductQueueService productQueueService;

  Future<int> addScan(ScanRecord record) {
    return databaseService.insert(record);
  }

  Future<List<ScanRecord>> pendingScans() {
    return databaseService.records();
  }

  Future<void> updateScan(ScanRecord record) {
    return databaseService.update(record);
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
      await productQueueService.publishProductCreated(record);
      await databaseService.delete(record.id!);
      synced += 1;
      onProgress(synced, records.length);
    }

    return synced;
  }
}
