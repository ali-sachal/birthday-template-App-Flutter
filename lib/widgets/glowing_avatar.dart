import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/birthday_controller.dart';

class GlowingAvatar extends GetView<BirthdayController> {
  const GlowingAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.glowAnimation,
      builder: (_, __) {
        return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withValues(alpha: 0.6),
                blurRadius: controller.glowAnimation.value,
                spreadRadius: controller.glowAnimation.value * 0.4,
              ),
              BoxShadow(
                color: const Color(0xFFB388FF).withValues(alpha: 0.4),
                blurRadius: controller.glowAnimation.value * 1.5,
                spreadRadius: controller.glowAnimation.value * 0.2,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFB388FF),
                  Color(0xFF80DEEA),
                ],
              ),
              border: Border.all(color: Colors.white, width: 3.5),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: Image.asset(
                "assets/images/zahra.jpg",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFFD6E7),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: Color(0xFFE91E8C),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
