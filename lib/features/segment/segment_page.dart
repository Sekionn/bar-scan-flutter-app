import 'package:flutter/material.dart';

import '../../data/models/auth_session.dart';
import '../../utils/validators.dart';
import '../scanner/scanner_page.dart';

class SegmentPage extends StatefulWidget {
  const SegmentPage({super.key, required this.session});

  final AuthSession session;

  @override
  State<SegmentPage> createState() => _SegmentPageState();
}

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
    return Scaffold(
      appBar: AppBar(title: const Text('Store segment')),
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
                      'Choose the shelf number',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text('This value is sent as shelfOfOrigin.'),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _segmentController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Shelf number',
                        prefixIcon: Icon(Icons.tag),
                      ),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) => _continue(),
                      validator: nonNegativeIntegerText,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _continue,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Start scanning'),
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
