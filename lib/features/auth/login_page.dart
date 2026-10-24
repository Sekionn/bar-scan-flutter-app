import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_request_exception.dart';
import '../../data/services/invalid_credentials_exception.dart';
import '../../i18n/app_localizations.dart';
import '../../ui/core/language_switcher.dart';
import '../../utils/validators.dart';
import '../legal/legal_support_page.dart';
import '../segment/segment_page.dart';

part 'login_page_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
