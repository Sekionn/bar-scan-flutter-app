import 'package:flutter/material.dart';

import '../../../data/models/scan_record.dart';
import '../../../i18n/app_localizations.dart';
import '../../../utils/validators.dart';

class ScanConfirmationDialog extends StatefulWidget {
  const ScanConfirmationDialog({
    super.key,
    required this.userId,
    required this.username,
    required this.segment,
    required this.barcode,
  });

  final String userId;
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
  final _numberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.barcode);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _numberFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _numberController.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  void _addRecord() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      ScanRecord(
        userId: widget.userId,
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
    final t = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(t.confirmBarcode),
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
              ),
              validator: (value) => requiredText(
                value,
                requiredMessage: t.required,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberController,
              focusNode: _numberFocusNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: t.amountCounted,
              ),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) => _addRecord(),
              validator: (value) => nonNegativeIntegerText(
                value,
                requiredMessage: t.required,
                integerMessage: t.enterWholeNumber,
                zeroOrHigherMessage: t.enterZeroOrHigher,
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
          onPressed: _addRecord,
          icon: const Icon(Icons.add),
          label: Text(t.add),
        ),
      ],
    );
  }
}
