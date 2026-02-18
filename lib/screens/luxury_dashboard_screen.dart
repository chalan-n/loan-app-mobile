import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../bloc/auth_bloc.dart';
import '../bloc/loan_bloc.dart';
import 'loan_application/loan_application_screen.dart';

class LuxuryDashboardScreen extends StatefulWidget {
  const LuxuryDashboardScreen({super.key});

  @override
  State<LuxuryDashboardScreen> createState() => _LuxuryDashboardScreenState();
}

class _LuxuryDashboardScreenState extends State<LuxuryDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Ultra-Modern Digital Banking Colors
  static const Color deepNavy = Color(0xFF002D62);
  static const Color sapphireBlue = Color(0xFF0F52BA);
  static const Color snowWhite = Color(0xFFF8FAFC);
  static const Color glassWhite = Color(0x26FFFFFF);
  static const Color edgeGlow = Color(0x40FFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    
    // 📊 โหลดข้อมูลจาก API
    context.read<LoanBloc>().add(const LoadDashboardData());
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
    super.dispose();
  }

  @override
  // 📅 แปลงวันที่ ISO → รูปแบบ "1 ธ.ค. 2568" (พุทธศักราช)
  String _formatThaiDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == '-') return '-';
    try {
      final parts = dateStr.split(RegExp(r'[\-T ]'));
      if (parts.length < 3) return dateStr;
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      const thaiMonths = [
        'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
        'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
      ];
      final buddhistYear = year + 543;
      return '$day ${thaiMonths[month - 1]} $buddhistYear';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth >= 1024;

    ScreenUtil.init(context, designSize: const Size(428, 926));

    return Scaffold(
      backgroundColor: snowWhite,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: deepNavy,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        decoration: _buildMeshGradientBackground(),
        child: _buildDashboardLayout(isTablet, isLargeTablet),
      ),
    );
  }

  BoxDecoration _buildMeshGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [snowWhite, Color(0xFFEFF6FF), snowWhite],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildDashboardLayout(bool isTablet, bool isLargeTablet) {
    return Column(
      children: [
        _buildTopHeader(isTablet, isLargeTablet),
        _buildTitleBar(isTablet, isLargeTablet),
        Expanded(
          flex: 75,
          child: Padding(
            padding: EdgeInsets.only(top: isTablet ? 8.h : 6.h),
            child: _buildApplicationCards(isTablet, isLargeTablet),
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader(bool isTablet, bool isLargeTablet) {
    return Container(
      width: double.infinity,
      height: isTablet ? 80.h : 70.h,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e3a8a), Color(0xFF1e40af)],
        ),
        boxShadow: [
          BoxShadow(
            color: deepNavy.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.w : 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Row(
              children: [
                Image.asset(
                  'assets/images/logoml_white.png',
                  width: isTablet ? 90.w : 80.w,
                  height: isTablet ? 36.h : 32.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            // Right Side Icons
            Row(
              children: [
                // Notification Bell — plain icon ตามต้นฉบับ
                Stack(
                  children: [
                    Icon(FontAwesomeIcons.bell, color: Colors.white, size: isTablet ? 22.sp : 20.sp),
                    Positioned(
                      top: 0, right: 0,
                      child: Container(
                        width: 8.w, height: 8.w,
                        decoration: const BoxDecoration(color: danger, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: isTablet ? 20.w : 16.w),
                // Logout Button — plain icon ตามต้นฉบับ
                GestureDetector(
                  onTap: _showLogoutDialog,
                  child: Icon(FontAwesomeIcons.rightFromBracket, color: Colors.white, size: isTablet ? 22.sp : 20.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(bool isTablet, bool isLargeTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.w : 20.w,
        vertical: isTablet ? 18.h : 14.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e40af), Color(0xFF1e3a8a)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1e3a8a).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Row(
            children: [
              Icon(FontAwesomeIcons.house, color: Colors.white, size: isTablet ? 20.sp : 18.sp),
              SizedBox(width: isTablet ? 12.w : 8.w),
              Text(
                'รายการสินเชื่อ',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 18.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Action Buttons
          Row(
            children: [
              // Refresh Button — ปุ่มรีเฟรชตามต้นฉบับ (น้ำเงิน pill)
              GestureDetector(
                onTap: () {
                  context.read<LoanBloc>().add(const LoadDashboardData());
                },
                child: Container(
                  height: isTablet ? 40.h : 36.h,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3b82f6), Color(0xFF2563eb)],
                    ),
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF3b82f6).withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.rotate, color: Colors.white, size: isTablet ? 14.sp : 13.sp),
                      SizedBox(width: isTablet ? 10.w : 8.w),
                      Text('รีเฟรช', style: GoogleFonts.inter(fontSize: isTablet ? 14.sp : 13.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 12.w : 8.w),
              // Add Button — ปุ่มเพิ่มตามต้นฉบับ (เขียว pill)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoanApplicationScreen()),
                  );
                },
                child: Container(
                  height: isTablet ? 40.h : 36.h,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.w : 16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF10b981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF10b981).withOpacity(0.35), blurRadius: 15, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.plus, color: Colors.white, size: isTablet ? 14.sp : 13.sp),
                      SizedBox(width: isTablet ? 10.w : 8.w),
                      Text('เพิ่ม', style: GoogleFonts.inter(fontSize: isTablet ? 14.sp : 13.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // 📊 Application Cards — เชื่อม BLoC
  // ============================================
  Widget _buildApplicationCards(bool isTablet, bool isLargeTablet) {
    return BlocBuilder<LoanBloc, LoanState>(
      builder: (context, state) {
        // 🔄 Loading State
        if (state is LoanLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: CircularProgressIndicator(
                    color: sapphireBlue,
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'กำลังโหลดข้อมูล...',
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 16.sp : 14.sp,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // ❌ Error State
        if (state is LoanError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(FontAwesomeIcons.triangleExclamation, color: danger, size: 28.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 18.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 14.sp : 12.sp,
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  GestureDetector(
                    onTap: () {
                      context.read<LoanBloc>().add(const LoadDashboardData());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [sapphireBlue, deepNavy]),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.rotate, color: Colors.white, size: 14.sp),
                          SizedBox(width: 8.w),
                          Text('ลองใหม่', style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ Loaded State
        if (state is LoanLoaded) {
          final applications = state.applications;

          // 📭 Empty State
          if (applications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: sapphireBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(FontAwesomeIcons.folderOpen, color: sapphireBlue, size: 28.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'ไม่พบรายการสินเชื่อ',
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 18.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'กดปุ่ม "เพิ่ม" เพื่อสร้างรายการใหม่',
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 14.sp : 12.sp,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          // 📋 List of applications
          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24.w : 16.w,
              vertical: isTablet ? 8.h : 6.h,
            ),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              return _buildApplicationCard(applications[index], isTablet, isLargeTablet);
            },
          );
        }

        // Initial state — show loading
        return const Center(child: CircularProgressIndicator(color: sapphireBlue));
      },
    );
  }

  // ============================================
  // 📋 Application Card — ใช้ข้อมูลจาก LoanApplication
  // ============================================
  Widget _buildApplicationCard(LoanApplication app, bool isTablet, bool isLargeTablet) {
    final statusColors = {
      'D': textSecondary, 'Draft': textSecondary,
      'P': warning, 'Pending': warning,
      'A': success, 'Approved': success,
      'M': warning,
      'R': danger, 'Rejected': danger,
      'C': danger,
    };
    final statusTexts = {
      'D': 'ฉบับร่าง', 'Draft': 'ฉบับร่าง',
      'P': 'รออนุมัติ', 'Pending': 'รออนุมัติ',
      'A': 'อนุมัติ', 'Approved': 'อนุมัติ',
      'M': 'อนุมัติ (มีเงื่อนไข)',
      'R': 'ไม่อนุมัติ', 'Rejected': 'ไม่อนุมัติ',
      'C': 'ยกเลิก',
    };

    final status = app.status;
    final statusColor = statusColors[status] ?? textSecondary;
    final statusText = statusTexts[status] ?? status;

    // ข้อมูลจริงจาก app
    final contractDate = _formatThaiDate(app.contractSignDate);
    final submittedDate = _formatThaiDate(app.submittedDate);
    final loanNumber = app.refCode.isNotEmpty ? app.refCode : '-';
    
    // ชื่อลูกค้า
    final customerName = app.borrowerType == 'juristic'
        ? '${app.title ?? ''}${app.companyName ?? ''}'
        : '${app.title ?? ''}${app.firstName ?? ''} ${app.lastName ?? ''}';

    // ข้อมูลรถ
    final carInfo = [app.carBrand, app.carModel, app.carYear]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');
    final plateInfo = [app.licensePlate, app.licenseProvince]
        .where((s) => s != null && s.isNotEmpty)
        .join(' ');

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16.h : 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: deepNavy.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20.w : 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header — วันที่และเลขที่คำขอ
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12.w : 10.w,
                vertical: isTablet ? 8.h : 6.h,
              ),
              decoration: BoxDecoration(
                color: snowWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'วันที่เซ็นสัญญา : $contractDate',
                          style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w400, color: textSecondary),
                        ),
                      ),
                      SizedBox(width: isTablet ? 12.w : 8.w),
                      Expanded(
                        child: Text(
                          'วันที่ส่งงาน : $submittedDate',
                          style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w400, color: textSecondary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 6.h : 4.h),
                  Row(
                    children: [
                      Text(
                        'เลขที่คำขอ : ',
                        style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w400, color: textSecondary),
                      ),
                      Text(
                        loanNumber,
                        style: GoogleFonts.inter(fontSize: isTablet ? 14.sp : 12.sp, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet ? 16.h : 12.h),

            // Customer Info + Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Name
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.user, color: textSecondary, size: isTablet ? 16.sp : 14.sp),
                          SizedBox(width: isTablet ? 8.w : 6.w),
                          Expanded(
                            child: Text(
                              customerName.trim().isNotEmpty ? customerName.trim() : '-',
                              style: GoogleFonts.inter(fontSize: isTablet ? 16.sp : 14.sp, fontWeight: FontWeight.w500, color: textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8.h : 6.h),
                      // Car Info
                      if (carInfo.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.car, color: textSecondary, size: isTablet ? 16.sp : 14.sp),
                                SizedBox(width: isTablet ? 8.w : 6.w),
                                Expanded(
                                  child: Text(
                                    carInfo,
                                    style: GoogleFonts.inter(fontSize: isTablet ? 14.sp : 12.sp, fontWeight: FontWeight.w400, color: textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (plateInfo.isNotEmpty) ...[
                              SizedBox(height: isTablet ? 4.h : 2.h),
                              Row(
                                children: [
                                  SizedBox(width: isTablet ? 24.w : 20.w),
                                  Text(
                                    'ทะเบียน: $plateInfo',
                                    style: GoogleFonts.inter(fontSize: isTablet ? 14.sp : 12.sp, fontWeight: FontWeight.w400, color: textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                // Status Badge
                if (status != 'D' && status != 'Draft')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 12.w : 10.w, vertical: isTablet ? 6.h : 4.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w500, color: statusColor),
                    ),
                  ),
              ],
            ),

            SizedBox(height: isTablet ? 12.h : 8.h),

            // Action Buttons (D/Draft only)
            if (status == 'D' || status == 'Draft')
              Row(
                children: [
                  // Edit
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoanApplicationScreen(loanId: app.refCode),
                          ),
                        );
                      },
                      child: Container(
                        height: isTablet ? 36.h : 32.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFf97316),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [BoxShadow(color: const Color(0xFFf97316).withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.penToSquare, color: Colors.white, size: isTablet ? 12.sp : 10.sp),
                              SizedBox(width: isTablet ? 6.w : 4.w),
                              Text('แก้ไข', style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 8.w : 6.w),
                  // Submit
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement submit API
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ส่งงาน ${app.refCode}'),
                            backgroundColor: const Color(0xFF007bff),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        height: isTablet ? 36.h : 32.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007bff),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [BoxShadow(color: const Color(0xFF007bff).withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.paperPlane, color: Colors.white, size: isTablet ? 12.sp : 10.sp),
                              SizedBox(width: isTablet ? 6.w : 4.w),
                              Text('ส่งงาน', style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 8.w : 6.w),
                  // Delete
                  Expanded(
                    child: Container(
                      height: isTablet ? 36.h : 32.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFdc2626),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: const Color(0xFFdc2626).withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.trashCan, color: Colors.white, size: isTablet ? 12.sp : 10.sp),
                            SizedBox(width: isTablet ? 6.w : 4.w),
                            Text('ลบรายการ', style: GoogleFonts.inter(fontSize: isTablet ? 12.sp : 10.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                          ],
                        ),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'ออกจากระบบ',
          style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600, color: textPrimary),
        ),
        content: Text(
          'คุณต้องการออกจากระบบหรือไม่?',
          style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w400, color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('ยกเลิก', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500, color: textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // 🔐 Logout ผ่าน AuthBloc
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('ออกจากระบบ', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
