import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math' as math;

/// 🌟 Premium Splash Screen - CMO Loan App
/// ดีไซน์ตามกฎ .windsurfrules: Glassmorphism, Deep Navy, Sapphire Blue
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // 🎬 Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  // 🎭 Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  // 🎨 Ultra-Modern Digital Banking Colors
  static const Color deepNavy = Color(0xFF002D62);
  static const Color sapphireBlue = Color(0xFF0F52BA);
  static const Color glassWhite = Color(0x26FFFFFF);
  static const Color edgeGlow = Color(0x40FFFFFF);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateAfterDelay();
  }

  void _initAnimations() {
    // Fade in จาก 0 → 1
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Scale จาก 0.6 → 1.0 (Elastic)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Slide ข้อความจากล่างขึ้น
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Pulse สำหรับ Loading Indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shimmer สำหรับ background effect
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // ⏱️ เริ่ม Animation ทีละตัว (staggered)
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _slideController.forward();
    });
  }

  /// 🔄 ไปหน้า Login หลังจากแสดง Splash 2.5 วินาที
  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    ScreenUtil.init(context, designSize: const Size(428, 926));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // 🌊 พื้นหลัง Gradient Navy → Sapphire
            _buildGradientBackground(),

            // ✨ Animated Mesh Pattern
            _buildAnimatedMeshPattern(),

            // 🔮 Glassmorphism Floating Orbs
            _buildFloatingOrbs(isTablet),

            // 📋 เนื้อหาหลัก (Logo + ข้อความ + Loading)
            _buildMainContent(isTablet),
          ],
        ),
      ),
    );
  }

  /// 🌊 Gradient Background สวยงาม
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            deepNavy,
            Color(0xFF0A3D7F),
            sapphireBlue,
            Color(0xFF0D47A1),
            deepNavy,
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
    );
  }

  /// ✨ Animated Mesh Pattern Overlay
  Widget _buildAnimatedMeshPattern() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: SplashMeshPainter(
            animationValue: _shimmerAnimation.value,
          ),
        );
      },
    );
  }

  /// 🔮 Glassmorphism Floating Orbs (ลูกกลมเรืองแสง)
  Widget _buildFloatingOrbs(bool isTablet) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        return Stack(
          children: [
            // Orb 1 - มุมบนซ้าย
            Positioned(
              top: screenSize.height * 0.1,
              left: -screenSize.width * 0.15,
              child: _buildOrb(
                size: isTablet ? 250.w : 200.w,
                opacity: 0.06,
                offset: _shimmerAnimation.value * 20,
              ),
            ),
            // Orb 2 - กลางขวา
            Positioned(
              top: screenSize.height * 0.4,
              right: -screenSize.width * 0.1,
              child: _buildOrb(
                size: isTablet ? 180.w : 150.w,
                opacity: 0.08,
                offset: -_shimmerAnimation.value * 15,
              ),
            ),
            // Orb 3 - มุมล่าง
            Positioned(
              bottom: screenSize.height * 0.05,
              left: screenSize.width * 0.2,
              child: _buildOrb(
                size: isTablet ? 300.w : 220.w,
                opacity: 0.05,
                offset: _shimmerAnimation.value * 10,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb({
    required double size,
    required double opacity,
    required double offset,
  }) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              sapphireBlue.withOpacity(opacity * 2),
              sapphireBlue.withOpacity(opacity),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  /// 📋 เนื้อหาหลัก
  Widget _buildMainContent(bool isTablet) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            // 🎨 Logo (Fade + Scale Animation)
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildLogo(isTablet),
              ),
            ),

            SizedBox(height: isTablet ? 40.h : 32.h),

            // 📝 App Name (Slide + Fade Animation)
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAppName(isTablet),
              ),
            ),

            SizedBox(height: isTablet ? 12.h : 8.h),

            // 📋 Subtitle
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'ระบบสินเชื่อ',
                  style: GoogleFonts.kanit(
                    fontSize: isTablet ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // ⏳ Loading Indicator (Pulse Animation)
            _buildLoadingIndicator(isTablet),

            SizedBox(height: isTablet ? 16.h : 12.h),

            // 🏷️ Version Text
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'v1.0.0',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 12.sp : 10.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),

            SizedBox(height: isTablet ? 40.h : 30.h),
          ],
        ),
      ),
    );
  }

  /// 🎨 Logo ตรงๆ ไม่มีกรอบ + ขนาดปรับตามหน้าจอ
  Widget _buildLogo(bool isTablet) {
    double logoWidth = isTablet ? 220.w : 180.w;
    double logoHeight = isTablet ? 80.h : 65.h;

    return Image.asset(
      'assets/images/logoml_white.png',
      width: logoWidth,
      height: logoHeight,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // 🔄 Placeholder ถ้าไม่พบรูป
        return Container(
          width: logoWidth,
          height: logoHeight,
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: edgeGlow, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Center(
                child: Icon(
                  Icons.account_balance,
                  size: isTablet ? 40.sp : 32.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 📝 ชื่อแอป "CMO APP" แบบ Premium
  Widget _buildAppName(bool isTablet) {
    return Text(
      'CMO APP',
      style: GoogleFonts.inter(
        fontSize: isTablet ? 46.sp : 40.sp,
        fontWeight: FontWeight.w200,
        color: Colors.white,
        letterSpacing: 6,
      ),
    );
  }

  /// ⏳ Loading Indicator สวยงามพร้อม Pulse
  Widget _buildLoadingIndicator(bool isTablet) {
    return FadeTransition(
      opacity: _pulseAnimation,
      child: Column(
        children: [
          // Custom Loading Bar
          Container(
            width: isTablet ? 120.w : 80.w,
            height: 3.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.r),
              color: Colors.white.withOpacity(0.1),
            ),
            child: AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _shimmerAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: isTablet ? 16.h : 12.h),
          Text(
            'กำลังโหลด...',
            style: GoogleFonts.kanit(
              fontSize: isTablet ? 14.sp : 12.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 Mesh Pattern Painter สำหรับ Splash Background
class SplashMeshPainter extends CustomPainter {
  final double animationValue;

  SplashMeshPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // วาดเส้นโค้ง subtle ตาม animation
    final double offset = animationValue * size.height * 0.1;

    for (int i = 0; i < 5; i++) {
      paint.color = Colors.white.withOpacity(0.02 + (i * 0.005));
      final path = Path();
      final yStart = (size.height / 5) * i + offset;

      path.moveTo(0, yStart);
      path.quadraticBezierTo(
        size.width * 0.25,
        yStart + math.sin(animationValue * math.pi * 2 + i) * 30,
        size.width * 0.5,
        yStart,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        yStart - math.sin(animationValue * math.pi * 2 + i) * 30,
        size.width,
        yStart,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SplashMeshPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
