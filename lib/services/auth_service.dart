import 'dart:convert';
import 'package:dio/dio.dart';
import '../bloc/auth/auth_bloc.dart';

/// 🔐 Auth Service สำหรับเชื่อมต่อกับระบบ Backend
class AuthService {
  final Dio _dio;
  static const String _baseUrl = 'http://localhost:3000'; // ปรับตาม Server จริง

  AuthService() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  /// 🔐 Login และรับ Token
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // TODO: แก้ไขตาม response format จริง
        return User(
          username: username,
          displayName: username,
          role: 'staff',
        );
      } else {
        throw Exception('Login failed: Invalid credentials');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
      } else {
        throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดที่ไม่คาดคิด: $e');
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    try {
      await _dio.get('/logout');
    } catch (e) {
      // ไม่ต้อง throw error สำหรับ logout
      print('Logout error: $e');
    }
  }

  /// 🔍 ตรวจสอบผู้ใช้ปัจจุบัน
  Future<User?> getCurrentUser() async {
    try {
      // TODO: Implement token validation
      // ชั่วคราว return null เพราะยังไม่มี token storage
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 🔄 ตรวจสอบสถานะ Token
  Future<bool> isTokenValid() async {
    try {
      // TODO: Implement token validation
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 🔄 รีเฟรช Token
  Future<String?> refreshToken() async {
    try {
      // TODO: Implement token refresh
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 🔐 ตรวจสอบสิทธิ์การเข้าถึง
  Future<bool> hasPermission(String permission) async {
    try {
      // TODO: Implement permission check
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 📊 ดึงข้อมูลผู้ใช้แบบละเอียด
  Future<User> getUserProfile() async {
    try {
      final response = await _dio.get('/api/user/profile');
      
      if (response.statusCode == 200) {
        final data = response.data;
        return User(
          username: data['username'] ?? '',
          displayName: data['display_name'],
          role: data['role'],
        );
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลผู้ใช้: $e');
    }
  }

  /// ✏️ อัปเดตข้อมูลผู้ใช้
  Future<User> updateUserProfile({
    String? displayName,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _dio.put(
        '/api/user/profile',
        data: {
          if (displayName != null) 'display_name': displayName,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return User(
          username: data['username'] ?? '',
          displayName: data['display_name'],
          role: data['role'],
        );
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('ไม่สามารถอัปเดตข้อมูลผู้ใช้: $e');
    }
  }

  /// 🔐 เปลี่ยนรหัสผ่าน
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('รหัสผ่านปัจจุบันไม่ถูกต้อง');
      } else if (e.response?.statusCode == 422) {
        throw Exception('รหัสผ่านใหม่ไม่ตรงตามเงื่อนไข');
      } else {
        throw Exception('ไม่สามารถเปลี่ยนรหัสผ่าน: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน: $e');
    }
  }

  /// 📱 ขอรีเซ็ตรหัสผ่าน
  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/api/password-reset',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to request password reset');
      }
    } catch (e) {
      throw Exception('ไม่สามารถขอรีเซ็ตรหัสผ่าน: $e');
    }
  }

  /// 🔍 ตรวจสอบว่า Username มีอยู่แล้วหรือไม่
  Future<bool> isUsernameTaken(String username) async {
    try {
      final response = await _dio.get(
        '/api/check-username',
        queryParameters: {'username': username},
      );

      if (response.statusCode == 200) {
        return response.data['taken'] ?? false;
      } else {
        return true; // ถ้าไม่แน่ใจ ให้ถือว่ามีอยู่แล้ว
      }
    } catch (e) {
      return true; // ถ้า error ให้ถือว่ามีอยู่แล้ว
    }
  }
}
