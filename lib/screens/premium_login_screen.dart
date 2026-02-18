import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class PremiumLoginScreen extends StatefulWidget {
  const PremiumLoginScreen({super.key});

  @override
  State<PremiumLoginScreen> createState() => _PremiumLoginScreenState();
}

class _PremiumLoginScreenState extends State<PremiumLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Premium Material Colors (ตามกฎใหม่)
  static const Color deepNavy = Color(0xFF002D62); // Deep Navy
  static const Color sapphireBlue = Color(0xFF0F52BA); // Sapphire Blue
  static const Color glassWhite = Color(0x1FFFFFFF); // White-Opacity 12%
  static const Color edgeHighlight = Color(0x4DFFFFFF); // White-Opacity 30%
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color error = Color(0xFFDC143C);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('เกิดข้อผิดพลาด: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth >= 1024;

    ScreenUtil.init(context, designSize: const Size(420, 800));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf0f9ff),
              Color(0xFFe0f2fe),
            ],
          ),
        ),
        child: _buildFullScreenLogin(isTablet, isLargeTablet, screenHeight),
      ),
    );
  }

  Widget _buildFullScreenLogin(bool isTablet, bool isLargeTablet, double screenHeight) {
    return Column(
      children: [
        // Header Section - 30% of screen height
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [deepNavy, sapphireBlue],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logoml_white.png',
                  width: isLargeTablet ? 200.w : 180.w,
                  height: isLargeTablet ? 70.h : 60.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: isLargeTablet ? 24.h : 20.h),
                Text(
                  'CMO APP',
                  style: GoogleFonts.inter(
                    fontSize: isLargeTablet ? 42.sp : 38.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Form Section - 70% of screen height
        Expanded(
          flex: 7,
          child: Container(
            width: double.infinity,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildPremiumLoginForm(isTablet, isLargeTablet),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumLoginCard(bool isTablet, bool isLargeTablet) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    double containerWidth;
    if (isLargeTablet) {
      containerWidth = 500.w;
    } else if (isTablet) {
      containerWidth = 450.w;
    } else {
      containerWidth = screenWidth > 420 ? 420.w : screenWidth * 0.9;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: containerWidth,
          constraints: BoxConstraints(
            maxWidth: isLargeTablet ? 500 : 420,
            minWidth: 300,
          ),
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
            border: Border.all(
              color: edgeHighlight,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: deepNavy.withOpacity(0.08),
                blurRadius: 25,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: sapphireBlue.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 20),
                spreadRadius: -10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPremiumHeader(isTablet),
                  _buildPremiumLoginForm(isTablet, isLargeTablet),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.w : 20.w,
        vertical: isTablet ? 40.h : 32.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepNavy, sapphireBlue],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTablet ? 24.r : 20.r),
          topRight: Radius.circular(isTablet ? 24.r : 20.r),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logoml_white.png',
            width: isTablet ? 180.w : 150.w,
            height: isTablet ? 60.h : 50.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: isTablet ? 20.h : 16.h),
          Text(
            'CMO APP',
            style: GoogleFonts.inter(
              fontSize: isTablet ? 36.sp : 32.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumLoginForm(bool isTablet, bool isLargeTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 60.w : 40.w,
        vertical: isTablet ? 80.h : 60.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username Field
            _buildPremiumInputField(
              controller: _usernameController,
              label: 'ชื่อผู้ใช้',
              hint: 'กรอกชื่อผู้ใช้',
              icon: FontAwesomeIcons.user,
              isTablet: isTablet,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อผู้ใช้';
                }
                return null;
              },
            ),
            SizedBox(height: isTablet ? 32.h : 28.h),

            // Password Field
            _buildPremiumInputField(
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
                  size: isTablet ? 22.sp : 20.sp,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
                return null;
              },
            ),
            SizedBox(height: isTablet ? 48.h : 40.h),

            // Login Button
            _buildPremiumLoginButton(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    bool isTablet = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isTablet ? 22.sp : 20.sp,
            fontWeight: FontWeight.w300,
            color: textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 12.h : 10.h),
        
        // Glassmorphism Input Field (ไม่มีกรอบ)
        Container(
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(isTablet ? 16.r : 14.r),
            boxShadow: [
              BoxShadow(
                color: deepNavy.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isTablet ? 16.r : 14.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                validator: validator,
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 22.sp : 20.sp,
                  color: textPrimary,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.inter(
                    color: textSecondary,
                    fontSize: isTablet ? 22.sp : 20.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: textSecondary,
                    size: isTablet ? 24.sp : 22.sp,
                  ),
                  suffixIcon: suffixIcon,
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.w : 20.w,
                    vertical: isTablet ? 18.h : 16.h,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumLoginButton(bool isTablet) {
    return Container(
      width: double.infinity,
      height: isTablet ? 72.h : 64.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [deepNavy, sapphireBlue],
        ),
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: deepNavy.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: sapphireBlue.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: isTablet ? 28.w : 24.w,
                  height: isTablet ? 28.w : 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.7),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.rightToBracket,
                      color: Colors.white,
                      size: isTablet ? 24.sp : 22.sp,
                    ),
                    SizedBox(width: isTablet ? 16.w : 12.w),
                    Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.inter(
                        fontSize: isTablet ? 30.sp : 28.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
