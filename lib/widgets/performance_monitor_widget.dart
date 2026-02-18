import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/performance_service.dart';

/// ⚡ Performance Monitor Widget
/// แสดงสถานะประสิทธิภาพแอปแบบ Real-time
class PerformanceMonitorWidget extends StatefulWidget {
  final bool showDetails;
  final bool showWarnings;
  final VoidCallback? onTap;

  const PerformanceMonitorWidget({
    super.key,
    this.showDetails = false,
    this.showWarnings = true,
    this.onTap,
  });

  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  PerformanceMetrics? _currentMetrics;
  List<PerformanceWarning> _warnings = [];
  double _performanceScore = 100.0;
  
  late StreamSubscription<PerformanceMetrics> _metricsSubscription;
  late StreamSubscription<PerformanceWarning> _warningSubscription;

  @override
  void initState() {
    super.initState();
    _initializeMonitoring();
  }

  @override
  void dispose() {
    _metricsSubscription.cancel();
    _warningSubscription.cancel();
    super.dispose();
  }

  void _initializeMonitoring() {
    // Listen to performance metrics
    _metricsSubscription = PerformanceService.metricsStream.listen((metrics) {
      if (mounted) {
        setState(() {
          _currentMetrics = metrics;
          _performanceScore = PerformanceService.getPerformanceScore();
        });
      }
    });

    // Listen to performance warnings
    _warningSubscription = PerformanceService.warningStream.listen((warning) {
      if (mounted && widget.showWarnings) {
        setState(() {
          _warnings.add(warning);
          // Keep only last 10 warnings
          if (_warnings.length > 10) {
            _warnings.removeAt(0);
          }
        });
        
        _showWarningSnackBar(warning);
      }
    });

    // Get initial metrics
    _performanceScore = PerformanceService.getPerformanceScore();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showDetails) {
      return _buildCompactMonitor();
    } else {
      return _buildDetailedMonitor();
    }
  }

  /// 📱 Compact Performance Monitor
  Widget _buildCompactMonitor() {
    return GestureDetector(
      onTap: widget.onTap ?? _showPerformanceDetails,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getPerformanceColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getPerformanceColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Performance Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _getPerformanceIcon(),
                key: ValueKey(_performanceScore),
                size: 16,
                color: _getPerformanceColor(),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Performance Score
            Text(
              '${_performanceScore.toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getPerformanceColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
            
            // Warning Indicator
            if (_warnings.isNotEmpty) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.warning,
                size: 16,
                color: AppTheme.warningAmber,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 📊 Detailed Performance Monitor
  Widget _buildDetailedMonitor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.snowWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getPerformanceColor().withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _getPerformanceIcon(),
                color: _getPerformanceColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'สถานะประสิทธิภาพ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getPerformanceColor(),
                ),
              ),
              const Spacer(),
              Text(
                '${_performanceScore.toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getPerformanceColor(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Performance Score Bar
          _buildPerformanceBar(),
          
          const SizedBox(height: 16),
          
          // Metrics Grid
          if (_currentMetrics != null) ...[
            _buildMetricsGrid(),
            const SizedBox(height: 16),
          ],
          
          // Warnings
          if (_warnings.isNotEmpty) ...[
            _buildWarningsSection(),
            const SizedBox(height: 16),
          ],
          
          // Recommendations
          _buildRecommendationsSection(),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar() {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _performanceScore / 100.0,
        child: Container(
          decoration: BoxDecoration(
            color: _getPerformanceColor(),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    if (_currentMetrics == null) {
      return const Center(
        child: Text('กำลังโหลดข้อมูล...'),
      );
    }

    final metrics = _currentMetrics!;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMetricItem('Memory', '${(metrics.memoryUsage * 100).toInt()}%', Icons.memory)),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricItem('Frame Rate', '${metrics.frameRate} FPS', Icons.speed)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricItem('Network', '${metrics.networkRequests}', Icons.wifi)),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricItem('Response', '${metrics.averageResponseTime.inMilliseconds}ms', Icons.timer)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppTheme.sapphireBlue,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.deepNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning,
              color: AppTheme.warningAmber,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'คำเตือนประสิทธิภาพ',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.warningAmber,
              ),
            ),
            const Spacer(),
            Text(
              '${_warnings.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.warningAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._warnings.take(3).map((warning) => _buildWarningItem(warning)),
      ],
    );
  }

  Widget _buildWarningItem(PerformanceWarning warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getWarningColor(warning.severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getWarningColor(warning.severity).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getWarningIcon(warning.type),
            size: 16,
            color: _getWarningColor(warning.severity),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              warning.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getWarningColor(warning.severity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final recommendations = PerformanceService.getPerformanceRecommendations();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: AppTheme.sapphireBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'คำแนะนำ',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.sapphireBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recommendations.take(3).map((recommendation) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.deepNavy,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _optimizePerformance,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.sapphireBlue),
              foregroundColor: AppTheme.sapphireBlue,
            ),
            child: const Text('ปรับปรุงประสิทธิภาพ'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: _showDetailedReport,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.deepNavy),
              foregroundColor: AppTheme.deepNavy,
            ),
            child: const Text('ดูรายงาน'),
          ),
        ),
      ],
    );
  }

  Color _getPerformanceColor() {
    if (_performanceScore >= 80) {
      return AppTheme.successGreen;
    } else if (_performanceScore >= 60) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.errorRed;
    }
  }

  IconData _getPerformanceIcon() {
    if (_performanceScore >= 80) {
      return Icons.speed;
    } else if (_performanceScore >= 60) {
      return Icons.speed;
    } else {
      return Icons.warning;
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

  void _showWarningSnackBar(PerformanceWarning warning) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getWarningIcon(warning.type),
              color: AppTheme.pureWhite,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(warning.message)),
          ],
        ),
        backgroundColor: _getWarningColor(warning.severity),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPerformanceDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('รายละเอียดประสิทธิภาพ'),
        content: SingleChildScrollView(
          child: _buildDetailedMonitor(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  void _optimizePerformance() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังปรับปรุงประสิทธิภาพ...'),
          ],
        ),
      ),
    );

    try {
      await PerformanceService.optimizePerformance();
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ปรับปรุงประสิทธิภาพสำเร็จแล้ว'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _showDetailedReport() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังสร้างรายงาน...'),
          ],
        ),
      ),
    );

    try {
      final report = await PerformanceService.getPerformanceReport();
      Navigator.of(context).pop(); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('รายงานประสิทธิภาพ'),
          content: SingleChildScrollView(
            child: _buildReportContent(report),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถสร้างรายงาน: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Widget _buildReportContent(PerformanceReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReportRow('เวลา', report.timestamp.toString()),
        _buildReportRow('App Version', report.appVersion),
        _buildReportRow('Build Number', report.buildNumber),
        if (report.deviceInfo != null) ...[
          _buildReportRow('Platform', report.deviceInfo!.platform),
          _buildReportRow('Model', report.deviceInfo!.model),
          _buildReportRow('Manufacturer', report.deviceInfo!.manufacturer),
        ],
        const SizedBox(height: 16),
        Text(
          'Performance Metrics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildReportRow('Performance Score', '${_performanceScore.toInt()}%'),
        _buildReportRow('Memory Usage', '${(report.currentMetrics.memoryUsage * 100).toInt()}%'),
        _buildReportRow('Frame Rate', '${report.currentMetrics.frameRate} FPS'),
        _buildReportRow('Network Requests', '${report.currentMetrics.networkRequests}'),
        _buildReportRow('Avg Response Time', '${report.currentMetrics.averageResponseTime.inMilliseconds}ms'),
      ],
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
