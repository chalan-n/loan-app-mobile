import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/connection_service.dart';

/// 📡 Connection Status Widget
/// แสดงสถานะการเชื่อมต่อกับเซิร์ฟเวอร์แบบ Real-time
class ConnectionStatusWidget extends StatefulWidget {
  final bool showDetails;
  final VoidCallback? onTap;
  
  const ConnectionStatusWidget({
    super.key,
    this.showDetails = false,
    this.onTap,
  });

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isConnected = false;
  String _statusText = 'กำลังตรวจสอบ...';
  String _lastError = '';
  int _retryCount = 0;
  DateTime? _lastConnected;
  
  late StreamSubscription<bool> _connectionSubscription;
  late StreamSubscription<String> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectionMonitoring();
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _errorSubscription.cancel();
    super.dispose();
  }

  void _initializeConnectionMonitoring() {
    // Listen to connection status changes
    _connectionSubscription = ConnectionService.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _lastConnected = ConnectionService.lastConnected;
          _retryCount = ConnectionService.retryCount;
          _updateStatusText();
        });
      }
    });

    // Listen to error messages
    _errorSubscription = ConnectionService.errorStream.listen((error) {
      if (mounted) {
        setState(() {
          _lastError = error;
          _updateStatusText();
        });
      }
    });

    // Get initial status
    _isConnected = ConnectionService.isConnected;
    _lastError = ConnectionService.lastError ?? '';
    _retryCount = ConnectionService.retryCount;
    _lastConnected = ConnectionService.lastConnected;
    _updateStatusText();
  }

  void _updateStatusText() {
    if (_isConnected) {
      final uptime = _lastConnected != null 
        ? DateTime.now().difference(_lastConnected!).inMinutes
        : 0;
      
      if (uptime < 1) {
        _statusText = 'เชื่อมต่อแล้ว';
      } else if (uptime < 60) {
        _statusText = 'เชื่อมต่อแล้ว (${uptime} นาที)';
      } else {
        final hours = uptime ~/ 60;
        final minutes = uptime % 60;
        _statusText = 'เชื่อมต่อแล้ว (${hours}ชม ${minutes}นาที)';
      }
    } else {
      if (_retryCount > 0) {
        _statusText = 'กำลังลองใหม่ ($_retryCount/3)';
      } else if (_lastError.isNotEmpty) {
        _statusText = 'ไม่สามารถเชื่อมต่อ';
      } else {
        _statusText = 'กำลังตรวจสอบ...';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showDetails) {
      return _buildCompactStatus();
    } else {
      return _buildDetailedStatus();
    }
  }

  /// 📱 Compact Status Indicator
  Widget _buildCompactStatus() {
    return GestureDetector(
      onTap: widget.onTap ?? _showConnectionDetails,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Icon
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _getStatusIcon(),
                key: ValueKey(_isConnected),
                size: 16,
                color: _getStatusColor(),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Status Text
            Flexible(
              child: Text(
                _statusText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Retry Indicator
            if (!_isConnected && _retryCount > 0) ...[
              const SizedBox(width: 4),
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 📊 Detailed Status Panel
  Widget _buildDetailedStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.snowWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
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
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'สถานะการเชื่อมต่อ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(),
                ),
              ),
              const Spacer(),
              if (!_isConnected)
                TextButton(
                  onPressed: _retryConnection,
                  style: TextButton.styleFrom(
                    foregroundColor: _getStatusColor(),
                  ),
                  child: const Text('ลองใหม่'),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Status Information
          _buildStatusRow('สถานะ', _statusText),
          
          if (_lastConnected != null) ...[
            _buildStatusRow(
              'เชื่อมต่อครั้งล่าสุด',
              _formatDateTime(_lastConnected!),
            ),
          ],
          
          if (_lastError.isNotEmpty) ...[
            _buildStatusRow('ข้อผิดพลาด', _lastError),
          ],
          
          if (_retryCount > 0) ...[
            _buildStatusRow('จำนวนครั้งที่ลอง', '$_retryCount/3'),
          ],
          
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _performComprehensiveTest,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.sapphireBlue),
                    foregroundColor: AppTheme.sapphireBlue,
                  ),
                  child: const Text('ทดสอบการเชื่อมต่อ'),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: OutlinedButton(
                  onPressed: _showConnectionStats,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.deepNavy),
                    foregroundColor: AppTheme.deepNavy,
                  ),
                  child: const Text('ดูสถิติ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
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

  Color _getStatusColor() {
    if (_isConnected) {
      return AppTheme.successGreen;
    } else if (_retryCount > 0) {
      return AppTheme.warningAmber;
    } else {
      return AppTheme.errorRed;
    }
  }

  IconData _getStatusIcon() {
    if (_isConnected) {
      return Icons.wifi;
    } else if (_retryCount > 0) {
      return Icons.sync_problem;
    } else {
      return Icons.wifi_off;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year + 543} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showConnectionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('รายละเอียดการเชื่อมต่อ'),
        content: SingleChildScrollView(
          child: _buildDetailedStatus(),
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

  void _retryConnection() async {
    setState(() {
      _statusText = 'กำลังลองใหม่...';
    });
    
    final success = await ConnectionService.retryConnection();
    
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _performComprehensiveTest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังทดสอบการเชื่อมต่อ...'),
          ],
        ),
      ),
    );

    try {
      final results = await ConnectionService.performComprehensiveTest();
      
      Navigator.of(context).pop(); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผลการทดสอบ'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTestResult('เชื่อมต่ออินเทอร์เน็ต', results['internet_connection']),
                _buildTestResult('เชื่อมต่อเซิร์ฟเวอร์', results['server_connection']),
                const SizedBox(height: 16),
                const Text('Endpoint Tests:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (results['endpoint_tests'] != null) ...[
                  ...(results['endpoint_tests'] as Map<String, bool>).entries.map(
                    (entry) => _buildTestResult(entry.key, entry.value),
                  ),
                ],
              ],
            ),
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
          content: Text('เกิดข้อผิดพลาด: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Widget _buildTestResult(String label, bool? result) {
    if (result == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.help_outline, color: AppTheme.mediumGray, size: 16),
            const SizedBox(width: 8),
            Text(label),
            const Spacer(),
            const Text('ไม่ทราบ', style: TextStyle(color: AppTheme.mediumGray)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            result ? Icons.check_circle : Icons.error,
            color: result ? AppTheme.successGreen : AppTheme.errorRed,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            result ? 'สำเร็จ' : 'ล้มเหลว',
            style: TextStyle(
              color: result ? AppTheme.successGreen : AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }

  void _showConnectionStats() {
    final stats = ConnectionService.getConnectionStats();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สถิติการเชื่อมต่อ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow('เซิร์ฟเวอร์ URL', stats['server_url']),
              _buildStatRow('สถานะ', stats['is_connected'] ? 'เชื่อมต่อ' : 'ไม่เชื่อมต่อ'),
              _buildStatRow('เชื่อมต่อครั้งล่าสุด', stats['last_connected'] ?? 'ไม่เคย'),
              _buildStatRow('ข้อผิดพลาดล่าสุด', stats['last_error'] ?? 'ไม่มี'),
              _buildStatRow('จำนวนครั้งที่ลอง', '${stats['retry_count']}/${stats['max_retries']}'),
              _buildStatRow('ช่วงเวลาตรวจสอบ', '${stats['check_interval']} วินาที'),
              _buildStatRow('Timeout', '${stats['timeout']} วินาที'),
            ],
          ),
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

  Widget _buildStatRow(String label, String value) {
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
