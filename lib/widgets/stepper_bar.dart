import 'dart:math' as math;
import 'package:flutter/material.dart';

class StepperBar extends StatelessWidget {
  final double progress; 
  const StepperBar({super.key, this.progress = 0.4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavyStepperPainter(progress),
      ),
    );
  }
}

class _WavyStepperPainter extends CustomPainter {
  final double progress;
  _WavyStepperPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final waveAmplitude = 2.0;
    final waveLength = 15.0;
    final strokeWidth = 3.0;
    final inset = 18.0;

    final startX = inset;
    final endX = size.width - inset;
    final midY = size.height / 2;
    final totalWidth = endX - startX;
    final progressX = startX + totalWidth * progress.clamp(0.0, 1.0);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF9AA2FF), Color(0xFF6C75FF)],
      ).createShader(Rect.fromLTWH(startX, 0, progressX, size.height));

    final inactivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.25);

    final activePath = Path();
    final inactivePath = Path();

    bool firstActivePoint = true;
    bool firstInactivePoint = true;

    for (double x = startX; x <= endX; x += 0.8) {
      final y = midY + math.sin((x / waveLength) * 2 * math.pi) * waveAmplitude;

      if (x <= progressX) {
        if (firstActivePoint) {
          activePath.moveTo(x, y);
          firstActivePoint = false;
        } else {
          activePath.lineTo(x, y);
        }
      } else {
        if (firstInactivePoint) {
          inactivePath.moveTo(x, y);
          firstInactivePoint = false;
        } else {
          inactivePath.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(activePath, activePaint);
    canvas.drawPath(inactivePath, inactivePaint);
  }

  @override
  bool shouldRepaint(covariant _WavyStepperPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
