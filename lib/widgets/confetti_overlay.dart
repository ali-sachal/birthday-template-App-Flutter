import 'package:flutter/material.dart';
import '../controllers/birthday_controller.dart';

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animValue;

  ConfettiPainter({required this.particles, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      final x = p.x * size.width;
      final y = p.y * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.5,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter old) => true;
}

class ConfettiOverlay extends StatelessWidget {
  final BirthdayController controller;

  const ConfettiOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.confettiController,
      builder: (_, __) {
        controller.updateParticles();
        return CustomPaint(
          painter: ConfettiPainter(
            particles: controller.confettiParticles,
            animValue: controller.confettiController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}
