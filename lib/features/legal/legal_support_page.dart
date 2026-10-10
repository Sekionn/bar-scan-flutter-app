import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../i18n/app_localizations.dart';

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
            _SupportSection(
              icon: Icons.privacy_tip_outlined,
              title: t.privacyPolicy,
              body: t.privacyBody,
              value: AppConfig.privacyPolicyUrl,
            ),
            _SupportSection(
              icon: Icons.description_outlined,
              title: t.terms,
              body: t.termsBody,
              value: AppConfig.termsUrl,
            ),
            _SupportSection(
              icon: Icons.support_agent,
              title: t.support,
              body: t.supportBody,
              value: AppConfig.supportEmail,
            ),
            _SupportSection(
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

class _SupportSection extends StatelessWidget {
  const _SupportSection({
    required this.icon,
    required this.title,
    required this.body,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String body;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(body),
            const SizedBox(height: 12),
            SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
