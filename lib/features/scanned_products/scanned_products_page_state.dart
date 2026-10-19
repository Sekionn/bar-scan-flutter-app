part of 'scanned_products_page.dart';

class _ScannedProductsPageState extends State<ScannedProductsPage> {
  late final ScanRepository _scanRepository;
  late Future<List<ScanRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _scanRepository = context.read<ScanRepository>();
    _recordsFuture = _scanRepository.pendingScans(userId: widget.userId);
  }

  void _refreshRecords() {
    setState(() {
      _recordsFuture = _scanRepository.pendingScans(userId: widget.userId);
    });
  }

  Future<void> _editRecord(ScanRecord record) async {
    final updatedRecord = await showDialog<ScanRecord>(
      context: context,
      builder: (_) => _EditScanRecordDialog(record: record),
    );

    if (updatedRecord == null) {
      return;
    }

    await _scanRepository.updateScan(updatedRecord);
    _refreshRecords();

    if (mounted) {
      final t = AppLocalizations.read(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.scanUpdated)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.scannedProducts)),
      body: FutureBuilder<List<ScanRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? const [];
          if (records.isEmpty) {
            return Center(child: Text(t.noProductsWaiting));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: records.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.qr_code_2),
                  title: Text(record.barcode),
                  subtitle: Text(
                    '${t.shelfLabel} ${record.segment} - ${t.amountLabel} ${record.enteredNumber}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(formatTime(record.createdAt)),
                      const SizedBox(width: 8),
                      const Icon(Icons.edit, size: 20),
                    ],
                  ),
                  onTap: () => _editRecord(record),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
