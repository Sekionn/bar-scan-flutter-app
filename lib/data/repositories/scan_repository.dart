import '../models/scan_record.dart';
import '../services/product_queue_service.dart';
import '../services/queue_status_api_service.dart';
import '../services/scan_database_service.dart';

class ScanRepository {
  const ScanRepository({
    required this.databaseService,
    required this.productQueueService,
    required this.queueStatusApiService,
  });

  final ScanDatabaseService databaseService;
  final ProductQueueService productQueueService;
  final QueueStatusApiService queueStatusApiService;

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
    required String token,
    required void Function(int synced, int total) onProgress,
  }) async {
    final records = await databaseService.records();
    final syncBatchId = ScanRecord.createMessageId();
    final publishedRecords = <ScanRecord>[];
    final unpublishedRecords = <ScanRecord>[];

    await queueStatusApiService.registerExpectedMessages(
      token: token,
      syncBatchId: syncBatchId,
      messageIds: records.map((record) => record.messageId).toList(growable: false),
    );

    for (final record in records.reversed) {
      try {
        await productQueueService.publishProductCreated(record);
        publishedRecords.add(record);
        onProgress(publishedRecords.length, records.length);
      } catch (_) {
        unpublishedRecords.add(record);
      }
    }

    await queueStatusApiService.cancelUnpublishedMessages(
      token: token,
      syncBatchId: syncBatchId,
      messageIds: unpublishedRecords
          .map((record) => record.messageId)
          .toList(growable: false),
    );

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
