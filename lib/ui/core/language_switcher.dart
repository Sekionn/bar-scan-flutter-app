import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/app_language.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/language_controller.dart';

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
      icon: _FlagIcon(language: currentLanguage),
    );
  }
}

class _FlagIcon extends StatelessWidget {
  const _FlagIcon({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlagPainter(language),
      size: const Size(28, 20),
    );
  }
}

class _FlagPainter extends CustomPainter {
  const _FlagPainter(this.language);

  final AppLanguage language;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Offset.zero & size;
    canvas.clipRRect(BorderRadius.circular(2).toRRect(rect));

    if (language == AppLanguage.da) {
      paint.color = const Color(0xffc60c30);
      canvas.drawRect(rect, paint);
      paint.color = Colors.white;
      canvas.drawRect(Rect.fromLTWH(size.width * 0.3, 0, size.width * 0.12, size.height), paint);
      canvas.drawRect(Rect.fromLTWH(0, size.height * 0.42, size.width, size.height * 0.14), paint);
      return;
    }

    paint.color = const Color(0xff012169);
    canvas.drawRect(rect, paint);
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.38, 0, size.width * 0.24, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.32, size.width, size.height * 0.36), paint);
    paint.color = const Color(0xffc8102e);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.44, 0, size.width * 0.12, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.42, size.width, size.height * 0.16), paint);
  }

  @override
  bool shouldRepaint(covariant _FlagPainter oldDelegate) {
    return oldDelegate.language != language;
  }
}
