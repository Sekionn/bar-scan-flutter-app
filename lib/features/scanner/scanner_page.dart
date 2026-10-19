import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_session.dart';
import '../../data/models/scan_record.dart';
import '../../data/repositories/scan_repository.dart';
import '../../i18n/app_localizations.dart';
import '../../ui/core/app_drawer.dart';
import 'widgets/pending_sync_button.dart';
import 'widgets/scan_confirmation_dialog.dart';

part 'scanner_page_state.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.session, required this.segment});

  final AuthSession session;
  final String segment;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}
