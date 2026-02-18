import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({super.key});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Modern Color Palette
  static const Color primary = Color(0xFF6366F1); // Modern Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0F000000);

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
      // Simulate API call
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
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth >= 1024;

    ScreenUtil.init(context, designSize: const Size(428, 926));

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: isTablet 
          ? _buildTabletLayout(isLargeTablet)
          : _buildMobileLayout(),
      ),
    );
  }

  // Mobile Layout - Card centered
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildLoginCard(),
        ),
      ),
    );
  }

  // Tablet Layout - Split screen
  Widget _buildTabletLayout(bool isLargeTablet) {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary,
                  primaryDark,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: isLargeTablet ? 120.w : 100.w,
                  height: isLargeTablet ? 120.w : 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.buildingColumns,
                    color: Colors.white,
                    size: isLargeTablet ? 60.sp : 50.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                
                // App Name
                Text(
                  'CMO Loan',
                  style: GoogleFonts.inter(
                    fontSize: isLargeTablet ? 48.sp : 40.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Tagline
                Text(
                  'สินเชื่อที่เชื่อถือได้\nสำหรับคุณ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isLargeTablet ? 20.sp : 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                
                const Spacer(),
                
                // Features
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    children: [
                      _buildFeatureItem(FontAwesomeIcons.shieldHalved, 'ปลอดภัยสูง'),
                      SizedBox(height: 16.h),
                      _buildFeatureItem(FontAwesomeIcons.bolt, 'อนุมัติไว'),
                      SizedBox(height: 16.h),
                      _buildFeatureItem(FontAwesomeIcons.mobileScreen, 'ใช้งานง่าย'),
                    ],
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
        
        // Right side - Login form
        Expanded(
          flex: 1,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildLoginCard(isTablet: true, isLargeTablet: isLargeTablet),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard({bool isTablet = false, bool isLargeTablet = false}) {
    return Container(
      width: isTablet ? (isLargeTablet ? 500.w : 450.w) : double.infinity,
      margin: isTablet ? EdgeInsets.symmetric(horizontal: 32.w) : null,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40.w : 32.w,
        vertical: isTablet ? 48.h : 40.h,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isTablet) ...[
            // Mobile Logo
            Center(
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  FontAwesomeIcons.buildingColumns,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
          
          // Welcome Text
          Text(
            'ยินดีต้อนรับกลับ',
            style: GoogleFonts.inter(
              fontSize: isLargeTablet ? 32.sp : (isTablet ? 28.sp : 24.sp),
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'เข้าสู่ระบบเพื่อเข้าใช้งาน',
            style: GoogleFonts.inter(
              fontSize: isLargeTablet ? 18.sp : (isTablet ? 16.sp : 14.sp),
              fontWeight: FontWeight.w400,
              color: textSecondary,
            ),
          ),
          SizedBox(height: isLargeTablet ? 40.h : (isTablet ? 32.h : 24.h)),
          
          // Login Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Username Field
                _buildModernInputField(
                  controller: _usernameController,
                  label: 'ชื่อผู้ใช้',
                  hint: 'กรอกชื่อผู้ใช้งาน',
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
                SizedBox(height: isLargeTablet ? 24.h : (isTablet ? 20.h : 16.h)),
                
                // Password Field
                _buildModernInputField(
                  controller: _passwordController,
                  label: 'รหัสผ่าน',
                  hint: 'กรอกรหัสผ่าน',
                  icon: FontAwesomeIcons.lock,
                  obscureText: _obscurePassword,
                  isTablet: isTablet,
                  isLargeTablet: isLargeTablet,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isLargeTablet ? 16.h : (isTablet ? 12.h : 8.h)),
                
                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember Me
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value!);
                            },
                            activeColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'จำฉันไว้',
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 14.sp : 12.sp,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    // Forgot Password
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: Text(
                        'ลืมรหัสผ่าน?',
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 14.sp : 12.sp,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isLargeTablet ? 32.h : (isTablet ? 28.h : 24.h)),
                
                // Login Button
                _buildModernLoginButton(isTablet, isLargeTablet),
                
                SizedBox(height: isLargeTablet ? 24.h : (isTablet ? 20.h : 16.h)),
                
                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: border)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'หรือ',
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 14.sp : 12.sp,
                          color: textSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: border)),
                  ],
                ),
                SizedBox(height: isLargeTablet ? 24.h : (isTablet ? 20.h : 16.h)),
                
                // Quick Login Options
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        'เข้าสู่ระบบด่วน',
                        FontAwesomeIcons.fingerprint,
                        secondary,
                        isTablet,
                        isLargeTablet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool isTablet = false,
    bool isLargeTablet = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isLargeTablet ? 16.sp : (isTablet ? 14.sp : 12.sp),
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: isLargeTablet ? 16.sp : (isTablet ? 14.sp : 14.sp),
            color: textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: textSecondary,
              fontSize: isLargeTablet ? 16.sp : (isTablet ? 14.sp : 14.sp),
            ),
            prefixIcon: Icon(
              icon,
              color: textSecondary,
              size: isLargeTablet ? 20.sp : (isTablet ? 18.sp : 16.sp),
            ),
            suffixIcon: obscureText
                ? IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: textSecondary,
                      size: isLargeTablet ? 18.sp : (isTablet ? 16.sp : 14.sp),
                    ),
                  )
                : null,
            filled: true,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: error, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isLargeTablet ? 16.w : (isTablet ? 14.w : 12.w),
              vertical: isLargeTablet ? 16.h : (isTablet ? 14.h : 12.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernLoginButton(bool isTablet, bool isLargeTablet) {
    return Container(
      width: double.infinity,
      height: isLargeTablet ? 56.h : (isTablet ? 52.h : 48.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDark],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: isLargeTablet ? 20.w : (isTablet ? 18.w : 16.w),
                    height: isLargeTablet ? 20.w : (isTablet ? 18.w : 16.w),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'กำลังเข้าสู่ระบบ...',
                    style: GoogleFonts.inter(
                      fontSize: isLargeTablet ? 16.sp : (isTablet ? 14.sp : 14.sp),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
                    size: isLargeTablet ? 18.sp : (isTablet ? 16.sp : 14.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'เข้าสู่ระบบ',
                    style: GoogleFonts.inter(
                      fontSize: isLargeTablet ? 16.sp : (isTablet ? 14.sp : 14.sp),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    Color color,
    bool isTablet,
    bool isLargeTablet,
  ) {
    return Container(
      height: isLargeTablet ? 48.h : (isTablet ? 44.h : 40.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement biometric login
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: isLargeTablet ? 18.sp : (isTablet ? 16.sp : 14.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: isLargeTablet ? 14.sp : (isTablet ? 12.sp : 12.sp),
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
