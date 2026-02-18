import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/loan_bloc.dart';

/// 📊 Dashboard Screen สำหรับ Ultra-Luxury Loan App
/// แสดงภาพรวมข้อมูลสินเชื่อและฟังก์ชันหลัก
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
    
    // Load dashboard data
    context.read<LoanBloc>().add(LoadDashboardData());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: _buildAppBar(user),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👋 Welcome Section
                  _buildWelcomeSection(user),
                  
                  const SizedBox(height: 32),
                  
                  // 📊 Statistics Cards
                  _buildStatisticsCards(state),
                  
                  const SizedBox(height: 32),
                  
                  // 🚀 Quick Actions
                  _buildQuickActions(),
                  
                  const SizedBox(height: 32),
                  
                  // 📋 Recent Applications
                  _buildRecentApplications(state),
                  
                  const SizedBox(height: 32),
                  
                  // 📈 Performance Chart
                  _buildPerformanceChart(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(dynamic user) {
    return AppBar(
      title: Column(
        children: [
          Text(
            'แดชบอร์ด',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (user?.username != null)
            Text(
              'ผู้ใช้: ${user!.username}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Show notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.deepNavy,
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: AppTheme.deepNavy,
          ),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                // TODO: Navigate to profile
                break;
              case 'settings':
                // TODO: Navigate to settings
                break;
              case 'logout':
                context.read<AuthBloc>().add(LogoutRequested());
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 8),
                  Text('โปรไฟล์'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('ตั้งค่า'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('ออกจากระบบ'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(dynamic user) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.deepNavy,
                      AppTheme.sapphireBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  size: 30,
                  color: AppTheme.pureWhite,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ยินดีต้อนรับกลับมา',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.mediumGray,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      user?.username ?? 'ผู้ใช้งาน',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'วันนี้มี ${DateTime.now().day} ${_getThaiMonth(DateTime.now().month)} ${DateTime.now().year + 543}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(LoanState state) {
    return Column(
      children: [
        // Statistics Grid
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'คำขอทั้งหมด',
                '${state is LoanLoaded ? (state.totalApplications ?? 0) : 0}',
                Icons.description_outlined,
                AppTheme.sapphireBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'อนุมัติ',
                '${state is LoanLoaded ? (state.approvedApplications ?? 0) : 0}',
                Icons.check_circle_outline,
                AppTheme.successGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'รอดำเนินการ',
                '${state is LoanLoaded ? (state.pendingApplications ?? 0) : 0}',
                Icons.hourglass_empty,
                AppTheme.warningAmber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'ปฏิเสธ',
                '${state is LoanLoaded ? (state.rejectedApplications ?? 0) : 0}',
                Icons.cancel_outlined,
                AppTheme.errorRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return FloatingGlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.trending_up,
                size: 16,
                color: AppTheme.mediumGray,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'การดำเนินการด่วน',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'สร้างคำขอใหม่',
                Icons.add_circle_outline,
                AppTheme.sapphireBlue,
                () {
                  context.go('/loan-application');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'ค้นหาคำขอ',
                Icons.search,
                AppTheme.deepNavy,
                () {
                  // TODO: Navigate to search
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'จัดการเอกสาร',
                Icons.folder_open,
                AppTheme.successGreen,
                () {
                  context.go('/documents');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'ประสิทธิภาพ',
                Icons.speed,
                AppTheme.warningAmber,
                () {
                  context.go('/performance');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 25,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.deepNavy,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentApplications(LoanState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'คำขอล่าสุด',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all applications
              },
              child: Text(
                'ดูทั้งหมด',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.sapphireBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state is! LoanLoaded || (state.recentApplications?.isEmpty ?? true))
          GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: AppTheme.mediumGray,
                ),
                const SizedBox(height: 16),
                Text(
                  'ยังไม่มีคำขอล่าสุด',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: (state is LoanLoaded ? (state.recentApplications ?? []) : []).take(3).map((application) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildApplicationItem(application),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildApplicationItem(dynamic application) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description,
              size: 20,
              color: AppTheme.sapphireBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application?.refCode ?? 'N/A',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  application?.firstName ?? '' + ' ' + (application?.lastName ?? ''),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(application?.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getStatusText(application?.status),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStatusColor(application?.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สรุปประจำเดือน',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Simple Chart Placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insert_chart_outlined,
                        size: 48,
                        color: AppTheme.sapphireBlue,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'กราฟสรุปผลงาน',
                        style: TextStyle(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getThaiMonth(int month) {
    const months = [
      '', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];
    return months[month];
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return AppTheme.successGreen;
      case 'Pending':
        return AppTheme.warningAmber;
      case 'Rejected':
        return AppTheme.errorRed;
      default:
        return AppTheme.mediumGray;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'Approved':
        return 'อนุมัติ';
      case 'Pending':
        return 'รอดำเนินการ';
      case 'Rejected':
        return 'ปฏิเสธ';
      case 'Draft':
        return 'ฉบับร่าง';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }
}
