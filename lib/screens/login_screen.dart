import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_app_mobile/config/app_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Navy Theme Colors ตรงกับต้นฉบับ
  static const Color navy = Color(0xFF1e3a8a);
  static const Color blue = Color(0xFF1e40af);
  static const Color sky = Color(0xFFdbeafe);
  static const Color green = Color(0xFF059669);
  static const Color red = Color(0xFFdc2626);
  static const Color gray = Color(0xFF6b7280);
  static const Color light = Color(0xFFf8fafc);
  static const Color border = Color(0xFFe2e8f0);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: เชื่อมต่อกับ API Backend
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Navigate to Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth >= 1024;

    // Initialize ScreenUtil for responsive design
    ScreenUtil.init(context, designSize: const Size(420, 800));

    return Scaffold(
      body: Container(
        // Background gradient เหมือนต้นฉบับ
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
        child: isTablet 
          ? _buildTabletLayout(context, screenWidth, screenHeight, isLargeTablet)
          : _buildMobileLayout(context, screenWidth, screenHeight),
      ),
    );
  }

  // Mobile Layout - Container แบบเดิม
  Widget _buildMobileLayout(BuildContext context, double screenWidth, double screenHeight) {
    double containerWidth = screenWidth > 420 ? 420.w : screenWidth * 0.9;

    return Center(
      child: Container(
        width: containerWidth,
        constraints: const BoxConstraints(
          maxWidth: 420,
          minWidth: 300,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: navy.withOpacity(0.12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: const Color(0xFFe0e7ff)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(false),
            _buildLoginForm(false),
          ],
        ),
      ),
    );
  }

  // Tablet Layout - Full Screen Design
  Widget _buildTabletLayout(BuildContext context, double screenWidth, double screenHeight, bool isLargeTablet) {
    return Column(
      children: [
        // Header Section - 35% of screen height
        Expanded(
          flex: 35,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [navy, blue],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo CMO
                Image.asset(
                  'assets/images/logoml_white.png',
                  width: isLargeTablet ? 240.w : 220.w,
                  height: isLargeTablet ? 90.h : 80.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: isLargeTablet ? 30.h : 24.h),
                Text(
                  'CMO APP',
                  style: GoogleFonts.kanit(
                    fontSize: isLargeTablet ? 52.sp : 46.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: isLargeTablet ? 16.h : 12.h),
                Text(
                  'ระบบสินเชื่อ',
                  style: GoogleFonts.kanit(
                    fontSize: isLargeTablet ? 26.sp : 22.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Login Form Section - 65% of screen height
        Expanded(
          flex: 65,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Container(
                width: isLargeTablet ? 700.w : 650.w,
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.85,
                  minWidth: 500,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeTablet ? 70.w : 60.w,
                  vertical: isLargeTablet ? 70.h : 60.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isLargeTablet ? 36.r : 32.r),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.08),
                      blurRadius: isLargeTablet ? 45 : 40,
                      offset: Offset(0, isLargeTablet ? 18 : 15),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFe0e7ff), width: 2),
                ),
                child: _buildLoginForm(true, isLargeTablet),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Header Widget - สำหรับ Mobile
  Widget _buildHeader(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.w : 20.w,
        vertical: isTablet ? 40.h : 32.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, blue],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Logo CMO
          Image.asset(
            'assets/images/logoml_white.png',
            width: isTablet ? 180.w : 150.w,
            height: isTablet ? 60.h : 50.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: isTablet ? 20.h : 16.h),
          Text(
            'CMO APP',
            style: GoogleFonts.kanit(
              fontSize: isTablet ? 36.sp : 32.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Login Form Widget - สำหรับทั้ง Mobile และ Tablet
  Widget _buildLoginForm(bool isTablet, [bool isLargeTablet = false]) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username Field
          Text(
            'ชื่อผู้ใช้',
            style: GoogleFonts.kanit(
              fontSize: isLargeTablet ? 26.sp : (isTablet ? 22.sp : 18.sp),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: isLargeTablet ? 14.h : (isTablet ? 12.h : 8.h)),
          _buildInputField(
            controller: _usernameController,
            hint: 'กรอกชื่อผู้ใช้',
            icon: FontAwesomeIcons.user,
            isTablet: isTablet,
            isLargeTablet: isLargeTablet,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่อผู้ใช้';
              }
              return null;
            },
          ),
          SizedBox(height: isLargeTablet ? 36.h : (isTablet ? 32.h : 24.h)),

          // Password Field
          Text(
            'รหัสผ่าน',
            style: GoogleFonts.kanit(
              fontSize: isLargeTablet ? 26.sp : (isTablet ? 22.sp : 18.sp),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: isLargeTablet ? 14.h : (isTablet ? 12.h : 8.h)),
          _buildInputField(
            controller: _passwordController,
            hint: 'กรอกรหัสผ่าน',
            icon: FontAwesomeIcons.lock,
            obscureText: _obscurePassword,
            isTablet: isTablet,
            isLargeTablet: isLargeTablet,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                color: gray,
                size: isLargeTablet ? 28.sp : (isTablet ? 24.sp : 20.sp),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกรหัสผ่าน';
              }
              return null;
            },
          ),
          SizedBox(height: isLargeTablet ? 52.h : (isTablet ? 44.h : 32.h)),

          // Login Button
          _buildLoginButton(isTablet, isLargeTablet),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    bool isTablet = false,
    bool isLargeTablet = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isLargeTablet ? 16 : (isTablet ? 14 : 10),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: GoogleFonts.kanit(
          fontSize: isLargeTablet ? 24.sp : (isTablet ? 22.sp : 18.sp),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.kanit(
            color: gray,
            fontSize: isLargeTablet ? 24.sp : (isTablet ? 22.sp : 18.sp),
          ),
          prefixIcon: Icon(
            icon,
            color: gray,
            size: isLargeTablet ? 26.sp : (isTablet ? 24.sp : 20.sp),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFfafbff),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
            borderSide: const BorderSide(color: border, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
            borderSide: const BorderSide(color: border, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
            borderSide: const BorderSide(color: navy, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
            borderSide: const BorderSide(color: red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isLargeTablet ? 18.r : (isTablet ? 16.r : 12.r)),
            borderSide: const BorderSide(color: red, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isLargeTablet ? 28.w : (isTablet ? 24.w : 18.w),
            vertical: isLargeTablet ? 20.h : (isTablet ? 18.h : 14.h),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isTablet, [bool isLargeTablet = false]) {
    return Container(
      width: double.infinity,
      height: isLargeTablet ? 80.h : (isTablet ? 72.h : 56.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.25),
            blurRadius: isLargeTablet ? 24 : (isTablet ? 20 : 15),
            offset: Offset(0, isLargeTablet ? 12 : (isTablet ? 10 : 6)),
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
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [navy, blue],
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? SizedBox(
                    width: isLargeTablet ? 32.w : (isTablet ? 28.w : 20.w),
                    height: isLargeTablet ? 32.w : (isTablet ? 28.w : 20.w),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.3),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.rightToBracket,
                        color: Colors.white,
                        size: isLargeTablet ? 26.sp : (isTablet ? 24.sp : 20.sp),
                      ),
                      SizedBox(width: isLargeTablet ? 18.w : (isTablet ? 14.w : 10.w)),
                      Text(
                        'เข้าสู่ระบบ',
                        style: GoogleFonts.kanit(
                          fontSize: isLargeTablet ? 32.sp : (isTablet ? 30.sp : 26.sp),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
