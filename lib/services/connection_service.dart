import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// 🔌 Connection Service สำหรับจัดการการเชื่อมต่อกับระบบเดิม
/// ตรวจสอบสถานะเซิร์ฟเวอร์ และจัดการการเชื่อมต่ออัตโนมัติ
class ConnectionService {
  static const Duration _checkInterval = Duration(seconds: 30);
  static const Duration _timeout = Duration(seconds: 5);
  
  static Timer? _connectionTimer;
  static bool _isConnected = false;
  static DateTime? _lastConnected;
  static String? _lastError;
  static int _retryCount = 0;
  static const int _maxRetries = 3;
  
  // Stream controllers for connection status
  static final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();
  static final StreamController<String> _errorController = 
      StreamController<String>.broadcast();
  
  // Public streams
  static Stream<bool> get connectionStream => _connectionController.stream;
  static Stream<String> get errorStream => _errorController.stream;
  
  // Getters
  static bool get isConnected => _isConnected;
  static DateTime? get lastConnected => _lastConnected;
  static String? get lastError => _lastError;
  static int get retryCount => _retryCount;

  /// 🚀 Start Connection Monitoring
  static void startMonitoring() {
    stopMonitoring();
    _connectionTimer = Timer.periodic(_checkInterval, (_) {
      checkConnection();
    });
    
    // Initial check
    checkConnection();
    
    debugPrint('🔌 Connection monitoring started');
  }

  /// 🛑 Stop Connection Monitoring
  static void stopMonitoring() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
    debugPrint('🔌 Connection monitoring stopped');
  }

  /// 🔍 Check Connection Status
  static Future<bool> checkConnection() async {
    try {
      debugPrint('🔍 Checking connection to server...');
      
      // Try to reach the health endpoint
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/health'),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        _onConnectionSuccess();
        return true;
      } else {
        _onConnectionError('Server returned status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      String errorMessage = error.toString();
      
      if (errorMessage.contains('Connection refused') || 
          errorMessage.contains('Connection reset')) {
        errorMessage = 'เซิร์ฟเวอร์ไม่ตอบสนอง';
      } else if (errorMessage.contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา';
      } else if (errorMessage.contains('Host')) {
        errorMessage = 'ไม่พบเซิร์ฟเวอร์';
      }
      
      _onConnectionError(errorMessage);
      return false;
    }
  }

  /// ✅ Handle Connection Success
  static void _onConnectionSuccess() {
    if (!_isConnected) {
      debugPrint('✅ Connected to server');
    }
    
    _isConnected = true;
    _lastConnected = DateTime.now();
    _lastError = null;
    _retryCount = 0;
    
    _connectionController.add(true);
  }

  /// ❌ Handle Connection Error
  static void _onConnectionError(String error) {
    if (_isConnected || _lastError != error) {
      debugPrint('❌ Connection error: $error');
    }
    
    _isConnected = false;
    _lastError = error;
    _retryCount++;
    
    _connectionController.add(false);
    _errorController.add(error);
    
    // Auto-retry logic
    if (_retryCount <= _maxRetries) {
      debugPrint('🔄 Auto-retry attempt $_retryCount/$_maxRetries');
      Future.delayed(Duration(seconds: _retryCount * 2), () {
        checkConnection();
      });
    } else {
      debugPrint('🚫 Max retries reached, stopping auto-retry');
    }
  }

  /// 🔄 Manual Retry Connection
  static Future<bool> retryConnection() async {
    debugPrint('🔄 Manual retry connection...');
    _retryCount = 0;
    return await checkConnection();
  }

  /// 📊 Get Connection Statistics
  static Map<String, dynamic> getConnectionStats() {
    return {
      'is_connected': _isConnected,
      'last_connected': _lastConnected?.toIso8601String(),
      'last_error': _lastError,
      'retry_count': _retryCount,
      'max_retries': _maxRetries,
      'check_interval': _checkInterval.inSeconds,
      'timeout': _timeout.inSeconds,
      'server_url': ApiService.baseUrl,
    };
  }

  /// 🏥 Get Server Health Information
  static Future<Map<String, dynamic>?> getServerHealth() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/health'),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return {
          'status': 'healthy',
          'response_time': DateTime.now().difference(_lastConnected ?? DateTime.now()).inMilliseconds,
          'server_time': response.headers['date'] ?? 'Unknown',
        };
      }
    } catch (error) {
      return {
        'status': 'unhealthy',
        'error': error.toString(),
      };
    }
    
    return null;
  }

  /// ℹ️ Get Server Information
  static Future<Map<String, dynamic>?> getServerInfo() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/info'),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return {
          'version': response.headers['server'] ?? 'Unknown',
          'build_date': response.headers['build-date'] ?? 'Unknown',
          'environment': kDebugMode ? 'development' : 'production',
        };
      }
    } catch (error) {
      debugPrint('Failed to get server info: $error');
    }
    
    return null;
  }

  /// 🧪 Test API Endpoint
  static Future<bool> testEndpoint(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
      ).timeout(_timeout);

      return response.statusCode < 500; // Accept any non-server-error response
    } catch (error) {
      debugPrint('Endpoint test failed for $endpoint: $error');
      return false;
    }
  }

  /// 📡 Test Multiple Endpoints
  static Future<Map<String, bool>> testEndpoints() async {
    final endpoints = [
      '/api/health',
      '/api/info',
      '/login',
      '/api/dashboard',
      '/api/reference-data',
    ];
    
    final results = <String, bool>{};
    
    for (final endpoint in endpoints) {
      results[endpoint] = await testEndpoint(endpoint);
    }
    
    return results;
  }

  /// 🔧 Switch Server URL (for development/testing)
  static void switchServer(String newBaseUrl) {
    debugPrint('🔧 Switching server to: $newBaseUrl');
    // Note: This would require making ApiService._baseUrl mutable
    // For now, this is just a placeholder for the concept
  }

  /// 📱 Check Internet Connectivity
  static Future<bool> checkInternetConnection() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }

  /// 🎯 Comprehensive Connection Test
  static Future<Map<String, dynamic>> performComprehensiveTest() async {
    debugPrint('🎯 Performing comprehensive connection test...');
    
    final results = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'internet_connection': await checkInternetConnection(),
      'server_connection': await checkConnection(),
      'server_health': await getServerHealth(),
      'server_info': await getServerInfo(),
      'endpoint_tests': await testEndpoints(),
      'connection_stats': getConnectionStats(),
    };
    
    debugPrint('📊 Comprehensive test completed');
    return results;
  }

  /// 🧹 Cleanup Resources
  static void dispose() {
    stopMonitoring();
    _connectionController.close();
    _errorController.close();
    debugPrint('🧹 Connection service disposed');
  }

  /// 📝 Connection Status Summary
  static String getStatusSummary() {
    if (_isConnected) {
      final uptime = _lastConnected != null 
        ? DateTime.now().difference(_lastConnected!).inMinutes
        : 0;
      return '✅ เชื่อมต่อแล้ว (${uptime} นาที)';
    } else {
      if (_retryCount > 0) {
        return '❌ ไม่สามารถเชื่อมต่อ (ลองใหม่ $_retryCount/$_maxRetries)';
      } else {
        return '❌ ไม่สามารถเชื่อมต่อ';
      }
    }
  }

  /// 🎨 Get Status Color (for UI)
  static String getStatusColor() {
    if (_isConnected) {
      return '#28A745'; // Green
    } else if (_retryCount > 0) {
      return '#FFA500'; // Orange
    } else {
      return '#DC3545'; // Red
    }
  }

  /// 🔄 Reset Connection State
  static void resetConnectionState() {
    _isConnected = false;
    _lastConnected = null;
    _lastError = null;
    _retryCount = 0;
    debugPrint('🔄 Connection state reset');
  }
}
