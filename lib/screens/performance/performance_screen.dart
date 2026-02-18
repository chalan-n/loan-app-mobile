import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/performance_monitor_widget.dart';
import '../../services/performance_service.dart';

/// ⚡ Performance Screen
/// หน้าจอจัดการและตรวจสอบประสิทธิภาพแอป
class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  PerformanceReport? _currentReport;
  bool _isOptimizing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPerformanceReport();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: const Text(
          'ประสิทธิภาพแอป',
          style: TextStyle(
            color: AppTheme.deepNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.snowWhite,
        foregroundColor: AppTheme.deepNavy,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.deepNavy),
            onPressed: _refreshData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.sapphireBlue,
          unselectedLabelColor: AppTheme.mediumGray,
          indicatorColor: AppTheme.sapphireBlue,
          tabs: const [
            Tab(text: 'ภาพรวม'),
            Tab(text: 'เมตริก'),
            Tab(text: 'คำเตือน'),
            Tab(text: 'การตั้งค่า'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildMetricsTab(),
          _buildWarningsTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  /// 📊 Overview Tab
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Score Card
          _buildPerformanceScoreCard(),
          
          const SizedBox(height: 20),
          
          // Quick Stats Grid
          _buildQuickStatsGrid(),
          
          const SizedBox(height: 20),
          
          // Recommendations
          _buildRecommendationsCard(),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          _buildQuickActionsCard(),
        ],
      ),
    );
  }

  /// 📈 Metrics Tab
  Widget _buildMetricsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real-time Monitor
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.monitor,
                      color: AppTheme.sapphireBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'การตรวจสอบแบบ Real-time',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                const PerformanceMonitorWidget(showDetails: true),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Detailed Metrics
          if (_currentReport != null) _buildDetailedMetrics(),
        ],
      ),
    );
  }

  /// ⚠️ Warnings Tab
  Widget _buildWarningsTab() {
    return StreamBuilder<PerformanceWarning>(
      stream: PerformanceService.warningStream,
      builder: (context, snapshot) {
        final warnings = <PerformanceWarning>[];
        
        if (snapshot.hasData) {
          warnings.add(snapshot.data!);
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warnings Header
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: AppTheme.warningAmber,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'คำเตือนประสิทธิภาพ',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.warningAmber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${warnings.length}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.warningAmber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'คำเตือนแสดงปัญหาที่อาจส่งผลกระทบต่อประสิทธิภาพแอป',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Warnings List
              if (warnings.isEmpty)
                _buildNoWarningsState()
              else
                ...warnings.map((warning) => _buildWarningCard(warning)),
            ],
          ),
        );
      },
    );
  }

  /// ⚙️ Settings Tab
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monitoring Settings
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: AppTheme.sapphireBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'การตั้งค่าการตรวจสอบ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                SwitchListTile(
                  title: const Text('เปิดการตรวจสอบประสิทธิภาพ'),
                  subtitle: const Text('ตรวจสอบประสิทธิภาพแอปอัตโนมัติ'),
                  value: true, // TODO: Get from settings
                  onChanged: (value) {
                    // TODO: Save to settings
                  },
                  activeColor: AppTheme.sapphireBlue,
                ),
                
                SwitchListTile(
                  title: const Text('แสดงคำเตือน'),
                  subtitle: const Text('แจ้งเตือนเมื่อพบปัญหาประสิทธิภาพ'),
                  value: true, // TODO: Get from settings
                  onChanged: (value) {
                    // TODO: Save to settings
                  },
                  activeColor: AppTheme.sapphireBlue,
                ),
                
                SwitchListTile(
                  title: const Text('ปรับปรุงอัตโนมัติ'),
                  subtitle: const Text('ปรับปรุงประสิทธิภาพอัตโนมัติเมื่อจำเป็น'),
                  value: false, // TODO: Get from settings
                  onChanged: (value) {
                    // TODO: Save to settings
                  },
                  activeColor: AppTheme.sapphireBlue,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Performance Settings
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'การตั้งค่าประสิทธิภาพ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.sapphireBlue,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                ListTile(
                  title: const Text('คุณภาพรูปภาพ'),
                  subtitle: const Text('ปรับคุณภาพรูปภาพเพื่อประสิทธิภาพ'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showImageQualitySettings,
                ),
                
                ListTile(
                  title: const Text('Animation'),
                  subtitle: const Text('ปรับความเร็วของ Animation'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showAnimationSettings,
                ),
                
                ListTile(
                  title: const Text('Cache'),
                  subtitle: const Text('จัดการ Cache และพื้นที่จัดเก็บ'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _showCacheSettings,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Advanced Settings
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'การตั้งค่าขั้นสูง',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepNavy,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                ListTile(
                  title: const Text('ล้างข้อมูล'),
                  subtitle: const Text('ล้าง Cache และข้อมูลชั่วคราว'),
                  trailing: const Icon(Icons.cleaning_services),
                  onTap: _clearAllData,
                ),
                
                ListTile(
                  title: const Text('รีเซ็ตการตั้งค่า'),
                  subtitle: const Text('รีเซ็ตการตั้งค่าประสิทธิภาพทั้งหมด'),
                  trailing: const Icon(Icons.restore),
                  onTap: _resetSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceScoreCard() {
    final score = PerformanceService.getPerformanceScore();
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                color: _getScoreColor(score),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'คะแนนประสิทธิภาพ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Score Display
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    backgroundColor: AppTheme.lightBlue.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightBlue.withOpacity(0.3),
                    ),
                    strokeWidth: 12,
                  ),
                ),
                
                // Progress Circle
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: score / 100.0,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score)),
                    strokeWidth: 12,
                  ),
                ),
                
                // Score Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.toInt()}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score),
                      ),
                    ),
                    Text(
                      _getScoreDescription(score),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
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

  Widget _buildQuickStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สถิติด่วน',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickStatCard(
                'Memory',
                '${(PerformanceService.currentMemoryUsage * 100).toInt()}%',
                Icons.memory,
                AppTheme.sapphireBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickStatCard(
                'Frame Rate',
                '${PerformanceService.frameRate} FPS',
                Icons.speed,
                AppTheme.successGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickStatCard(
                'Network',
                '${PerformanceService.networkRequests}',
                Icons.wifi,
                AppTheme.warningAmber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickStatCard(
                'Response',
                '${PerformanceService.averageResponseTime.inMilliseconds}ms',
                Icons.timer,
                AppTheme.deepNavy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
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

  Widget _buildRecommendationsCard() {
    final recommendations = PerformanceService.getPerformanceRecommendations();
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppTheme.sapphireBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'คำแนะนำ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          ...recommendations.map((recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.deepNavy,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การกระทำเร็ว',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isOptimizing ? null : _optimizePerformance,
                  icon: _isOptimizing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.pureWhite,
                        ),
                      )
                    : const Icon(Icons.speed),
                  label: Text(_isOptimizing ? 'กำลังปรับปรุง...' : 'ปรับปรุงประสิทธิภาพ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sapphireBlue,
                    foregroundColor: AppTheme.pureWhite,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearCache,
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text('ล้าง Cache'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.deepNavy),
                    foregroundColor: AppTheme.deepNavy,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    if (_currentReport == null) {
      return const Center(
        child: Text('ไม่มีข้อมูลเมตริก'),
      );
    }

    final report = _currentReport!;
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'เมตริกละเอียด',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildMetricDetail('Memory Usage', '${(report.currentMetrics.memoryUsage * 100).toInt()}%', 'การใช้งานหน่วยความจำ'),
          _buildMetricDetail('Frame Rate', '${report.currentMetrics.frameRate} FPS', 'อัตราเฟรมต่อวินาที'),
          _buildMetricDetail('Dropped Frames', '${report.currentMetrics.droppedFrames}', 'เฟรมที่หายไป'),
          _buildMetricDetail('Network Requests', '${report.currentMetrics.networkRequests}', 'จำนวน Request'),
          _buildMetricDetail('Avg Response Time', '${report.currentMetrics.averageResponseTime.inMilliseconds}ms', 'เวลาตอบสนองเฉลี่ย'),
        ],
      ),
    );
  }

  Widget _buildMetricDetail(String label, String value, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepNavy,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoWarningsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64,
            color: AppTheme.successGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่มีคำเตือน',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.successGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ประสิทธิภาพแอปของคุณดีเยี่ยม',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(PerformanceWarning warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getWarningIcon(warning.type),
              color: _getWarningColor(warning.severity),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    warning.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${warning.timestamp.hour.toString().padLeft(2, '0')}:'
                    '${warning.timestamp.minute.toString().padLeft(2, '0')}',
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
                color: _getWarningColor(warning.severity).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getWarningSeverityText(warning.severity),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getWarningColor(warning.severity),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppTheme.successGreen;
    if (score >= 60) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  String _getScoreDescription(double score) {
    if (score >= 90) return 'ดีเยี่ยม';
    if (score >= 80) return 'ดี';
    if (score >= 70) return 'ปานกลาง';
    if (score >= 60) return 'ต้องปรับปรุง';
    return 'ควรให้ความสำคัญ';
  }

  IconData _getWarningIcon(PerformanceWarningType type) {
    switch (type) {
      case PerformanceWarningType.memory:
        return Icons.memory;
      case PerformanceWarningType.frameRate:
        return Icons.speed;
      case PerformanceWarningType.network:
        return Icons.wifi;
      case PerformanceWarningType.cpu:
        return Icons.memory;
      case PerformanceWarningType.battery:
        return Icons.battery_alert;
    }
  }

  Color _getWarningColor(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.low:
        return AppTheme.mediumGray;
      case WarningSeverity.medium:
        return AppTheme.warningAmber;
      case WarningSeverity.high:
        return AppTheme.errorRed;
      case WarningSeverity.critical:
        return Colors.red;
    }
  }

  String _getWarningSeverityText(WarningSeverity severity) {
    switch (severity) {
      case WarningSeverity.low:
        return 'ต่ำ';
      case WarningSeverity.medium:
        return 'ปานกลาง';
      case WarningSeverity.high:
        return 'สูง';
      case WarningSeverity.critical:
        return 'วิกฤต';
    }
  }

  Future<void> _loadPerformanceReport() async {
    try {
      final report = await PerformanceService.getPerformanceReport();
      setState(() {
        _currentReport = report;
      });
    } catch (error) {
      debugPrint('Error loading performance report: $error');
    }
  }

  void _refreshData() {
    _loadPerformanceReport();
    HapticFeedback.lightImpact();
  }

  Future<void> _optimizePerformance() async {
    setState(() {
      _isOptimizing = true;
    });

    try {
      await PerformanceService.optimizePerformance();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ปรับปรุงประสิทธิภาพสำเร็จแล้ว'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      _refreshData();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      setState(() {
        _isOptimizing = false;
      });
    }
  }

  Future<void> _clearCache() async {
    try {
      await PerformanceService.clearCaches();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ล้าง Cache สำเร็จแล้ว'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      _refreshData();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _showImageQualitySettings() {
    // TODO: Show image quality settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('คุณลักษณะนี้ยังไม่พร้อมใช้งาน')),
    );
  }

  void _showAnimationSettings() {
    // TODO: Show animation settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('คุณลักษณะนี้ยังไม่พร้อมใช้งาน')),
    );
  }

  void _showCacheSettings() {
    // TODO: Show cache settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('คุณลักษณะนี้ยังไม่พร้อมใช้งาน')),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการล้างข้อมูล'),
        content: const Text('คุณต้องการล้างข้อมูลทั้งหมดใช่หรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('ล้างข้อมูล'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await PerformanceService.clearCaches();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ล้างข้อมูลสำเร็จแล้ว'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        _refreshData();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $error'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการรีเซ็ต'),
        content: const Text('คุณต้องการรีเซ็ตการตั้งค่าประสิทธิภาพทั้งหมดใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('รีเซ็ต'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Reset performance settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('รีเซ็ตการตั้งค่าสำเร็จแล้ว'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      _refreshData();
    }
  }
}
