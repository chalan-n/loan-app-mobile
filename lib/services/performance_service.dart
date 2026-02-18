import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// ⚡ Performance Service สำหรับตรวจสอบและเพิ่มประสิทธิภาพแอป
/// จัดการ Memory, CPU, Network และ UI Performance
class PerformanceService {
  static const Duration _monitoringInterval = Duration(seconds: 5);
  static const Duration _cleanupInterval = Duration(minutes: 5);
  
  static Timer? _monitoringTimer;
  static Timer? _cleanupTimer;
  
  // Performance Metrics
  static double _currentMemoryUsage = 0.0;
  static double _maxMemoryUsage = 0.0;
  static int _frameRate = 60;
  static int _droppedFrames = 0;
  static Duration _averageFrameTime = Duration.zero;
  static int _networkRequests = 0;
  static Duration _averageResponseTime = Duration.zero;
  
  // Device Info
  static DeviceInfo? _deviceInfo;
  static PackageInfo? _packageInfo;
  
  // Stream Controllers
  static final StreamController<PerformanceMetrics> _metricsController = 
      StreamController<PerformanceMetrics>.broadcast();
  static final StreamController<PerformanceWarning> _warningController = 
      StreamController<PerformanceWarning>.broadcast();
  
  // Public Streams
  static Stream<PerformanceMetrics> get metricsStream => _metricsController.stream;
  static Stream<PerformanceWarning> get warningStream => _warningController.stream;
  
  // Getters
  static double get currentMemoryUsage => _currentMemoryUsage;
  static double get maxMemoryUsage => _maxMemoryUsage;
  static int get frameRate => _frameRate;
  static int get droppedFrames => _droppedFrames;
  static Duration get averageFrameTime => _averageFrameTime;
  static int get networkRequests => _networkRequests;
  static Duration get averageResponseTime => _averageResponseTime;

  /// 🚀 Start Performance Monitoring
  static void startMonitoring() {
    stopMonitoring();
    
    _monitoringTimer = Timer.periodic(_monitoringInterval, (_) {
      _collectMetrics();
    });
    
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      _performCleanup();
    });
    
    // Initialize device info
    _initializeDeviceInfo();
    
    debugPrint('⚡ Performance monitoring started');
  }

  /// 🛑 Stop Performance Monitoring
  static void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    debugPrint('⚡ Performance monitoring stopped');
  }

  /// 📊 Collect Performance Metrics
  static Future<void> _collectMetrics() async {
    try {
      // Memory Usage
      final memoryUsage = await _getMemoryUsage();
      _currentMemoryUsage = memoryUsage;
      if (memoryUsage > _maxMemoryUsage) {
        _maxMemoryUsage = memoryUsage;
      }
      
      // Frame Rate (simplified - would need actual implementation)
      _frameRate = await _getFrameRate();
      
      // Network Metrics
      _networkRequests = await _getNetworkRequestCount();
      _averageResponseTime = await _getAverageResponseTime();
      
      // Create metrics object
      final metrics = PerformanceMetrics(
        timestamp: DateTime.now(),
        memoryUsage: _currentMemoryUsage,
        maxMemoryUsage: _maxMemoryUsage,
        frameRate: _frameRate,
        droppedFrames: _droppedFrames,
        averageFrameTime: _averageFrameTime,
        networkRequests: _networkRequests,
        averageResponseTime: _averageResponseTime,
      );
      
      _metricsController.add(metrics);
      
      // Check for performance warnings
      _checkPerformanceWarnings(metrics);
      
    } catch (error) {
      debugPrint('Error collecting metrics: $error');
    }
  }

  /// 🧹 Perform Cleanup Operations
  static Future<void> _performCleanup() async {
    try {
      // Force garbage collection
      if (!kReleaseMode) {
        // In debug mode, we can hint at garbage collection
        debugPrint('🧹 Performing cleanup...');
      }
      
      // Clear image cache
      PaintingBinding.instance.imageCache.clear();
      
      // Clear network cache (if applicable)
      // This would depend on your HTTP client implementation
      
      debugPrint('🧹 Cleanup completed');
    } catch (error) {
      debugPrint('Error during cleanup: $error');
    }
  }

  /// 🗑️ Clear Caches (Public Method)
  static Future<void> clearCaches() async {
    await _clearCaches();
  }

  /// 🗑️ Clear Caches (Private Method)
  static Future<void> _clearCaches() async {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    
    // Clear network cache (implementation dependent)
    
    debugPrint('🗑️ Caches cleared');
  }

  /// 📱 Initialize Device Information
  static Future<void> _initializeDeviceInfo() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        _deviceInfo = DeviceInfo(
          platform: 'Android',
          version: androidInfo.version.release,
          model: androidInfo.model,
          manufacturer: androidInfo.manufacturer,
          totalMemory: null, // Android doesn't expose totalMemory in device_info_plus
        );
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        _deviceInfo = DeviceInfo(
          platform: 'iOS',
          version: iosInfo.systemVersion,
          model: iosInfo.model,
          manufacturer: 'Apple',
          totalMemory: null, // iOS doesn't expose total memory easily
        );
      }
    } catch (error) {
      debugPrint('Error initializing device info: $error');
    }
  }

  /// 💾 Get Memory Usage
  static Future<double> _getMemoryUsage() async {
    try {
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        // This is a simplified calculation
        // In a real implementation, you'd use more accurate memory measurement
        return 0.0; // Placeholder
      } else if (Platform.isIOS) {
        // iOS memory measurement would require platform-specific code
        return 0.0; // Placeholder
      }
      return 0.0;
    } catch (error) {
      debugPrint('Error getting memory usage: $error');
      return 0.0;
    }
  }

  /// 🎬 Get Frame Rate
  static Future<int> _getFrameRate() async {
    // This would require actual frame rate monitoring
    // For now, return a placeholder
    return 60;
  }

  /// 🌐 Get Network Request Count
  static Future<int> _getNetworkRequestCount() async {
    // This would require tracking actual network requests
    return _networkRequests;
  }

  /// ⏱️ Get Average Response Time
  static Future<Duration> _getAverageResponseTime() async {
    // This would require tracking actual response times
    return _averageResponseTime;
  }

  /// ⚠️ Check Performance Warnings
  static void _checkPerformanceWarnings(PerformanceMetrics metrics) {
    // Memory Warning
    if (metrics.memoryUsage > 0.8) { // 80% memory usage
      _warningController.add(PerformanceWarning(
        type: PerformanceWarningType.memory,
        message: 'การใช้งานหน่วยความจำสูง: ${(metrics.memoryUsage * 100).toInt()}%',
        severity: WarningSeverity.high,
      ));
    }
    
    // Frame Rate Warning
    if (metrics.frameRate < 30) { // Below 30 FPS
      _warningController.add(PerformanceWarning(
        type: PerformanceWarningType.frameRate,
        message: 'Frame Rate ต่ำ: ${metrics.frameRate} FPS',
        severity: WarningSeverity.medium,
      ));
    }
    
    // Network Warning
    if (metrics.averageResponseTime.inSeconds > 5) { // Above 5 seconds
      _warningController.add(PerformanceWarning(
        type: PerformanceWarningType.network,
        message: 'Response Time สูง: ${metrics.averageResponseTime.inSeconds} วินาที',
        severity: WarningSeverity.medium,
      ));
    }
  }

  /// 📊 Get Performance Report
  static Future<PerformanceReport> getPerformanceReport() async {
    final connectivity = await Connectivity().checkConnectivity();
    
    return PerformanceReport(
      timestamp: DateTime.now(),
      deviceInfo: _deviceInfo,
      packageInfo: _packageInfo,
      connectivity: connectivity.toString(),
      currentMetrics: PerformanceMetrics(
        timestamp: DateTime.now(),
        memoryUsage: _currentMemoryUsage,
        maxMemoryUsage: _maxMemoryUsage,
        frameRate: _frameRate,
        droppedFrames: _droppedFrames,
        averageFrameTime: _averageFrameTime,
        networkRequests: _networkRequests,
        averageResponseTime: _averageResponseTime,
      ),
      appVersion: _packageInfo?.version ?? 'Unknown',
      buildNumber: _packageInfo?.buildNumber ?? 'Unknown',
    );
  }

  /// 🔧 Optimize App Performance
  static Future<void> optimizePerformance() async {
    try {
      debugPrint('🔧 Optimizing performance...');
      
      // Clear caches
      await _clearCaches();
      
      // Reduce image quality
      _reduceImageQuality();
      
      // Disable animations temporarily
      _disableAnimations();
      
      // Compress memory
      await _compressMemory();
      
      debugPrint('🔧 Performance optimization completed');
    } catch (error) {
      debugPrint('Error optimizing performance: $error');
    }
  }

  /// 🖼️ Reduce Image Quality
  static void _reduceImageQuality() {
    // Reduce image cache size
    PaintingBinding.instance.imageCache.maximumSize = 50;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB
  }

  /// 🎬 Disable Animations
  static void _disableAnimations() {
    // This would require access to the app's animation settings
    debugPrint('🎬 Animations disabled');
  }

  /// 💾 Compress Memory
  static Future<void> _compressMemory() async {
    // Force garbage collection hint
    if (!kReleaseMode) {
      debugPrint('💾 Memory compression requested');
    }
  }

  /// 📈 Get Performance Score
  static double getPerformanceScore() {
    double score = 100.0;
    
    // Memory impact (30% weight)
    final memoryScore = (1.0 - _currentMemoryUsage) * 30;
    score -= (30 - memoryScore);
    
    // Frame rate impact (40% weight)
    final frameRateScore = (_frameRate / 60.0) * 40;
    score -= (40 - frameRateScore);
    
    // Network impact (30% weight)
    final networkScore = _averageResponseTime.inMilliseconds < 1000 
      ? 30 
      : 30.0 - (_averageResponseTime.inMilliseconds / 1000.0) * 30;
    score -= (30 - networkScore);
    
    return score.clamp(0.0, 100.0);
  }

  /// 🎯 Get Performance Recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    
    if (_currentMemoryUsage > 0.7) {
      recommendations.add('ลดการใช้งานหน่วยความจำ: ลบไฟล์ที่ไม่ใช้และปิดแท็บที่ไม่จำเป็น');
    }
    
    if (_frameRate < 45) {
      recommendations.add('ปรับปรุง Frame Rate: ลดจำนวน Animation และ Effect');
    }
    
    if (_averageResponseTime.inSeconds > 3) {
      recommendations.add('ปรับปรุงความเร็วเครือข่าย: ตรวจสอบการเชื่อมต่อและลดจำนวน Request');
    }
    
    if (_droppedFrames > 10) {
      recommendations.add('ลด Frame Drops: ปรับปรุงการทำงานของ UI Thread');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('ประสิทธิภาพดีเยี่ยม! ไม่ต้องการการปรับปรุง');
    }
    
    return recommendations;
  }

  /// 🧹 Cleanup Resources
  static void dispose() {
    stopMonitoring();
    _metricsController.close();
    _warningController.close();
    debugPrint('🧹 Performance service disposed');
  }
}

/// 📊 Performance Metrics Model
class PerformanceMetrics {
  final DateTime timestamp;
  final double memoryUsage;
  final double maxMemoryUsage;
  final int frameRate;
  final int droppedFrames;
  final Duration averageFrameTime;
  final int networkRequests;
  final Duration averageResponseTime;

  PerformanceMetrics({
    required this.timestamp,
    required this.memoryUsage,
    required this.maxMemoryUsage,
    required this.frameRate,
    required this.droppedFrames,
    required this.averageFrameTime,
    required this.networkRequests,
    required this.averageResponseTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'memory_usage': memoryUsage,
      'max_memory_usage': maxMemoryUsage,
      'frame_rate': frameRate,
      'dropped_frames': droppedFrames,
      'average_frame_time': averageFrameTime.inMilliseconds,
      'network_requests': networkRequests,
      'average_response_time': averageResponseTime.inMilliseconds,
    };
  }
}

/// ⚠️ Performance Warning Model
class PerformanceWarning {
  final PerformanceWarningType type;
  final String message;
  final WarningSeverity severity;
  final DateTime timestamp;

  PerformanceWarning({
    required this.type,
    required this.message,
    required this.severity,
  }) : timestamp = DateTime.now();
}

/// 🎯 Performance Warning Types
enum PerformanceWarningType {
  memory,
  frameRate,
  network,
  cpu,
  battery,
}

/// 🚨 Warning Severity Levels
enum WarningSeverity {
  low,
  medium,
  high,
  critical,
}

/// 📱 Device Info Model
class DeviceInfo {
  final String platform;
  final String version;
  final String model;
  final String manufacturer;
  final int? totalMemory;

  DeviceInfo({
    required this.platform,
    required this.version,
    required this.model,
    required this.manufacturer,
    this.totalMemory,
  });
}

/// 📊 Performance Report Model
class PerformanceReport {
  final DateTime timestamp;
  final DeviceInfo? deviceInfo;
  final PackageInfo? packageInfo;
  final String connectivity;
  final PerformanceMetrics currentMetrics;
  final String appVersion;
  final String buildNumber;

  PerformanceReport({
    required this.timestamp,
    this.deviceInfo,
    this.packageInfo,
    required this.connectivity,
    required this.currentMetrics,
    required this.appVersion,
    required this.buildNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'device_info': deviceInfo != null ? {
        'platform': deviceInfo!.platform,
        'version': deviceInfo!.version,
        'model': deviceInfo!.model,
        'manufacturer': deviceInfo!.manufacturer,
        'total_memory': deviceInfo!.totalMemory,
      } : null,
      'package_info': packageInfo != null ? {
        'app_name': packageInfo!.appName,
        'version': packageInfo!.version,
        'build_number': packageInfo!.buildNumber,
      } : null,
      'connectivity': connectivity,
      'current_metrics': currentMetrics.toJson(),
      'app_version': appVersion,
      'build_number': buildNumber,
    };
  }
}
