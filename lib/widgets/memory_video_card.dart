import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/birthday_controller.dart';

class MemoryVideoCard extends GetView<BirthdayController> {
  const MemoryVideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF0F7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E8C).withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                // Gradient accent bar
                Container(
                  width: 6,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Memory label — observes activeMemoryIndex
                Obx(() => Text(
                      controller
                          .memoryLabels[controller.activeMemoryIndex.value],
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A0060),
                        letterSpacing: 0.2,
                      ),
                    )),
                const Spacer(),
                // Play / Pause — observes isVideoPlaying
                GestureDetector(
                  onTap: controller.toggleVideo,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFFB388FF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() => Icon(
                          controller.isVideoPlaying.value
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        )),
                  ),
                ),
              ],
            ),
          ),

          // ── Video Area — observes isVideoInitialized ────────────────────────
          Obx(() {
            final initialized = controller.isVideoInitialized.value;
            final vc = controller.videoController;

            if (!initialized || vc == null) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildVideoPlaceholder(),
                ),
              );
            }

            final ratio = vc.value.aspectRatio;

            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // ── Video at native aspect ratio ──────────────────────────
                    AspectRatio(
                      aspectRatio: ratio > 0 ? ratio : 16 / 9,
                      child: VideoPlayer(vc),
                    ),

                    // ── Bottom vignette ───────────────────────────────────────
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.28),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // ── Volume badge — observes isVideoMuted ──────────────────
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Obx(() {
                        final muted = controller.isVideoMuted.value;
                        return GestureDetector(
                          onTap: controller.toggleMute,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  muted
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  muted ? 'Muted' : 'Sound',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Loading / error placeholder ─────────────────────────────────────────────
  Widget _buildVideoPlaceholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: const Color(0xFF1A0025),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.movie_creation_rounded,
                color: Color(0xFFFF6B9D),
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading memories...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 80,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFFFF6B9D)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
