import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/birthday_controller.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/balloon_overlay.dart';
import '../widgets/glowing_avatar.dart';
import '../widgets/memory_video_card.dart';
import '../widgets/wish_message_card.dart';
import 'memories_screen.dart';

class BirthdayScreen extends GetView<BirthdayController> {
  const BirthdayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Gradient background ──────────────────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFC6D9), // soft pink
                  Color(0xFFEDD5FF), // lavender
                  Color(0xFFD0F0FF), // baby blue
                  Color(0xFFFFE4F0), // blush
                ],
                stops: [0.0, 0.38, 0.72, 1.0],
              ),
            ),
          ),

          // ── 2. Soft bokeh circles ───────────────────────────────────────────
          ..._buildBokehCircles(size),

          // ── 3. Balloon overlay (bottom layer) ──────────────────────────────
          Positioned.fill(child: BalloonOverlay(controller: controller)),

          // ── 4. Main scrollable content ──────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // ── Title ─────────────────────────────────────────────────
                  AnimatedBuilder(
                    animation: controller.titlePulse,
                    builder: (_, child) => Transform.scale(
                      scale: controller.titlePulse.value,
                      child: child,
                    ),
                    child: _buildTitle(),
                  ),

                  const SizedBox(height: 8),

                  // Sub-tagline
                  _buildSubTagline(),

                  const SizedBox(height: 28),

                  // ── Avatar ────────────────────────────────────────────────
                  const GlowingAvatar(),

                  const SizedBox(height: 14),

                  // Name badge
                  _buildNameBadge(),

                  const SizedBox(height: 28),

                  // ── Star divider ─────────────────────────────────────────
                  _buildStarDivider(),

                  const SizedBox(height: 22),

                  // ── Video memory card ─────────────────────────────────────
                  const MemoryVideoCard(),

                  const SizedBox(height: 22),

                  // ── Wish message card ─────────────────────────────────────
                  Obx(() => AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: controller.showWishCard.value ? 1.0 : 0.0,
                        child: const WishMessageCard(),
                      )),

                  const SizedBox(height: 30),

                  // Footer
                  _buildFooter(),

                  // Extra bottom padding for nav bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── 5. Confetti overlay (top layer) ────────────────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: ConfettiOverlay(controller: controller),
            ),
          ),

          // ── 6. Floating bottom nav bar ─────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BirthdayBottomBar(),
          ),
        ],
      ),
    );
  }

  // ─── Helper builders ────────────────────────────────────────────────────────

  List<Widget> _buildBokehCircles(Size size) {
    final positions = [
      [0.0, 0.0, 180.0, const Color(0xFFFFB3D1)],
      [1.0, 0.15, 140.0, const Color(0xFFD5A0FF)],
      [0.1, 0.55, 120.0, const Color(0xFFB3E5FC)],
      [0.85, 0.65, 160.0, const Color(0xFFFFCCE5)],
    ];

    return positions.map((p) {
      return Positioned(
        left: (p[0] as double) * size.width - (p[2] as double) / 2,
        top: (p[1] as double) * size.height - (p[2] as double) / 2,
        child: Container(
          width: p[2] as double,
          height: p[2] as double,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (p[3] as Color).withValues(alpha: 0.25),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFFE91E8C),
              Color(0xFF9C27B0),
              Color(0xFFFF6B9D),
            ],
          ).createShader(bounds),
          child: const Text(
            'Happy Birthday',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const Text(
          '🎉',
          style: TextStyle(fontSize: 36),
        ),
      ],
    );
  }

  Widget _buildSubTagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withValues(alpha: 0.15),
            const Color(0xFFB388FF).withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE91E8C).withValues(alpha: 0.25),
        ),
      ),
      child: const Text(
        '🎂  Today is your magical day  🎂',
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6A006A),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildNameBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🌸', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(
          controller.birthdayPersonName,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4A0060),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(width: 6),
        const Text('🌸', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildStarDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) {
        final isCenter = i == 3;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            isCenter ? '⭐' : '·',
            style: TextStyle(
              fontSize: isCenter ? 20 : 22,
              color: isCenter
                  ? null
                  : const Color(0xFFE91E8C).withValues(alpha: 0.5),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['🎈', '🎊', '🎁', '🎀', '🎆'].map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(e, style: const TextStyle(fontSize: 22)),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Text(
          'Made with 💕 just for you',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// ─── Floating Pill Bottom Navigation Bar ────────────────────────────────────

class _BirthdayBottomBar extends StatefulWidget {
  @override
  State<_BirthdayBottomBar> createState() => _BirthdayBottomBarState();
}

class _BirthdayBottomBarState extends State<_BirthdayBottomBar> {
  int _selectedIndex = 0;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.photo_album_rounded, label: 'Memories'),
    // _NavItem(icon: Icons.card_giftcard_rounded, label: 'Gifts'),
    // _NavItem(icon: Icons.favorite_rounded, label: 'Messages'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E8C).withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                if (index == 1) {
                  // Memories tab → open Memories screen
                  Get.to(
                    () => const MemoriesScreen(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                  );
                } else {
                  setState(() => _selectedIndex = index);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 18 : 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFE91E8C), Color(0xFFB388FF)],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFE91E8C).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _items[index].icon,
                      size: 22,
                      color:
                          isSelected ? Colors.white : const Color(0xFFB0B0C0),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        _items[index].label,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
