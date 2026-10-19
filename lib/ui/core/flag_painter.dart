import 'package:flutter/material.dart';

import '../../i18n/app_language.dart';

class FlagPainter extends CustomPainter {
  const FlagPainter(this.language);

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
      canvas.drawRect(
        Rect.fromLTWH(size.width * 0.3, 0, size.width * 0.12, size.height),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.42, size.width, size.height * 0.14),
        paint,
      );
      return;
    }

    paint.color = const Color(0xff012169);
    canvas.drawRect(rect, paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    paint
      ..color = Colors.white
      ..strokeWidth = size.height * 0.34;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);

    paint
      ..color = const Color(0xffc8102e)
      ..strokeWidth = size.height * 0.16;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);

    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.38, 0, size.width * 0.24, size.height),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.32, size.width, size.height * 0.36),
      paint,
    );
    paint.color = const Color(0xffc8102e);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.44, 0, size.width * 0.12, size.height),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.42, size.width, size.height * 0.16),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant FlagPainter oldDelegate) {
    return oldDelegate.language != language;
  }
}
