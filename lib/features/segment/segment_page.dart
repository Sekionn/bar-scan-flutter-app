import 'package:flutter/material.dart';

import '../../data/models/auth_session.dart';
import '../../i18n/app_localizations.dart';
import '../../utils/validators.dart';
import '../scanner/scanner_page.dart';

part 'segment_page_state.dart';

class SegmentPage extends StatefulWidget {
  const SegmentPage({super.key, required this.session});

  final AuthSession session;

  @override
  State<SegmentPage> createState() => _SegmentPageState();
}
