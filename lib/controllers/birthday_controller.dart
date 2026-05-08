import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ConfettiParticle {
  double x;
  double y;
  double speed;
  double angle;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
  bool isCircle;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class BalloonData {
  double x;
  double y;
  Color color;
  double size;
  double sway;
  double swaySpeed;
  double riseSpeed;

  BalloonData({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.sway,
    required this.swaySpeed,
    required this.riseSpeed,
  });
}

class BirthdayController extends GetxController
    with GetTickerProviderStateMixin {
  // ─── Observables ───────────────────────────────────────────────────────────
  final RxBool isVideoInitialized = false.obs;
  final RxBool isVideoPlaying = false.obs;
  final RxBool isVideoMuted = false.obs;
  final RxDouble titleScale = 1.0.obs;
  final RxBool showWishCard = false.obs;
  final RxInt activeMemoryIndex = 0.obs;

  // ─── Animation Controllers ─────────────────────────────────────────────────
  late AnimationController titlePulseController;
  late AnimationController confettiController;
  late AnimationController glowController;
  late AnimationController balloonController;
  late AnimationController cardSlideController;
  late AnimationController sparkleController;

  // ─── Animations ───────────────────────────────────────────────────────────
  late Animation<double> titlePulse;
  late Animation<double> glowAnimation;
  late Animation<Offset> cardSlide;
  late Animation<double> sparkleAnim;

  // ─── Video Player ──────────────────────────────────────────────────────────
  VideoPlayerController? videoController;

  // ─── Confetti & Balloons ───────────────────────────────────────────────────
  final List<ConfettiParticle> confettiParticles = [];
  final List<BalloonData> balloons = [];
  final Random _random = Random();

  // ─── Data ──────────────────────────────────────────────────────────────────
  final String birthdayPersonName = "Zahra Mottay";
  final String birthdayMessage = "Every moment with you is a gift. "
      "May this special day be wrapped in joy, "
      "tied with laughter, and filled with all the love "
      "you so beautifully give to the world. 🌸✨";

  final List<String> memoryLabels = [
    "Sweet Memories 🌸",
    "Beautiful Moments ✨",
    "Forever Cherished 💕",
  ];

  final List<Color> confettiColors = [
    const Color(0xFFFF6B9D),
    const Color(0xFFFFD700),
    const Color(0xFF9B59B6),
    const Color(0xFF3498DB),
    const Color(0xFF2ECC71),
    const Color(0xFFFF8C42),
    const Color(0xFFFF6B6B),
    const Color(0xFF48CAE4),
  ];

  final List<Color> balloonColors = [
    const Color(0xFFFF6B9D),
    const Color(0xFFB388FF),
    const Color(0xFF80DEEA),
    const Color(0xFFFFD54F),
    const Color(0xFFEF9A9A),
    const Color(0xFFA5D6A7),
  ];

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    _initConfetti();
    _initBalloons();
    _initVideo();
    _startSequence();
  }

  void _initAnimations() {
    // Title pulse
    titlePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    titlePulse = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: titlePulseController, curve: Curves.easeInOut),
    );

    // Glow
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    glowAnimation = Tween<double>(begin: 8.0, end: 22.0).animate(
      CurvedAnimation(parent: glowController, curve: Curves.easeInOut),
    );

    // Confetti driver
    confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Balloons
    balloonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Card slide
    cardSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: cardSlideController, curve: Curves.elasticOut),
    );

    // Sparkle
    sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    sparkleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: sparkleController, curve: Curves.easeInOut),
    );
  }

  void _initConfetti() {
    for (int i = 0; i < 60; i++) {
      confettiParticles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.003 + _random.nextDouble() * 0.005,
        angle: _random.nextDouble() * 2 * pi,
        color: confettiColors[_random.nextInt(confettiColors.length)],
        size: 4 + _random.nextDouble() * 8,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.15,
        isCircle: _random.nextBool(),
      ));
    }
  }

  void _initBalloons() {
    for (int i = 0; i < 6; i++) {
      balloons.add(BalloonData(
        x: 0.05 + _random.nextDouble() * 0.9,
        y: 0.6 + _random.nextDouble() * 0.4,
        color: balloonColors[i % balloonColors.length],
        size: 28 + _random.nextDouble() * 20,
        sway: (_random.nextDouble() - 0.5) * 0.05,
        swaySpeed: 0.5 + _random.nextDouble(),
        riseSpeed: 0.0015 + _random.nextDouble() * 0.002,
      ));
    }
  }

  void _initVideo() {
    videoController = VideoPlayerController.asset(
      'assets/videos/vid.mp4',
    )..initialize().then((_) {
        isVideoInitialized.value = true;
        videoController!.setLooping(true);
        videoController!.setVolume(1.0);
        isVideoMuted.value = false;
        videoController!.play();
        isVideoPlaying.value = true;
      }).catchError((e) {
        isVideoInitialized.value = false;
      });
  }

  void toggleMute() {
    if (videoController == null) return;
    final mute = !isVideoMuted.value;
    videoController!.setVolume(mute ? 0.0 : 1.0);
    isVideoMuted.value = mute;
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 600));
    cardSlideController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    showWishCard.value = true;
  }

  // ─── Update loop for confetti & balloons ───────────────────────────────────
  void updateParticles() {
    for (var p in confettiParticles) {
      p.y += p.speed;
      p.x += sin(p.angle) * 0.002;
      p.rotation += p.rotationSpeed;
      if (p.y > 1.1) {
        p.y = -0.1;
        p.x = _random.nextDouble();
      }
    }
    for (var b in balloons) {
      b.y -= b.riseSpeed;
      b.x += sin(b.y * 10 * b.swaySpeed) * b.sway * 0.01;
      if (b.y < -0.25) {
        b.y = 1.1;
        b.x = 0.05 + _random.nextDouble() * 0.9;
      }
    }
  }

  void toggleVideo() {
    if (videoController == null) return;
    if (isVideoPlaying.value) {
      videoController!.pause();
      isVideoPlaying.value = false;
    } else {
      videoController!.play();
      isVideoPlaying.value = true;
    }
  }

  void cycleMemory() {
    activeMemoryIndex.value =
        (activeMemoryIndex.value + 1) % memoryLabels.length;
  }

  @override
  void onClose() {
    titlePulseController.dispose();
    confettiController.dispose();
    glowController.dispose();
    balloonController.dispose();
    cardSlideController.dispose();
    sparkleController.dispose();
    videoController?.dispose();
    super.onClose();
  }
}
