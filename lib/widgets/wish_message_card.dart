import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/birthday_controller.dart';

class WishMessageCard extends GetView<BirthdayController> {
  const WishMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: controller.cardSlide,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFD94FBE),
              Color(0xFFB388FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E8C).withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Sparkle icon with animation
                AnimatedBuilder(
                  animation: controller.sparkleAnim,
                  builder: (_, __) {
                    return Opacity(
                      opacity: controller.sparkleAnim.value,
                      child: const Text('✨', style: TextStyle(fontSize: 22)),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'A Special Wish',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: controller.sparkleAnim,
                  builder: (_, __) {
                    return Opacity(
                      opacity: 1 - (controller.sparkleAnim.value - 0.4) / 0.6,
                      child: const Text('✨', style: TextStyle(fontSize: 22)),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: 0.5),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Message
            Text(
              controller.birthdayMessage,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.65,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 18),

            // Sign off
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'With all my love 💕',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.favorite_rounded,
                    label: 'Send Love',
                    onTap: () => Get.snackbar(
                      '💕 Love Sent!',
                      'Your love has been delivered to ${controller.birthdayPersonName}!',
                      backgroundColor: Colors.white.withValues(alpha: 0.95),
                      colorText: const Color(0xFFE91E8C),
                      borderRadius: 16,
                      margin: const EdgeInsets.all(16),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.share_rounded,
                    label: 'Share',
                    onTap: () => Get.snackbar(
                      '🎉 Shared!',
                      'Birthday wish shared!',
                      backgroundColor: Colors.white.withValues(alpha: 0.95),
                      colorText: const Color(0xFFB388FF),
                      borderRadius: 16,
                      margin: const EdgeInsets.all(16),
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
