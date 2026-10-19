import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_language.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_controller.dart';
import 'flag_icon.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LanguageController>();
    final t = AppLocalizations.of(context);
    final currentLanguage = controller.language;

    return IconButton(
      tooltip: t.switchLanguage,
      onPressed: () => controller.toggle(),
      icon: FlagIcon(language: currentLanguage),
    );
  }
}
