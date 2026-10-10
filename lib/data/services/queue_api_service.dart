import '../models/scan_record.dart';
import 'product_queue_service.dart';

class QueueApiService {
  QueueApiService({ProductQueueService? productQueueService})
    : _productQueueService = productQueueService ?? ProductQueueService();

  final ProductQueueService _productQueueService;

  Future<void> send({
    required ScanRecord record,
    required String syncBatchId,
  }) {
    return _productQueueService.publishProductCreated(
      record: record,
      syncBatchId: syncBatchId,
    );
  }
}
