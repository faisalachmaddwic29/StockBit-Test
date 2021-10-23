import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final BuildContext context;
  final DateTime dateTime;
  ClockPainter(this.context, this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset offset = const Offset(0, 0);

    canvas.translate(centerX, centerY);

    canvas.drawCircle(
        offset,
        radius,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Theme.of(context).primaryColor);

    double L = 150;
    double S = 6;
    _paintHourHand(canvas, L / 3.2, S);
    _paintMinuteHand(canvas, L / 2.4, S / 1.4);
    _paintSecondHand(canvas, L / 2.2, S / 3);

    //drawing center point
    Paint centerPointPaint = Paint()
      ..strokeWidth = ((radius) / 10)
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey;
    canvas.drawPoints(PointMode.points, [offset], centerPointPaint);

    // Paint borderPaint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..isAntiAlias = true;
    // canvas.drawCircle(offset, radius / 5, borderPaint);
  }

  /// drawing hour hand
  void _paintHourHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = dateTime.hour % 12 + dateTime.minute / 60.0 - 3;
    Offset handOffset = Offset(cos(getRadians(angle * 30)) * radius,
        sin(getRadians(angle * 30)) * radius);
    final hourHandPaint = Paint()
      ..color = Theme.of(context).scaffoldBackgroundColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawLine(const Offset(0, 0), handOffset, hourHandPaint);
  }

  /// drawing minute hand
  void _paintMinuteHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = dateTime.minute - 15.0;
    Offset handOffset = Offset(cos(getRadians(angle * 6.0)) * radius,
        sin(getRadians(angle * 6.0)) * radius);
    final hourHandPaint = Paint()
      ..color = Theme.of(context).scaffoldBackgroundColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawLine(const Offset(0, 0), handOffset, hourHandPaint);
  }

  void _paintSecondHand(Canvas canvas, double radius, double strokeWidth) {
    double angle = dateTime.second - 15.0;
    Offset handOffset = Offset(cos(getRadians(angle * 6.0)) * radius,
        sin(getRadians(angle * 6.0)) * radius);
    final hourHandPaint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawLine(const Offset(0, 0), handOffset, hourHandPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  static double getRadians(double angle) {
    return angle * pi / 180;
  }
}
