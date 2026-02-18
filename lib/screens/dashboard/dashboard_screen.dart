import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 📱 Config
import '../../config/tablet_config.dart';

// 🎨 Theme
import '../../theme/app_theme.dart';
import '../../theme/glassmorphism.dart';
import '../../theme/thai_fonts.dart';

// 🧠 BLoC
import '../../bloc/loan_bloc.dart';
import '../../bloc/auth_bloc.dart';

/// 📊 หน้า Dashboard หลักสุดหรูด้วย Glassmorphism Premium
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _animationController.forward();
    
    // 📊 โหลดข้อมูลคำขอสินเชื่อ
    context.read<LoanBloc>().add(LoadLoanApplications());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 📱 Mobile Layout
  Widget _buildMobileLayout() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📋 Header
                _buildHeader(),
                
                SizedBox(height: 24.h),
                
                // 📈 สถิติภาพรวม
                _buildStatsSection(),
                
                SizedBox(height: 24.h),
                
                // 📋 คำขอสินเชื่อล่าสุด
                _buildRecentApplications(),
                
                SizedBox(height: 24.h),
                
                // � จัดการด่วน
                _buildQuickActions(),
                
                SizedBox(height: 100.h), // Padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📱 Tablet Layout
  Widget _buildTabletLayout() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            padding: TabletConfig.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📋 Header
                _buildHeader(),
                
                SizedBox(height: 32.h),
                
                // 📈 สถิติภาพรวม
                _buildStatsSection(),
                
                SizedBox(height: 32.h),
                
                // 📋 คำขอสินเชื่อล่าสุด
                _buildRecentApplications(),
                
                SizedBox(height: 32.h),
                
                // 🚀 จัดการด่วน
                _buildQuickActions(),
                
                SizedBox(height: 120.h), // Padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🖥️ Desktop Layout
  Widget _buildDesktopLayout() {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            padding: TabletConfig.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📋 Header
                _buildHeader(),
                
                SizedBox(height: 40.h),
                
                // 📈 สถิติภาพรวม
                _buildStatsSection(),
                
                SizedBox(height: 40.h),
                
                // 📋 คำขอสินเชื่อล่าสุด
                _buildRecentApplications(),
                
                SizedBox(height: 40.h),
                
                // 🚀 จัดการด่วน
                _buildQuickActions(),
                
                SizedBox(height: 120.h), // Padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📋 Header ส่วนหัวแบบ Glassmorphism
  Widget _buildHeader() {
    return Container(
      width: TabletConfig.containerWidth,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
        border: Border.all(
          color: AppTheme.deepNavy.withOpacity(0.1),
          width: 0.5,
        ),
        boxShadow: TabletConfig.premiumShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
        child: GlassContainer(
          padding: EdgeInsets.all(20.w),
          borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
          blur: TabletConfig.glassBlur,
          opacity: 0.15,
          child: Row(
            children: [
              // 👤 Profile Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      'สวัสดี',
                      style: ThaiFonts.thaiBody2.copyWith(
                        color: AppTheme.mediumGray,
                        fontSize: TabletConfig.responsiveFont(mobile: 14, tablet: 16),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String username = 'ผู้ใช้งาน';
                        if (state is AuthAuthenticated) {
                          username = state.user.username;
                        }
                        
                        return AdaptiveText(
                          username,
                          style: ThaiFonts.thaiHeadline3.copyWith(
                            color: AppTheme.deepNavy,
                            fontSize: TabletConfig.responsiveFont(mobile: 20, tablet: 24),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // 🔔 Notifications
              GestureDetector(
                onTap: () {
                  // TODO: Show notifications
                },
                child: GlassContainer(
                  padding: EdgeInsets.all(12.w),
                  borderRadius: BorderRadius.circular(16.r),
                  blur: 10.0,
                  opacity: 0.2,
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.deepNavy,
                        size: TabletConfig.iconSize,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📈 สถิติภาพรวม (ตามต้นฉบับ - ไม่มี Stats Cards)
  Widget _buildStatsSection() {
    // ต้นฉบับไม่มี Stats Cards บน Dashboard
    // แต่มี Title Bar พร้อมปุ่ม Refresh และ Add
    return Container(
      width: TabletConfig.containerWidth,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
        border: Border.all(
          color: AppTheme.deepNavy.withOpacity(0.1),
          width: 0.5,
        ),
        boxShadow: TabletConfig.premiumShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
        child: GlassContainer(
          padding: EdgeInsets.all(20.w),
          borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
          blur: TabletConfig.glassBlur,
          opacity: 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🏠 Title
              Row(
                children: [
                  Icon(
                    Icons.home,
                    color: AppTheme.deepNavy,
                    size: TabletConfig.iconSize,
                  ),
                  SizedBox(width: 12.w),
                  AdaptiveText(
                    'รายการสินเชื่อ',
                    style: ThaiFonts.thaiHeadline3.copyWith(
                      color: AppTheme.deepNavy,
                      fontSize: TabletConfig.responsiveFont(mobile: 20, tablet: 24),
                    ),
                  ),
                ],
              ),
              
              // � Action Buttons
              Row(
                children: [
                  // � Refresh Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Refresh data
                      context.read<LoanBloc>().add(LoadLoanApplications());
                    },
                    child: GlassContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                      blur: 10.0,
                      opacity: 0.2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.sync_alt,
                            color: AppTheme.deepNavy,
                            size: TabletConfig.iconSize * 0.8,
                          ),
                          SizedBox(width: 8.w),
                          AdaptiveText(
                            'รีเฟรช',
                            style: ThaiFonts.thaiBody2.copyWith(
                              color: AppTheme.deepNavy,
                              fontSize: TabletConfig.responsiveFont(mobile: 14, tablet: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // ➕ Add Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to step1
                    },
                    child: GlassContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      borderRadius: BorderRadius.circular(50.r),
                      blur: 10.0,
                      opacity: 0.2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: AppTheme.successGreen,
                            size: TabletConfig.iconSize * 0.8,
                          ),
                          SizedBox(width: 8.w),
                          AdaptiveText(
                            'เพิ่ม',
                            style: ThaiFonts.thaiBody2.copyWith(
                              color: AppTheme.successGreen,
                              fontSize: TabletConfig.responsiveFont(mobile: 14, tablet: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 Modern Card สวยงามทันสมัย
  Widget _buildModernCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎨 Icon และ Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdaptiveText(
                  title,
                  style: ThaiFonts.thaiCaption.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 📊 Value
          AdaptiveText(
            value,
            style: ThaiFonts.thaiHeadline2.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 คำขอสินเชื่อ (ตามต้นฉบับ - Application Cards)
  Widget _buildRecentApplications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ไม่มี Header แยก เพราะ Title อยู่ใน Title Bar ด้านบนแล้ว
        
        SizedBox(height: 24.h),
        
        // 📋 Application Cards (ตามต้นฉบับ)
        BlocBuilder<LoanBloc, LoanState>(
          builder: (context, state) {
            if (state is LoanLoading) {
              return Container(
                width: TabletConfig.containerWidth,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
                  border: Border.all(
                    color: AppTheme.deepNavy.withOpacity(0.1),
                    width: 0.5,
                  ),
                  boxShadow: TabletConfig.premiumShadows,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                  child: GlassContainer(
                    padding: EdgeInsets.all(40.w),
                    borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                    blur: TabletConfig.glassBlur,
                    opacity: 0.15,
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.deepNavy,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16.h),
                          AdaptiveText(
                            'กำลังโหลดข้อมูล...',
                            style: ThaiFonts.thaiBody2.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            
            if (state is LoanError) {
              return Container(
                width: TabletConfig.containerWidth,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
                  border: Border.all(
                    color: AppTheme.errorRed.withOpacity(0.1),
                    width: 0.5,
                  ),
                  boxShadow: TabletConfig.premiumShadows,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                  child: GlassContainer(
                    padding: EdgeInsets.all(40.w),
                    borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                    blur: TabletConfig.glassBlur,
                    opacity: 0.15,
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppTheme.errorRed,
                            size: 48.r,
                          ),
                          SizedBox(height: 16.h),
                          AdaptiveText(
                            'เกิดข้อผิดพลาด',
                            style: ThaiFonts.thaiHeadline4.copyWith(
                              color: AppTheme.errorRed,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          AdaptiveText(
                            state.message,
                            style: ThaiFonts.thaiBody2.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            
            final applications = state is LoanLoaded ? state.applications : <LoanApplication>[];
            
            if (applications.isEmpty) {
              return Container(
                width: TabletConfig.containerWidth,
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
                  border: Border.all(
                    color: AppTheme.mediumGray.withOpacity(0.1),
                    width: 0.5,
                  ),
                  boxShadow: TabletConfig.premiumShadows,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                  child: GlassContainer(
                    padding: EdgeInsets.all(40.w),
                    borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
                    blur: TabletConfig.glassBlur,
                    opacity: 0.15,
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: AppTheme.mediumGray,
                            size: 48.r,
                          ),
                          SizedBox(height: 16.h),
                          AdaptiveText(
                            'ไม่พบรายการสินเชื่อ',
                            style: ThaiFonts.thaiHeadline4.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          AdaptiveText(
                            'กดปุ่ม "เพิ่ม" เพื่อสร้างรายการใหม่',
                            style: ThaiFonts.thaiBody2.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            
            // 📋 Application Cards (ตามต้นฉบับ)
            return Column(
              children: applications.map((app) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildApplicationCard(app),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// 📋 Application Card (ตามต้นฉบับ)
  Widget _buildApplicationCard(LoanApplication app) {
    // 🎨 Status Colors ตามต้นฉบับ
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    switch (app.status) {
      case 'D':
        statusColor = AppTheme.mediumGray;
        statusText = 'ฉบับร่าง';
        statusIcon = Icons.edit;
        break;
      case 'P':
        statusColor = AppTheme.warningAmber;
        statusText = 'รออนุมัติ';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'A':
        statusColor = AppTheme.successGreen;
        statusText = 'อนุมัติ';
        statusIcon = Icons.check_circle;
        break;
      case 'M':
        statusColor = AppTheme.warningAmber;
        statusText = 'อนุมัติ (มีเงื่อนไข)';
        statusIcon = Icons.warning;
        break;
      case 'R':
        statusColor = AppTheme.errorRed;
        statusText = 'ไม่อนุมัติ';
        statusIcon = Icons.cancel;
        break;
      case 'C':
        statusColor = AppTheme.errorRed;
        statusText = 'ยกเลิก';
        statusIcon = Icons.block;
        break;
      default:
        statusColor = AppTheme.mediumGray;
        statusText = 'ไม่ทราบสถานะ';
        statusIcon = Icons.help;
    }
    
    return Container(
      width: TabletConfig.containerWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius),
        border: Border.all(
          color: AppTheme.deepNavy.withOpacity(0.1),
          width: 0.5,
        ),
        boxShadow: TabletConfig.premiumShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
        child: GlassContainer(
          padding: EdgeInsets.all(20.w),
          borderRadius: BorderRadius.circular(TabletConfig.cardBorderRadius - 1),
          blur: TabletConfig.glassBlur,
          opacity: 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📋 Card Header (ตามต้นฉบับ)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📅 วันที่
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveText(
                        'วันที่เซ็นสัญญา:',
                        style: ThaiFonts.thaiCaption.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      AdaptiveText(
                        app.contractSignDate ?? '-',
                        style: ThaiFonts.thaiBody2.copyWith(
                          color: AppTheme.deepNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveText(
                        'วันที่ส่งงาน:',
                        style: ThaiFonts.thaiCaption.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      AdaptiveText(
                        app.submittedDate ?? '-',
                        style: ThaiFonts.thaiBody2.copyWith(
                          color: AppTheme.deepNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // 🆔 Ref Code
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppTheme.deepNavy.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: AdaptiveText(
                      app.refCode,
                      style: ThaiFonts.thaiCaption.copyWith(
                        color: AppTheme.deepNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // 👤 Customer Info (ตามต้นฉบับ)
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppTheme.deepNavy,
                    size: TabletConfig.iconSize,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AdaptiveText(
                      app.borrowerType == 'juristic' 
                          ? '${app.title} ${app.companyName ?? ''}'
                          : '${app.title ?? ''}${app.firstName ?? ''} ${app.lastName ?? ''}',
                      style: ThaiFonts.thaiBody2.copyWith(
                        color: AppTheme.deepNavy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // 🚗 Car Info (ตามต้นฉบับ)
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: AppTheme.deepNavy,
                    size: TabletConfig.iconSize,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdaptiveText(
                          '${app.carBrand ?? ''} ${app.carModel ?? ''} ${app.carYear ?? ''}',
                          style: ThaiFonts.thaiBody2.copyWith(
                            color: AppTheme.deepNavy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AdaptiveText(
                          '${app.licensePlate ?? ''} ${app.licenseProvince ?? ''}',
                          style: ThaiFonts.thaiCaption.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // 🔘 Action Buttons (ตามต้นฉบับ)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (app.status == 'D') ...[
                    // แก้ไข
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to edit
                      },
                      child: GlassContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        blur: 10.0,
                        opacity: 0.2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit,
                              color: AppTheme.deepNavy,
                              size: TabletConfig.iconSize * 0.8,
                            ),
                            SizedBox(width: 8.w),
                            AdaptiveText(
                              'แก้ไข',
                              style: ThaiFonts.thaiCaption.copyWith(
                                color: AppTheme.deepNavy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    // ส่งงาน
                    GestureDetector(
                      onTap: () {
                        // TODO: Submit application
                      },
                      child: GlassContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        blur: 10.0,
                        opacity: 0.2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.upload,
                              color: AppTheme.successGreen,
                              size: TabletConfig.iconSize * 0.8,
                            ),
                            SizedBox(width: 8.w),
                            AdaptiveText(
                              'ส่งงาน',
                              style: ThaiFonts.thaiCaption.copyWith(
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    // ลบรายการ
                    GestureDetector(
                      onTap: () {
                        // TODO: Delete application
                      },
                      child: GlassContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        blur: 10.0,
                        opacity: 0.2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete,
                              color: AppTheme.errorRed,
                              size: TabletConfig.iconSize * 0.8,
                            ),
                            SizedBox(width: 8.w),
                            AdaptiveText(
                              'ลบรายการ',
                              style: ThaiFonts.thaiCaption.copyWith(
                                color: AppTheme.errorRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Status Badge (สำหรับสถานะอื่นๆ)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                            size: TabletConfig.iconSize * 0.8,
                          ),
                          SizedBox(width: 8.w),
                          AdaptiveText(
                            statusText,
                            style: ThaiFonts.thaiCaption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🚀 จัดการด่วน (ตามต้นฉบับ - ไม่มี Quick Actions)
  Widget _buildQuickActions() {
    // ต้นฉบับไม่มี Quick Actions บน Dashboard
    // มีแค่ Application Cards และ Bottom Navigation
    return const SizedBox.shrink();
  }

  /// 🎨 Action Card สวยงาม
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // 🎨 Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // 📝 Title
            AdaptiveText(
              title,
              style: ThaiFonts.thaiCaption.copyWith(
                color: AppTheme.deepNavy,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 🧭 Bottom Navigation (ตามต้นฉบับ - ไม่มีใน Dashboard)
  Widget _buildBottomNavigationBar() {
    // ต้นฉบับไม่มี Bottom Navigation บน Desktop/Tablet
    // แต่มี Sidebar Menu แทน
    // สำหรับ Mobile เราจะใช้ Bottom Navigation
    return ResponsiveWidget(
      mobile: _buildMobileBottomNav(),
      tablet: const SizedBox.shrink(), // Tablet ไม่มี Bottom Nav
      desktop: const SizedBox.shrink(), // Desktop ไม่มี Bottom Nav
    );
  }

  /// 📱 Mobile Bottom Navigation
  Widget _buildMobileBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // TODO: Navigate based on index
        switch (index) {
          case 0: // Home
            // Already on dashboard
            break;
          case 1: // Applications
            // TODO: Navigate to applications list
            break;
          case 2: // New Application
            // TODO: Navigate to step1
            break;
          case 3: // Statistics
            // TODO: Navigate to statistics
            break;
          case 4: // Profile
            // TODO: Navigate to profile
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.deepNavy,
      unselectedItemColor: AppTheme.mediumGray,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          activeIcon: Icon(Icons.description),
          label: 'คำขอ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: 'สร้างใหม่',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'สถิติ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'โปรไฟล์',
        ),
      ],
    );
  }
}
