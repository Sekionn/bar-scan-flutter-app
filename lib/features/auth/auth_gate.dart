import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';
import '../../i18n/app_localizations.dart';
import '../../ui/core/language_switcher.dart';
import '../segment/segment_page.dart';
import 'login_page.dart';

part 'auth_gate_state.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}
