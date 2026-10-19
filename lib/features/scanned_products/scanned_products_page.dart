import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/scan_record.dart';
import '../../data/repositories/scan_repository.dart';
import '../../i18n/app_localizations.dart';
import '../../utils/date_formatters.dart';
import '../../utils/validators.dart';

part 'scanned_products_page_state.dart';
part 'edit_scan_record_dialog.dart';
part 'edit_scan_record_dialog_state.dart';

class ScannedProductsPage extends StatefulWidget {
  const ScannedProductsPage({
    super.key,
    required this.segment,
    required this.userId,
  });

  final String segment;
  final String userId;

  @override
  State<ScannedProductsPage> createState() => _ScannedProductsPageState();
}
