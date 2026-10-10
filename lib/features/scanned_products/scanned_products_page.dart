import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/scan_record.dart';
import '../../data/repositories/scan_repository.dart';
import '../../i18n/app_localizations.dart';
import '../../utils/date_formatters.dart';
import '../../utils/validators.dart';

class ScannedProductsPage extends StatefulWidget {
  const ScannedProductsPage({
    super.key,
    required this.segment,
    required this.userId,
  });

  final String segment;
  final String userId;

  @override
  State<ScannedProductsPage> createState() => _ScannedProductsPageState();
}

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

class _EditScanRecordDialog extends StatefulWidget {
  const _EditScanRecordDialog({required this.record});

  final ScanRecord record;

  @override
  State<_EditScanRecordDialog> createState() => _EditScanRecordDialogState();
}

class _EditScanRecordDialogState extends State<_EditScanRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _barcodeController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.record.barcode);
    _amountController = TextEditingController(
      text: widget.record.enteredNumber,
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      widget.record.copyWith(
        barcode: _barcodeController.text.trim(),
        enteredNumber: _amountController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(t.editScan),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _barcodeController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: t.barcode,
                prefixIcon: const Icon(Icons.qr_code_2),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => requiredText(
                value,
                requiredMessage: t.required,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: t.amount,
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) => _save(),
              validator: (value) => numberText(
                value,
                requiredMessage: t.required,
                numberMessage: t.enterNumber,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save),
          label: Text(t.save),
        ),
      ],
    );
  }
}
