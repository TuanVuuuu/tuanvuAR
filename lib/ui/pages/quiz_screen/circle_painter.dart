import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/libary/one_libary.dart';

class CirclePainter extends CustomPainter {
  final double percentage;

  CirclePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = (percentage >= 0.76) ? OneColors.borderGreen : ((percentage >= 0.5 && percentage < 0.8) ? OneColors.textOrange : OneColors.red)
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (percentage);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), (135 + pi) / 2, angle, false, paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
