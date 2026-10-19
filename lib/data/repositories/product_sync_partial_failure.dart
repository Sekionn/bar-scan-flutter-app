class ProductSyncPartialFailure implements Exception {
  const ProductSyncPartialFailure({
    required this.publishedCount,
    required this.unpublishedCount,
  });

  final int publishedCount;
  final int unpublishedCount;
}
