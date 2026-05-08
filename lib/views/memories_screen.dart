import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/birthday_controller.dart';
import '../widgets/balloon_overlay.dart';

class MemoriesScreen extends GetView<BirthdayController> {
  const MemoriesScreen({super.key});

  static const List<_MemoryPhoto> _photos = [
    _MemoryPhoto(
      asset: 'assets/images/1.jpg',
      caption: 'Your first adventure 🌸',
      // date: '^ sEpt 2025',
    ),
    _MemoryPhoto(
      asset: 'assets/images/2.jpg',
      caption: 'That magical sunset ✨',
      // date: 'July 2021',
    ),
    _MemoryPhoto(
      asset: 'assets/images/3.jpg',
      caption: 'Laughing till it hurt 😂',
      // date: 'November 2021',
    ),
    _MemoryPhoto(
      asset: 'assets/images/4.jpg',
      caption: 'Coffee & good vibes ☕',
      // date: 'February 2022',
    ),
    _MemoryPhoto(
      asset: 'assets/images/5.jpg',
      caption: 'Beach day memories 🌊',
      // date: 'June 2022',
    ),
    _MemoryPhoto(
      asset: 'assets/images/10.jpg',
      caption: 'Besties forever 💕',
      // date: 'August 2022',
    ),
    _MemoryPhoto(
      asset: 'assets/images/11.jpg',
      caption: 'Late night talks 🌙',
      // date: 'October 2022',
    ),
    _MemoryPhoto(
      asset: 'assets/images/12.jpg',
      caption: 'The best birthday 🎂',
      // date: 'January 2023',
    ),
    _MemoryPhoto(
      asset: 'assets/images/13.jpg',
      caption: 'Chasing flowers 🌺',
      // date: 'April 2023',
    ),
    _MemoryPhoto(
      asset: 'assets/images/14.jpg',
      caption: 'Always smiling 😊',
      // date: 'September 2023',
    ),
    _MemoryPhoto(
      asset: 'assets/images/zahra.jpg',
      caption: 'Forever in my heart 💖',
      // date: 'Special Memory',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient background ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFC6D9),
                  Color(0xFFEDD5FF),
                  Color(0xFFD0F0FF),
                  Color(0xFFFFE4F0),
                ],
                stops: [0.0, 0.38, 0.72, 1.0],
              ),
            ),
          ),

          // ── Bokeh circles ───────────────────────────────────────────────────
          ..._buildBokehCircles(size),

          // ── Balloon overlay ─────────────────────────────────────────────────
          Positioned.fill(child: BalloonOverlay(controller: controller)),

          // ── Main content ────────────────────────────────────────────────────
          const SafeArea(
            child: _MemoriesBody(photos: MemoriesScreen._photos),
          ),
        ],
      ),
    );
  }

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
}

// ─── Stateful body (owns PageController & likes state) ──────────────────────

class _MemoriesBody extends StatefulWidget {
  final List<_MemoryPhoto> photos;
  const _MemoriesBody({required this.photos});

  @override
  State<_MemoriesBody> createState() => _MemoriesBodyState();
}

class _MemoriesBodyState extends State<_MemoriesBody> {
  late final PageController _pageCtrl;
  int _currentPage = 0;
  final Set<int> _liked = {};

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 0.88);
    _pageCtrl.addListener(() {
      final page = _pageCtrl.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _prev() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _next() {
    if (_currentPage < widget.photos.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ───────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E8C).withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFE91E8C),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFE91E8C), Color(0xFF9C27B0)],
                      ).createShader(bounds),
                      child: const Text(
                        'Our Memories',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.photos.length} precious moments 📸',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Counter badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E8C).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${_currentPage + 1} / ${widget.photos.length}',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── Heart divider ─────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (i) {
            final isCenter = i == 3;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                isCenter ? '💕' : '·',
                style: TextStyle(
                  fontSize: isCenter ? 18 : 20,
                  color: isCenter
                      ? null
                      : const Color(0xFFE91E8C).withValues(alpha: 0.4),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 14),

        // ── Carousel ─────────────────────────────────────────────────────────
        Expanded(
          child: PageView.builder(
            controller: _pageCtrl,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              final isActive = index == _currentPage;
              return _CarouselCard(
                photo: widget.photos[index],
                isActive: isActive,
                isLiked: _liked.contains(index),
                onLike: () => setState(() {
                  if (_liked.contains(index)) {
                    _liked.remove(index);
                  } else {
                    _liked.add(index);
                  }
                }),
              );
            },
          ),
        ),

        const SizedBox(height: 18),

        // ── Dot indicators ────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.photos.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                      )
                    : null,
                color: isActive
                    ? null
                    : const Color(0xFFE91E8C).withValues(alpha: 0.25),
              ),
            );
          }),
        ),

        const SizedBox(height: 18),

        // ── Prev / Next arrows ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
          child: Row(
            children: [
              // Prev
              _NavArrow(
                icon: Icons.chevron_left_rounded,
                enabled: _currentPage > 0,
                onTap: _prev,
              ),
              const Spacer(),
              // Caption in the middle
              Expanded(
                flex: 6,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    widget.photos[_currentPage].caption,
                    key: ValueKey(_currentPage),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A0060),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Spacer(),
              // Next
              _NavArrow(
                icon: Icons.chevron_right_rounded,
                enabled: _currentPage < widget.photos.length - 1,
                onTap: _next,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Carousel Card ───────────────────────────────────────────────────────────

class _CarouselCard extends StatefulWidget {
  final _MemoryPhoto photo;
  final bool isActive;
  final bool isLiked;
  final VoidCallback onLike;

  const _CarouselCard({
    required this.photo,
    required this.isActive,
    required this.isLiked,
    required this.onLike,
  });

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> {
  void _openFullScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) => _FullScreenPhoto(photo: widget.photo),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isActive ? 1.0 : 0.92,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: widget.isActive ? 1.0 : 0.65,
        duration: const Duration(milliseconds: 350),
        child: GestureDetector(
          onTap: _openFullScreen,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE91E8C).withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.85),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Photo ──────────────────────────────────────────────────
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.photo.asset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFD6E7),
                                  Color(0xFFEDD5FF),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.image_rounded,
                              color: Color(0xFFE91E8C),
                              size: 50,
                            ),
                          ),
                        ),

                        // Gradient vignette
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 90,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // "Tap to view" hint (only when active)
                        if (widget.isActive)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Text(
                                  '👆 Tap to view full',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Like button (top-right)
                        // Positioned(
                        //   top: 12,
                        //   right: 12,
                        //   child: GestureDetector(
                        //     onTap: widget.onLike,
                        //     child: AnimatedContainer(
                        //       duration: const Duration(milliseconds: 250),
                        //       width: 38,
                        //       height: 38,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: widget.isLiked
                        //             ? const Color(0xFFFF6B9D)
                        //             : Colors.white.withValues(alpha: 0.85),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color:
                        //                 Colors.black.withValues(alpha: 0.12),
                        //             blurRadius: 8,
                        //             offset: const Offset(0, 3),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Icon(
                        //         widget.isLiked
                        //             ? Icons.favorite_rounded
                        //             : Icons.favorite_border_rounded,
                        //         size: 19,
                        //         color: widget.isLiked
                        //             ? Colors.white
                        //             : const Color(0xFFE91E8C),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // ── Bottom info bar ─────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.photo.caption,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF4A0060),
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 10,
                                  color: Color(0xFFB388FF),
                                ),
                                SizedBox(width: 4),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Expand icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                          ),
                        ),
                        child: const Icon(
                          Icons.open_in_full_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Navigation Arrow Button ─────────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                )
              : null,
          color: enabled ? null : Colors.white.withValues(alpha: 0.5),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFE91E8C).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 24,
          color: enabled
              ? Colors.white
              : const Color(0xFFB0B0C0).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// ─── Full-screen Photo Viewer ────────────────────────────────────────────────

class _FullScreenPhoto extends StatelessWidget {
  final _MemoryPhoto photo;
  const _FullScreenPhoto({required this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Tap anywhere to close',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFD6E7), Color(0xFFEDD5FF)],
                        ),
                      ),
                      child: const Icon(Icons.image_rounded,
                          color: Color(0xFFE91E8C), size: 60),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      photo.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 11, color: Colors.white70),
                        SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────

class _MemoryPhoto {
  final String asset;
  final String caption;
  const _MemoryPhoto({
    required this.asset,
    required this.caption,
  });
}
