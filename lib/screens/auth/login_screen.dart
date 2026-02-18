import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/glassmorphism.dart';
import '../../theme/thai_fonts.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../dashboard/dashboard_screen.dart';

/// 🔐 หน้า Login สุดหรูด้วย Glassmorphism Design
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false; // เพิ่มตัวแปรสถานะ loading
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );
    
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌊 พื้นหลัง Gradient สวยงาม
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.snowWhite,
              AppTheme.lightBlue.withOpacity(0.3), // ลดความเข้มสีฟ้า
              AppTheme.snowWhite,
              AppTheme.snowWhite, // เพิ่มสีขาวตอนท้ายให้กลมกลืน
            ],
            stops: const [0.0, 0.2, 0.5, 1.0], // ควบคุมการกระจายสีให้นุ่มๆ
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 24, // Tablet ใช้ padding มากกว่า
              vertical: 20,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity, // จำกัดความกว้างบน Tablet
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  
                  // 🏦 Logo และ Title
                  _buildHeader(),
                  
                  const SizedBox(height: 5), // ลดระยะห่างระหว่าง Title และ Form ให้ชิดกันมากที่สุด
                  
                  // 📝 Login Form
                  SlideTransition(
                    position: _slideAnimation, // ใช้ _slideAnimation โดยตรง
                    child: _buildLoginForm(),
                  ),
                  
                  const SizedBox(height: 60), // เพิ่มระยะห่างระหว่างฟอร์มและปุ่ม
                  
                  // 🔐 ปุ่ม Login
                  SlideTransition(
                    position: _slideAnimation, // ใช้ _slideAnimation โดยตรง
                    child: _buildLoginButton(),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header ส่วนหัวพร้อม Logo และ Title
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo โดยตรง ไม่มีกรอบ
        _buildLogo(),
        
        const SizedBox(height: 20),
        
        // Title
        AdaptiveText(
          'CMO APP',
          style: ThaiFonts.thaiHeadline1.copyWith(
            color: AppTheme.deepNavy,
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
        
        const SizedBox(height: 8),
        
        AdaptiveText(
          'ระบบสินเชื่อใหม่',
          style: ThaiFonts.thaiBody2.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  /// 🎨 Logo โดยตรง ไม่มีกรอบ ปรับขนาดอัตโนมัติ
  Widget _buildLogo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 📏 คำนวณขนาดที่เหมาะสมตามขนาดหน้าจอ
        double logoSize;
        if (constraints.maxWidth < 400) {
          logoSize = 120; // มือถือเล็ก
        } else if (constraints.maxWidth < 600) {
          logoSize = 140; // มือถือใหญ่
        } else if (constraints.maxWidth < 900) {
          logoSize = 180; // Tablet เล็ก
        } else {
          logoSize = 200; // Tablet ใหญ่
        }
        
        return Image.asset(
          'assets/images/logoml.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain, // รักษาสัดส่วนภาพ
          errorBuilder: (context, error, stackTrace) {
            // 🔄 ถ้าไม่พบรูป แสดง Placeholder
            return Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.deepNavy, AppTheme.sapphireBlue],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.account_balance,
                size: logoSize * 0.5,
                color: AppTheme.snowWhite,
              ),
            );
          },
        );
      },
    );
  }

  /// 📝 Login Form ด้วย Glassmorphism
  Widget _buildLoginForm() {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(32), // เพิ่ม padding ให้มีที่ว่างเพียงพอ
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 👤 รหัสพนักงาน
            GlassInputField(
              label: ThaiVocabulary.username,
              hint: 'กรอกรหัสพนักงาน',
              controller: _usernameController,
              keyboardType: TextInputType.number, // คีย์ได้เฉพาะตัวเลข
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกรหัสพนักงาน';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // 🔒 รหัสผ่าน
            GlassInputField(
              label: ThaiVocabulary.password,
              hint: 'กรอกรหัสผ่าน',
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกรหัสผ่าน';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // 👁️ แสดง/ซ่อนรหัสผ่าน + ลืมรหัสผ่าน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 👁️ แสดง/ซ่อนรหัสผ่าน
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 16,
                        color: AppTheme.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      AdaptiveText(
                        _obscurePassword ? 'แสดง' : 'ซ่อน',
                        style: ThaiFonts.thaiCaption.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 📝 ลืมรหัสผ่าน?
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: AdaptiveText(
                    ThaiVocabulary.forgotPassword,
                    style: ThaiFonts.thaiCaption.copyWith(
                      color: AppTheme.sapphireBlue,
                      fontWeight: FontWeight.w500,
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

  /// 🔐 ปุ่ม Login สุดหรู
  Widget _buildLoginButton() {
    print('🔨 Building login button, isLoading: $_isLoading'); // Debug
    
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 250), // จำกัดความกว้างสูงสุด 250px พอดีกับฟอร์ม
      child: GestureDetector(
        onTap: _isLoading ? null : () {
          print('🔘 GestureDetector onTap called'); // Debug
          _handleLogin();
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1565C0),
                const Color(0xFF0D47A1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        ThaiVocabulary.login,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// 🔐 จัดการการ Login
  void _handleLogin() async {
    print('🔐 Login button pressed'); // Debug
    
    // ตรวจสอบ form ก่อน validate
    if (_formKey.currentState == null) {
      print('❌ Form key is null');
      return;
    }
    
    print('📝 Form validation: ${_formKey.currentState?.validate()}');
    print('👤 Username: "${_usernameController.text.trim()}"');
    print('🔑 Password: "${_passwordController.text}"');
    
    if (_formKey.currentState?.validate() ?? false) {
      print('✅ Form validated successfully');
      
      setState(() {
        _isLoading = true; // เริ่ม loading
      });
      
      final username = _usernameController.text.trim();
      final password = _passwordController.text;
      
      print('⏳ Starting login process...');
      
      // 🔄 จำลองการรอ 2 วินาทีเพื่อแสดง loading
      await Future.delayed(const Duration(seconds: 2));
      
      print('🚀 Navigating to dashboard...');
      
      // 🔄 ชั่วคราวให้ไป Dashboard โดยตรง (ใช้ Navigator)
      if (mounted) {
        setState(() {
          _isLoading = false; // หยุด loading
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    } else {
      print('❌ Form validation failed');
    }
  }
}
