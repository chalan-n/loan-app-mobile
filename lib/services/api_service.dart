import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// 🔌 API Service สำหรับเชื่อมต่อกับระบบเดิม (C:\loan-app)
/// รองรับการเชื่อมต่อกับ Go Backend ผ่าน HTTP/HTTPS
class ApiService {
  static String get _baseUrl => AppConfig.serverUrl;
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _syncTimeout = Duration(minutes: 2);
  
  // Public getter for base URL
  static String get baseUrl => _baseUrl;
  
  static String? _token;
  static String? _rawCookie; // 🍪 เก็บ raw cookie string จาก Set-Cookie header
  
  static void setToken(String? token) {
    _token = token;
  }

  /// 🍪 เก็บ raw cookie สำหรับส่งกับทุก request
  static void setRawCookie(String? cookie) {
    _rawCookie = cookie;
    debugPrint('🍪 [API] Set raw cookie: ${cookie != null ? "${cookie.substring(0, cookie.length > 50 ? 50 : cookie.length)}..." : "null"}');
  }

  // Headers สำหรับทุก request
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/html',
      'User-Agent': 'LuxuryLoanApp/1.0',
    };
    
    // 🍪 ส่ง session cookie (เพราะ server ใช้ web form login)
    if (_rawCookie != null && _rawCookie!.isNotEmpty) {
      headers['Cookie'] = _rawCookie!;
    }
    
    // ถ้ามี Bearer token ก็ส่งไปด้วย (สำหรับ API ที่รองรับ JWT)
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  static const int _maxRetries = 3;

  /// 🔄 Retry & Error Handling Helper
  static Future<http.Response> _sendRequest(Future<http.Response> Function() requestFunc) async {
    int attempts = 0;
    while (attempts < _maxRetries) {
      try {
        final response = await requestFunc().timeout(_timeout);
        
        // ถ้าเป็น 5xx Server Error ให้ Retry
        if (response.statusCode >= 500) {
          throw Exception('Server Error: ${response.statusCode}');
        }
        
        return response;
      } on SocketException {
        if (attempts >= _maxRetries - 1) throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้');
      } on http.ClientException {
        if (attempts >= _maxRetries - 1) throw Exception('การเชื่อมต่อขัดข้อง');
      } on TimeoutException {
        if (attempts >= _maxRetries - 1) throw Exception('หมดเวลาเชื่อต่อ (Timeout)');
      } catch (e) {
        if (attempts >= _maxRetries - 1) rethrow;
      }
      
      attempts++;
      // Exponential Backoff: 2s, 4s, 8s...
      await Future.delayed(Duration(seconds: 2 * attempts));
    }
    throw Exception('Failed to connect after $_maxRetries attempts');
  }

  /// 🔐 Authentication
  /// Server ใช้ Web Form Login (x-www-form-urlencoded) 
  /// - 302 redirect ไป ?status=error = credentials ผิด
  /// - 302 redirect ไปหน้าอื่น (เช่น /dashboard) = login สำเร็จ
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      debugPrint('🌐 [API] Login URL: $_baseUrl/login');
      
      final client = http.Client();
      try {
        // 📝 ส่งเป็น form-encoded data (ไม่ใช่ JSON)
        final request = http.Request(
          'POST',
          Uri.parse('$_baseUrl/login'),
        );

        // ⚠️ ห้าม follow redirect อัตโนมัติ เพราะต้องอ่าน redirect location เอง
        request.followRedirects = false;
        
        request.headers.addAll({
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json, text/html, */*',
          'User-Agent': 'LuxuryLoanApp/1.0',
        });
        
        // ส่งเป็น form data
        request.body = 'username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}';
        
        debugPrint('🌐 [API] Sending form data: username=$username');
        
        final streamedResponse = await client.send(request).timeout(_timeout);
        final response = await http.Response.fromStream(streamedResponse);
        
        debugPrint('🌐 [API] Login status: ${response.statusCode}');
        debugPrint('🌐 [API] Login headers: ${response.headers}');
        debugPrint('🌐 [API] Login response body: ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}');
        
        // ✅ Case 1: Server ตอบ 200 + JSON (API style)
        if (response.statusCode == 200) {
          // ลองแปลงเป็น JSON
          try {
            return jsonDecode(response.body);
          } catch (_) {
            // ถ้าไม่ใช่ JSON แต่ status 200 = login สำเร็จ
            debugPrint('✅ [API] 200 OK but non-JSON response, treating as success');
            final cookies = response.headers['set-cookie'];
            // 🍪 เก็บ raw cookie
            if (cookies != null && cookies.isNotEmpty) {
              setRawCookie(cookies);
            }
            return {
              'success': true,
              'user': {'username': username, 'id': username},
              'token': _extractTokenFromCookies(cookies),
            };
          }
        }
        
        // 🔄 Case 2: Server redirect (302)
        if (response.statusCode == 301 || response.statusCode == 302) {
          final redirectUrl = response.headers['location'] ?? '';
          final cookies = response.headers['set-cookie'];
          debugPrint('🔄 [API] Redirect to: $redirectUrl');
          debugPrint('🍪 [API] Set-Cookie: $cookies');
          
          // ❌ Redirect ไป error page = login ผิดพลาด
          if (redirectUrl.contains('error') || redirectUrl.contains('failed')) {
            throw Exception('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
          }
          
          // ✅ Redirect ไปหน้า dashboard/home/success = login สำเร็จ
          final token = _extractTokenFromCookies(cookies);
          debugPrint('🔑 [API] Extracted token: ${token.isNotEmpty ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "none"}');
          
          // 🍪 เก็บ raw cookie สำหรับใช้กับ request ถัดๆ ไป
          if (cookies != null && cookies.isNotEmpty) {
            setRawCookie(cookies);
          }
          
          return {
            'success': true,
            'user': {'username': username, 'id': username},
            'token': token,
          };
        }
        
        // ❌ Case 3: 401 Unauthorized
        if (response.statusCode == 401) {
          throw Exception('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
        }
        
        // ❌ Case 4: อื่นๆ
        throw Exception('Login failed: ${response.statusCode}');
      } finally {
        client.close();
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// 🍪 ดึง token/session จาก Set-Cookie header
  static String _extractTokenFromCookies(String? cookieHeader) {
    if (cookieHeader == null || cookieHeader.isEmpty) return '';
    
    debugPrint('🍪 [API] Parsing cookies: $cookieHeader');
    
    // ค้นหา session token จาก cookie patterns ทั่วไป
    // รูปแบบ: session=xxx; หรือ token=xxx; หรือ jwt=xxx;
    final patterns = ['session', 'token', 'jwt', 'sid', 'access_token', 'auth'];
    
    for (final pattern in patterns) {
      final regex = RegExp('$pattern=([^;]+)', caseSensitive: false);
      final match = regex.firstMatch(cookieHeader);
      if (match != null) {
        debugPrint('🔑 [API] Found cookie "$pattern": ${match.group(1)!.substring(0, match.group(1)!.length > 20 ? 20 : match.group(1)!.length)}...');
        return match.group(1)!;
      }
    }
    
    // ถ้าไม่พบ pattern ที่รู้จัก ส่งคืน cookie ทั้งหมด
    return cookieHeader;
  }

  static Future<void> logout() async {
    try {
      await _sendRequest(() => http.post(
              Uri.parse('$_baseUrl/logout'),
              headers: _headers,
            ));
      _token = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// 📊 Dashboard Data
  /// 📊 Dashboard Data
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/dashboard'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Dashboard data error: $e');
    }
  }

  /// 📋 Get Loan List — ดึงรายการสินเชื่อทั้งหมด
  static Future<List<Map<String, dynamic>>> getLoanList() async {
    try {
      debugPrint('🔍 GET $_baseUrl/api/loan-list');
      debugPrint('🍪 Cookies: ${_rawCookie != null ? "present" : "null"}');
      debugPrint('🔑 Token: ${_token != null ? "present" : "null"}');
      
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/loan-list'),
        headers: _headers,
      ));

      debugPrint('📥 Response: ${response.statusCode}');
      debugPrint('📥 Content-Type: ${response.headers['content-type']}');
      debugPrint('📥 Body preview: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');
      
      if (response.statusCode == 200) {
        // ⚠️ ตรวจสอบว่าเป็น HTML หรือ JSON
        final body = response.body.trim();
        if (body.startsWith('<!DOCTYPE') || body.startsWith('<html') || body.startsWith('<')) {
          debugPrint('⚠️ Server returned HTML instead of JSON — session may have expired');
          throw Exception('เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่');
        }
        
        final data = jsonDecode(body);
        // รองรับหลาย format: { loans: [...] } หรือ [...] โดยตรง
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('loans')) {
          return List<Map<String, dynamic>>.from(data['loans'] ?? []);
        } else if (data is Map && data.containsKey('data')) {
          return List<Map<String, dynamic>>.from(data['data'] ?? []);
        } else if (data is Map && data.containsKey('applications')) {
          return List<Map<String, dynamic>>.from(data['applications'] ?? []);
        }
        return [];
      } else {
        throw Exception('Failed to load loans: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ getLoanList error: $e');
      throw Exception('Get loan list error: $e');
    }
  }

  /// 📝 Loan Application Steps
  static Future<Map<String, dynamic>> getLoanApplication(String loanId) async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/loan/$loanId'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load loan application: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Loan application error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep1(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step1'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 1 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep2(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step2'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 2: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 2 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep3(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step3'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 3: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 3 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep4(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step4'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 4: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 4 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep5(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step5'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 5: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 5 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep6(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step6'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 6: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 6 save error: $e');
    }
  }

  static Future<Map<String, dynamic>> saveStep7(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/step7'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save Step 7: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Step 7 save error: $e');
    }
  }

  /// 👥 Guarantor Management
  static Future<List<Map<String, dynamic>>> getGuarantors(String loanId) async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/guarantors?loan_id=$loanId'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['guarantors'] ?? []);
      } else {
        throw Exception('Failed to load guarantors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Guarantors load error: $e');
    }
  }

  static Future<Map<String, dynamic>> addGuarantor(Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/add-guarantor'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add guarantor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Add guarantor error: $e');
    }
  }

  static Future<Map<String, dynamic>> updateGuarantor(int guarantorId, Map<String, dynamic> data) async {
    try {
      final response = await _sendRequest(() => http.put(
        Uri.parse('$_baseUrl/api/guarantors/$guarantorId'),
        headers: _headers,
        body: jsonEncode(data),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update guarantor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update guarantor error: $e');
    }
  }

  static Future<void> deleteGuarantor(int guarantorId) async {
    try {
      final response = await _sendRequest(() => http.delete(
        Uri.parse('$_baseUrl/delete-guarantor?id=$guarantorId'),
        headers: _headers,
      ));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete guarantor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Delete guarantor error: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> searchGuarantors(String query) async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/guarantors/search?q=$query'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['guarantors'] ?? []);
      } else {
        throw Exception('Failed to search guarantors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search guarantors error: $e');
    }
  }

  /// 📋 Reference Data (Dropdowns, etc.)
  static Future<Map<String, dynamic>> getReferenceData() async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/reference-data'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reference data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Reference data error: $e');
    }
  }

  /// 📁 File Upload
  static Future<Map<String, dynamic>> uploadFile(File file, String type) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/upload'),
      );
      
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
      request.fields['type'] = type;
      request.headers.addAll(_headers);

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('File upload error: $e');
    }
  }

  /// 🔍 Loan Search
  static Future<List<Map<String, dynamic>>> searchLoans(String query) async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/loans/search?q=$query'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['loans'] ?? []);
      } else {
        throw Exception('Failed to search loans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search loans error: $e');
    }
  }

  /// 📈 Reports
  static Future<Map<String, dynamic>> getReport(String reportType, Map<String, dynamic> params) async {
    try {
      final queryString = params.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/reports/$reportType?$queryString'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Report error: $e');
    }
  }

  /// 🔧 Utility Methods
  static Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/health'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getServerInfo() async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/info'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get server info: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Server info error: $error');
    }
  }

  /// 📊 Statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _sendRequest(() => http.get(
        Uri.parse('$_baseUrl/api/statistics'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Statistics error: $e');
    }
  }

  /// 🔄 Sync Guarantor
  static Future<Map<String, dynamic>> syncGuarantor(int guarantorId) async {
    try {
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/api/guarantor/$guarantorId/sync'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to sync guarantor: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Sync guarantor error: $error');
      rethrow;
    }
  }

  /// 🔄 Update Loan Status
  static Future<Map<String, dynamic>> updateLoanStatus(String loanId, String status) async {
    try {
      final response = await _sendRequest(() => http.put(
        Uri.parse('$_baseUrl/api/loan/$loanId/status'),
        headers: _headers,
        body: jsonEncode({'status': status}),
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update loan status: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Update loan status error: $error');
      rethrow;
    }
  }

  /// 🔄 Sync Operations
  static Future<Map<String, dynamic>> syncData() async {
    try {
      // Sync often takes longer, maybe use custom timeout here or just default retry?
      // For sync, retry might be dangerous if it's not idempotent.
      // But _sendRequest is general.
      // Let's use _sendRequest but maybe we should trust the user's intent.
      // If sync fails, it fails.
      // However, for "premium feeling", retry is good for spotty connection.
      // Assuming sync is idempotent or safe to retry if failed (usually is).
      final response = await _sendRequest(() => http.post(
        Uri.parse('$_baseUrl/api/sync'),
        headers: _headers,
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to sync data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sync error: $e');
    }
  }

  /// 📝 Change Password
  static Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/change-password'),
        headers: _headers,
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Change password error: $e');
    }
  }

  /// 📱 Push Notifications (Future Feature)
  static Future<void> registerDevice(String token) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/api/register-device'),
        headers: _headers,
        body: jsonEncode({
          'token': token,
          'platform': Platform.operatingSystem,
        }),
      ).timeout(_timeout);
    } catch (e) {
      debugPrint('Device registration error: $e');
    }
  }
}
