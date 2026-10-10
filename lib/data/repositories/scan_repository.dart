import '../models/scan_record.dart';
import '../services/product_queue_service.dart';
import '../services/scan_database_service.dart';
import '../services/sync_batch_queue_service.dart';

class ScanRepository {
  const ScanRepository({
    required this.databaseService,
    required this.productQueueService,
    required this.syncBatchQueueService,
  });

  final ScanDatabaseService databaseService;
  final ProductQueueService productQueueService;
  final SyncBatchQueueService syncBatchQueueService;

  Future<int> addScan(ScanRecord record) {
    return databaseService.insert(record);
  }

  Future<List<ScanRecord>> pendingScans({required String userId}) {
    return databaseService.records(userId: userId);
  }

  Future<void> updateScan(ScanRecord record) {
    return databaseService.update(record);
  }

  Future<int> pendingCount({required String userId}) {
    return databaseService.count(userId: userId);
  }

  Future<int> syncPendingScans({
    required String userId,
    required void Function(int synced, int total) onProgress,
  }) async {
    final records = await databaseService.records(userId: userId);
    if (records.isEmpty) {
      return 0;
    }

    final syncBatchId = ScanRecord.createMessageId();
    final publishedRecords = <ScanRecord>[];
    final unpublishedRecords = <ScanRecord>[];

    await syncBatchQueueService.publishStarted(
      messageId: ScanRecord.createMessageId(),
      syncBatchId: syncBatchId,
      userId: userId,
      expectedMessageIds: records
          .map((record) => record.messageId)
          .toList(growable: false),
    );

    for (final record in records.reversed) {
      try {
        await productQueueService.publishProductCreated(
          record: record,
          syncBatchId: syncBatchId,
        );
        publishedRecords.add(record);
        onProgress(publishedRecords.length, records.length);
      } catch (_) {
        unpublishedRecords.add(record);
      }
    }

    if (unpublishedRecords.isNotEmpty) {
      await syncBatchQueueService.publishCompleted(
        messageId: ScanRecord.createMessageId(),
        syncBatchId: syncBatchId,
        userId: userId,
        unpublishedMessageIds: unpublishedRecords
            .map((record) => record.messageId)
            .toList(growable: false),
      );
    }

    await _deletePublishedRecords(publishedRecords);

    if (unpublishedRecords.isNotEmpty) {
      throw ProductSyncPartialFailure(
        publishedCount: publishedRecords.length,
        unpublishedCount: unpublishedRecords.length,
      );
    }

    return publishedRecords.length;
  }

  Future<void> _deletePublishedRecords(
    List<ScanRecord> publishedRecords,
  ) async {
    for (final record in publishedRecords) {
      await databaseService.delete(record.id!);
    }
  }
}

class ProductSyncPartialFailure implements Exception {
  const ProductSyncPartialFailure({
    required this.publishedCount,
    required this.unpublishedCount,
  });

  final int publishedCount;
  final int unpublishedCount;
}
