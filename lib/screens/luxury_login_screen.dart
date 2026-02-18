import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math' as math;

// 🧠 BLoC
import '../bloc/auth_bloc.dart';

/// 🔐 Luxury Login Screen - CMO Loan App
/// ดีไซน์ตามกฎ .windsurfrules: Glassmorphism, Deep Navy, Sapphire Blue
/// เชื่อมกับ AuthBloc สำหรับ Authentication จริง
class LuxuryLoginScreen extends StatefulWidget {
  const LuxuryLoginScreen({super.key});

  @override
  State<LuxuryLoginScreen> createState() => _LuxuryLoginScreenState();
}

class _LuxuryLoginScreenState extends State<LuxuryLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  // 🎬 Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _elasticController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _elasticAnimation;

  // 🎨 Ultra-Modern Digital Banking Colors
  static const Color deepNavy = Color(0xFF002D62);
  static const Color sapphireBlue = Color(0xFF0F52BA);
  static const Color snowWhite = Color(0xFFF8FAFC);
  static const Color glassWhite = Color(0x26FFFFFF);
  static const Color edgeGlow = Color(0x40FFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color errorColor = Color(0xFFDC143C);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _elasticController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _elasticAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _elasticController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _elasticController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _elasticController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 🔐 เข้าสู่ระบบผ่าน AuthBloc
  void _login() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(LoginRequested(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

  /// ❌ แสดง Error SnackBar แบบ Premium 
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.kanit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth >= 1024;

    ScreenUtil.init(context, designSize: const Size(428, 926));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // ✅ Login สำเร็จ → ไป Dashboard
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state is AuthError) {
            // ❌ Login ผิดพลาด → แสดง Error
            _showErrorSnackBar(state.message);
          }
        },
        child: Scaffold(
          body: Container(
            decoration: _buildMeshGradientBackground(),
            child: _buildFullScreenLogin(isTablet, isLargeTablet, screenHeight),
          ),
        ),
      ),
    );
  }

  // 🌊 Mesh Gradient Background
  BoxDecoration _buildMeshGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          snowWhite,
          Color(0xFFEFF6FF), // Very light blue
          snowWhite,
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildFullScreenLogin(bool isTablet, bool isLargeTablet, double screenHeight) {
    return Column(
      children: [
        // 🎨 Header Section - 35% พร้อม Mesh Gradient
        Expanded(
          flex: 35,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [deepNavy, sapphireBlue],
              ),
            ),
            child: Stack(
              children: [
                // ✨ Mesh Pattern Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: LoginMeshGradientPainter(),
                  ),
                ),

                // 🔮 Decorative Orbs
                Positioned(
                  top: -30,
                  right: -40,
                  child: Container(
                    width: isTablet ? 200.w : 150.w,
                    height: isTablet ? 200.w : 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          sapphireBlue.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 📋 Header Content - กลางจอ
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),

                      // 🎨 Logo
                      Image.asset(
                        'assets/images/logoml_white.png',
                        width: isLargeTablet ? 220.w : 200.w,
                        height: isLargeTablet ? 80.h : 70.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.account_balance,
                            size: isTablet ? 50.sp : 40.sp,
                            color: Colors.white.withOpacity(0.8),
                          );
                        },
                      ),
                      SizedBox(height: isLargeTablet ? 20.h : 14.h),
                      
                      // 📝 Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'CMO APP',
                          style: GoogleFonts.inter(
                            fontSize: isLargeTablet ? 46.sp : 40.sp,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // 📋 Subtitle
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'ระบบสินเชื่อ',
                          style: GoogleFonts.kanit(
                            fontSize: isLargeTablet ? 16.sp : 14.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 📝 Form Section - 65% Frosted Glass
        Expanded(
          flex: 65,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildLuxuryLoginForm(isTablet, isLargeTablet),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLuxuryLoginForm(bool isTablet, bool isLargeTablet) {
    // 📐 ปรับขนาด container ตามหน้าจอ
    double containerWidth;
    if (isLargeTablet) {
      containerWidth = 600.w;
    } else if (isTablet) {
      containerWidth = 500.w;
    } else {
      containerWidth = double.infinity;
    }

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: containerWidth,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 60.w : 32.w,
            vertical: isTablet ? 50.h : 30.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 Username Field
                _buildLuxuryInputField(
                  controller: _usernameController,
                  label: 'รหัสพนักงาน',
                  hint: 'กรอกรหัสพนักงาน',
                  icon: FontAwesomeIcons.user,
                  isTablet: isTablet,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสพนักงาน';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isTablet ? 28.h : 22.h),

                // 🔒 Password Field
                _buildLuxuryInputField(
                  controller: _passwordController,
                  label: 'รหัสผ่าน',
                  hint: 'กรอกรหัสผ่าน',
                  icon: FontAwesomeIcons.lock,
                  obscureText: _obscurePassword,
                  isTablet: isTablet,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: textSecondary,
                      size: isTablet ? 20.sp : 18.sp,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isTablet ? 44.h : 36.h),

                // 🔑 Login Button (ใช้ BlocBuilder)
                _buildLuxuryLoginButton(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    bool isTablet = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🏷️ Label
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: isTablet ? 18.sp : 16.sp,
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 10.h : 8.h),
        
        // 🌊 Glassmorphism Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: deepNavy.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: deepNavy.withOpacity(0.02),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: isTablet ? 18.sp : 16.sp,
              color: textPrimary,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.kanit(
                color: textSecondary.withOpacity(0.6),
                fontSize: isTablet ? 16.sp : 14.sp,
                fontWeight: FontWeight.w300,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 12.w),
                child: Icon(
                  icon,
                  color: sapphireBlue.withOpacity(0.6),
                  size: isTablet ? 20.sp : 18.sp,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: isTablet ? 52.w : 48.w,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: sapphireBlue.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: errorColor,
                  width: 1.5,
                ),
              ),
              errorStyle: GoogleFonts.kanit(
                fontSize: 12.sp,
                color: errorColor,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: isTablet ? 18.h : 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔑 ปุ่ม Login พร้อม BlocBuilder สำหรับ Loading State
  Widget _buildLuxuryLoginButton(bool isTablet) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return ScaleTransition(
          scale: _elasticAnimation,
          child: Container(
            width: double.infinity,
            height: isTablet ? 60.h : 54.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isLoading
                    ? [deepNavy.withOpacity(0.7), sapphireBlue.withOpacity(0.7)]
                    : [deepNavy, sapphireBlue],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: deepNavy.withOpacity(isLoading ? 0.1 : 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: sapphireBlue.withOpacity(isLoading ? 0.05 : 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Center(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: isTablet ? 22.w : 20.w,
                            height: isTablet ? 22.w : 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'กำลังเข้าสู่ระบบ...',
                            style: GoogleFonts.kanit(
                              fontSize: isTablet ? 18.sp : 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.rightToBracket,
                            color: Colors.white,
                            size: isTablet ? 20.sp : 18.sp,
                          ),
                          SizedBox(width: isTablet ? 14.w : 10.w),
                          Text(
                            'เข้าสู่ระบบ',
                            style: GoogleFonts.kanit(
                              fontSize: isTablet ? 20.sp : 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

}

/// 🎨 Mesh Gradient Painter สำหรับ Header Background
class LoginMeshGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0DFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // วาดเส้นโค้ง subtle
    for (int i = 0; i < 6; i++) {
      final path = Path();
      final yOffset = (size.height / 6) * i;

      path.moveTo(0, yOffset);
      path.quadraticBezierTo(
        size.width * 0.3,
        yOffset + math.sin(i * 0.8) * 25,
        size.width * 0.6,
        yOffset - 10,
      );
      path.quadraticBezierTo(
        size.width * 0.8,
        yOffset + math.cos(i * 0.5) * 20,
        size.width,
        yOffset,
      );

      canvas.drawPath(path, paint);
    }

    // วาดวงกลม decorative เบาๆ
    final circlePaint = Paint()
      ..color = const Color(0x08FFFFFF)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      size.width * 0.25,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.7),
      size.width * 0.15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
