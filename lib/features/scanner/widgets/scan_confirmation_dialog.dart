import 'package:flutter/material.dart';

import '../../../data/models/scan_record.dart';
import '../../../i18n/app_localizations.dart';
import '../../../utils/validators.dart';

part 'scan_confirmation_dialog_state.dart';

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
