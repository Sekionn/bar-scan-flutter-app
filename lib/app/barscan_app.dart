import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/scan_repository.dart';
import '../data/services/queue_api_service.dart';
import '../data/services/scan_database_service.dart';
import '../features/auth/login_page.dart';

class BarscanApp extends StatelessWidget {
  const BarscanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ScanRepository>(
      create: (_) => ScanRepository(
        databaseService: ScanDatabaseService.instance,
        queueApiService: QueueApiService(),
      ),
      child: MaterialApp(
        title: 'Barscan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2563eb)),
          scaffoldBackgroundColor: const Color(0xfff7f8fb),
          appBarTheme: const AppBarTheme(centerTitle: false),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
