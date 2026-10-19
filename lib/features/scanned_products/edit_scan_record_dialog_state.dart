part of 'scanned_products_page.dart';

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
