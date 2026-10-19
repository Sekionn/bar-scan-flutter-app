import 'package:flutter/material.dart';

import '../../i18n/app_language.dart';
import 'flag_painter.dart';

class FlagIcon extends StatelessWidget {
  const FlagIcon({super.key, required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FlagPainter(language),
      size: const Size(28, 20),
    );
  }
}
