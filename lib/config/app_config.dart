import 'package:flutter/foundation.dart';

/// ⚙️ Application Configuration
/// จัดการค่าต่างๆ ของแอปพลิเคชันแบบ Centralized
class AppConfig {
  // 🌐 Environment Configuration
  static const bool isDevelopment = kDebugMode;
  static const bool isProduction = !kDebugMode;
  
  // 🌐 Server URLs
  static const String _devServerUrl = 'https://cmo.mida-leasing.com';
  static const String _prodServerUrl = 'https://cmo.mida-leasing.com';
  
  static String get serverUrl => isDevelopment ? _devServerUrl : _prodServerUrl;
  
  // ⏱️ Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration syncTimeout = Duration(minutes: 2);
  
  // 🔄 Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const double backoffMultiplier = 2.0;
  
  // 💾 Cache Configuration
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration dataRefreshInterval = Duration(minutes: 10);
  static const int maxCacheSize = 100; // MB
  
  // 📱 App Information
  static const String appName = 'CMO APP';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // 🔐 Security Configuration
  static const bool requireAuthentication = true;
  static const Duration sessionTimeout = Duration(hours: 8);
  static const Duration tokenRefreshThreshold = Duration(minutes: 15);
  
  // 📊 Logging Configuration
  static const bool enableLogging = true;
  static const bool enableDebugLogs = kDebugMode;
  static const int maxLogFileSize = 10; // MB
  static const int maxLogFiles = 5;
  
  // 🎨 UI Configuration
  static const bool enableAnimations = true;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const bool enableHapticFeedback = true;
  
  // 📁 File Upload Configuration
  static const int maxFileSize = 10; // MB
  static const List<String> allowedFileTypes = [
    'pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'
  ];
  static const int maxFilesPerUpload = 5;
  
  // 🔍 Search Configuration
  static const int searchResultsLimit = 50;
  static const int searchDebounceMs = 500;
  static const Duration searchTimeout = Duration(seconds: 10);
  
  // 📈 Pagination Configuration
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 🌐 API Configuration
  static const Map<String, String> apiHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'LuxuryLoanApp/1.0',
  };
  
  // 📡 WebSocket Configuration
  static const bool enableWebSocket = true;
  static const Duration websocketPingInterval = Duration(seconds: 30);
  static const Duration websocketTimeout = Duration(seconds: 10);
  
  // 🗂️ Feature Flags
  static const bool enableOfflineMode = false;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = false;
  static const bool enableMultiLanguage = true;
  
  // 📊 Analytics Configuration
  static const bool enableAnalytics = true;
  static const Duration analyticsBatchInterval = Duration(minutes: 5);
  static const int maxAnalyticsEvents = 100;
  
  // 🎯 Business Rules
  static const double minLoanAmount = 10000.0;
  static const double maxLoanAmount = 5000000.0;
  static const int minLoanTermMonths = 6;
  static const int maxLoanTermMonths = 84;
  static const double maxDTIRatio = 0.5; // 50%
  
  // 📱 Device Configuration
  static const bool requireDeviceVerification = false;
  static const int maxDevicesPerUser = 3;
  static const Duration deviceTokenExpiry = Duration(days: 30);
  
  // 🗃️ Database Configuration
  static const String databaseName = 'luxury_loan_app.db';
  static const int databaseVersion = 1;
  static const bool enableDatabaseEncryption = true;
  
  // 🌐 Localization Configuration
  static const String defaultLocale = 'th_TH';
  static const List<String> supportedLocales = [
    'th_TH', 'en_US',
  ];
  
  // 🔧 Development Configuration
  static const bool enableMockData = kDebugMode;
  static const bool enableNetworkInspector = kDebugMode;
  static const bool enableDebugMenu = kDebugMode;
  
  // 📡 Monitoring Configuration
  static const bool enablePerformanceMonitoring = true;
  static const bool enableCrashReporting = true;
  static const Duration metricsCollectionInterval = Duration(minutes: 1);
  
  // 🎨 Theme Configuration
  static const bool enableCustomThemes = true;
  static const String defaultTheme = 'light';
  static const List<String> availableThemes = [
    'light', 'dark', 'blue', 'green',
  ];
  
  // 📊 Reporting Configuration
  static const bool enableExportReports = true;
  static const List<String> supportedExportFormats = [
    'pdf', 'excel', 'csv',
  ];
  static const int maxReportRows = 10000;
  
  // 🔗 External Services Configuration
  static const bool enableGoogleMaps = true;
  static const bool enableFacebookLogin = false;
  static const bool enableGoogleLogin = false;
  static const bool enableLineLogin = true;
  
  // 📱 Notification Configuration
  static const Duration notificationDisplayDuration = Duration(seconds: 5);
  static const bool enableSoundNotifications = true;
  static const bool enableVibrationNotifications = true;
  
  // 🎯 Validation Configuration
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxPhoneNumberLength = 15;
  static const int maxIdCardLength = 13;
  
  // 🔄 Sync Configuration
  static const Duration autoSyncInterval = Duration(minutes: 15);
  static const bool enableBackgroundSync = true;
  static const int maxSyncRetries = 5;
  
  // 📊 Cache Keys
  static const String userCacheKey = 'user_data';
  static const String dashboardCacheKey = 'dashboard_data';
  static const String loanApplicationsCacheKey = 'loan_applications';
  static const String guarantorsCacheKey = 'guarantors';
  static const String referenceDataCacheKey = 'reference_data';
  
  // 🔐 Security Keys
  static const String encryptionKey = 'luxury_loan_app_encryption_key_2024';
  static const String jwtSecretKey = 'luxury_loan_app_jwt_secret';
  
  // 📱 App Store Configuration
  static const String appStoreId = 'com.luxuryloan.app';
  static const String playStoreId = 'com.luxuryloan.app';
  
  // 📞 Support Configuration
  static const String supportEmail = 'support@luxuryloan.com';
  static const String supportPhone = '02-123-4567';
  static const String supportWebsite = 'https://support.luxuryloan.com';
  
  // 📊 Legal Configuration
  static const String privacyPolicyUrl = 'https://luxuryloan.com/privacy';
  static const String termsOfServiceUrl = 'https://luxuryloan.com/terms';
  static const String cookiePolicyUrl = 'https://luxuryloan.com/cookies';
  
  // 🎯 Get Configuration Summary
  static Map<String, dynamic> getConfigSummary() {
    return {
      'app': {
        'name': appName,
        'version': appVersion,
        'build': buildNumber,
        'environment': isDevelopment ? 'development' : 'production',
      },
      'server': {
        'url': serverUrl,
        'timeout': connectionTimeout.inSeconds,
      },
      'features': {
        'offline_mode': enableOfflineMode,
        'push_notifications': enablePushNotifications,
        'biometric_auth': enableBiometricAuth,
        'dark_mode': enableDarkMode,
        'multi_language': enableMultiLanguage,
      },
      'security': {
        'require_auth': requireAuthentication,
        'session_timeout': sessionTimeout.inHours,
        'max_devices': maxDevicesPerUser,
      },
      'ui': {
        'animations': enableAnimations,
        'haptic_feedback': enableHapticFeedback,
        'default_theme': defaultTheme,
      },
      'limits': {
        'max_file_size': maxFileSize,
        'max_files_per_upload': maxFilesPerUpload,
        'search_results': searchResultsLimit,
        'page_size': defaultPageSize,
      },
    };
  }
  
  // 🎯 Get Environment Specific Config
  static Map<String, dynamic> getEnvironmentConfig() {
    if (isDevelopment) {
      return {
        'debug_mode': true,
        'mock_data': enableMockData,
        'network_inspector': enableNetworkInspector,
        'debug_menu': enableDebugMenu,
        'logging_level': 'debug',
      };
    } else {
      return {
        'debug_mode': false,
        'mock_data': false,
        'network_inspector': false,
        'debug_menu': false,
        'logging_level': 'error',
      };
    }
  }
  
  // 🎯 Validate Configuration
  static bool validateConfig() {
    // Basic validation checks
    if (serverUrl.isEmpty) return false;
    if (maxFileSize <= 0) return false;
    if (maxRetries < 0) return false;
    if (defaultPageSize <= 0) return false;
    
    return true;
  }
  
  // 🎯 Get API Headers with Dynamic Values
  static Map<String, String> getApiHeaders({String? authToken}) {
    final headers = Map<String, String>.from(apiHeaders);
    
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    
    headers['X-App-Version'] = appVersion;
    headers['X-Platform'] = 'mobile';
    headers['X-Environment'] = isDevelopment ? 'development' : 'production';
    
    return headers;
  }
  
  // 🎯 Get Cache Duration for Specific Data Type
  static Duration getCacheDuration(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'user':
        return const Duration(hours: 1);
      case 'dashboard':
        return const Duration(minutes: 5);
      case 'loan_applications':
        return const Duration(minutes: 10);
      case 'guarantors':
        return const Duration(minutes: 15);
      case 'reference_data':
        return const Duration(hours: 24);
      default:
        return cacheDuration;
    }
  }
  
  // 🎯 Format File Size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  // 🎯 Validate File Type
  static bool isFileTypeAllowed(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedFileTypes.contains(extension);
  }
  
  // 🎯 Get Supported Languages
  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'th_TH', 'name': 'ไทย', 'native_name': 'ไทย'},
      {'code': 'en_US', 'name': 'English', 'native_name': 'English'},
    ];
  }
  
  // 🎯 Get App Information
  static Map<String, String> getAppInfo() {
    return {
      'name': appName,
      'version': appVersion,
      'build': buildNumber,
      'environment': isDevelopment ? 'Development' : 'Production',
      'server': serverUrl,
      'support': supportPhone,
    };
  }
}
