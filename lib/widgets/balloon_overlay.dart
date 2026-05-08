import 'package:flutter/material.dart';
import '../controllers/birthday_controller.dart';

class BalloonPainter extends CustomPainter {
  final List<BalloonData> balloons;
  final double animValue;

  BalloonPainter({required this.balloons, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in balloons) {
      final cx = b.x * size.width;
      final cy = b.y * size.height;
      final r = b.size;

      // String
      final stringPaint = Paint()
        ..color = b.color.withValues(alpha: 0.5)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(cx, cy + r)
        ..quadraticBezierTo(cx + 8, cy + r + 20, cx, cy + r + 38);
      canvas.drawPath(path, stringPaint);

      // Body gradient
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.85,
        colors: [
          b.color.withValues(alpha: 0.95),
          b.color.withValues(alpha: 0.7),
          b.color.withValues(alpha: 0.85),
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      final balloonRect = Rect.fromCircle(
        center: Offset(cx, cy),
        radius: r,
      );

      final bodyPaint = Paint()
        ..shader = gradient.createShader(balloonRect)
        ..style = PaintingStyle.fill;

      // Balloon oval shape
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: r * 2,
          height: r * 2.3,
        ),
        bodyPaint,
      );

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - r * 0.25, cy - r * 0.3),
          width: r * 0.5,
          height: r * 0.35,
        ),
        highlightPaint,
      );

      // Knot
      final knotPaint = Paint()
        ..color = b.color.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy + r + 2), 3, knotPaint);
    }
  }

  @override
  bool shouldRepaint(BalloonPainter old) => true;
}

class BalloonOverlay extends StatelessWidget {
  final BirthdayController controller;

  const BalloonOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.balloonController,
      builder: (_, __) {
        return CustomPaint(
          painter: BalloonPainter(
            balloons: controller.balloons,
            animValue: controller.balloonController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}
