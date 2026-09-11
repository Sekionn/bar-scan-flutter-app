import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';
import '../../features/auth/login_page.dart';
import '../../features/scanned_products/scanned_products_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.session,
    required this.segment,
    required this.pendingCount,
    required this.onRecordsChanged,
  });

  final AuthSession session;
  final String segment;
  final int pendingCount;
  final VoidCallback onRecordsChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barscan',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text('${session.username} - shelf $segment'),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Scanned products'),
              trailing: Text('$pendingCount'),
              onTap: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ScannedProductsPage(segment: segment),
                  ),
                );
                onRecordsChanged();
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () async {
                await context.read<AuthRepository>().logout();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
