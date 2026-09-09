import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/scan_record.dart';
import '../../data/repositories/scan_repository.dart';
import '../../utils/date_formatters.dart';

class ScannedProductsPage extends StatefulWidget {
  const ScannedProductsPage({super.key, required this.segment});

  final String segment;

  @override
  State<ScannedProductsPage> createState() => _ScannedProductsPageState();
}

class _ScannedProductsPageState extends State<ScannedProductsPage> {
  late Future<List<ScanRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = context.read<ScanRepository>().pendingScans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanned products')),
      body: FutureBuilder<List<ScanRecord>>(
        future: _recordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? const [];
          if (records.isEmpty) {
            return const Center(child: Text('No products waiting to sync.'));
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
                    'Segment ${record.segment} - Number ${record.enteredNumber}',
                  ),
                  trailing: Text(formatTime(record.createdAt)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
