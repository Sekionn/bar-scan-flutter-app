part of 'segment_page.dart';

class _SegmentPageState extends State<SegmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _segmentController = TextEditingController();

  @override
  void dispose() {
    _segmentController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScannerPage(
          session: widget.session,
          segment: _segmentController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.storeSegment)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      t.chooseShelf,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _segmentController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: t.shelfNumber,
                        prefixIcon: const Icon(Icons.tag),
                      ),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) => _continue(),
                      validator: (value) => nonNegativeIntegerText(
                        value,
                        requiredMessage: t.required,
                        integerMessage: t.enterWholeNumber,
                        zeroOrHigherMessage: t.enterZeroOrHigher,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _continue,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(t.startScanning),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
