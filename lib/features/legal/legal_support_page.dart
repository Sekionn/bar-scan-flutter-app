import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../i18n/app_localizations.dart';
import 'support_section.dart';

class LegalSupportPage extends StatelessWidget {
  const LegalSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.legalSupport)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SupportSection(
              icon: Icons.privacy_tip_outlined,
              title: t.privacyPolicy,
              body: t.privacyBody,
              value: AppConfig.privacyPolicyUrl,
            ),
            SupportSection(
              icon: Icons.description_outlined,
              title: t.terms,
              body: t.termsBody,
              value: AppConfig.termsUrl,
            ),
            SupportSection(
              icon: Icons.support_agent,
              title: t.support,
              body: t.supportBody,
              value: AppConfig.supportEmail,
            ),
            SupportSection(
              icon: Icons.delete_outline,
              title: t.accountDeletion,
              body: t.accountDeletionBody,
              value: t.contact(AppConfig.supportEmail),
            ),
          ],
        ),
      ),
    );
  }
}
