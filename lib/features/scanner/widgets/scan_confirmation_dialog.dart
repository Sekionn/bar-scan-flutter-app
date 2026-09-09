import 'package:flutter/material.dart';

import '../../../data/models/scan_record.dart';
import '../../../utils/validators.dart';

class ScanConfirmationDialog extends StatefulWidget {
  const ScanConfirmationDialog({
    super.key,
    required this.username,
    required this.segment,
    required this.barcode,
  });

  final String username;
  final String segment;
  final String barcode;

  @override
  State<ScanConfirmationDialog> createState() => _ScanConfirmationDialogState();
}

class _ScanConfirmationDialogState extends State<ScanConfirmationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _barcodeController;
  final _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.barcode);
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _addRecord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      ScanRecord(
        username: widget.username,
        segment: widget.segment,
        barcode: _barcodeController.text.trim(),
        enteredNumber: _numberController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm barcode'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Barcode',
              ),
              validator: requiredText,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onFieldSubmitted: (_) => _addRecord(),
              validator: numberText,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _addRecord,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
      ],
    );
  }
}
