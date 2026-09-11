import '../models/scan_record.dart';
import 'product_queue_service.dart';

class QueueApiService {
  QueueApiService({ProductQueueService? productQueueService})
    : _productQueueService = productQueueService ?? ProductQueueService();

  final ProductQueueService _productQueueService;

  Future<void> send(ScanRecord record) {
    return _productQueueService.publishProductCreated(record);
  }
}
