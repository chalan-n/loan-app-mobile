import 'dart:convert';
import 'package:dio/dio.dart';
import '../bloc/loan/loan_bloc.dart';

/// 📊 Loan Service สำหรับจัดการคำขอสินเชื่อ
class LoanService {
  final Dio _dio;
  static const String _baseUrl = 'http://localhost:3000'; // ปรับตาม Server จริง

  LoanService() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  /// 📋 ดึงรายการคำขอสินเชื่อทั้งหมด
  Future<List<LoanApplication>> getLoanApplications() async {
    try {
      final response = await _dio.get('/api/applications');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LoanApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load loan applications');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
      } else {
        throw Exception('เกิดข้อผิดพลาด: ${e.message}');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลคำขอสินเชื่อ: $e');
    }
  }

  /// 📋 ดึงคำขอสินเชื่อตาม ID
  Future<LoanApplication> getLoanApplicationById(int id) async {
    try {
      final response = await _dio.get('/api/applications/$id');
      
      if (response.statusCode == 200) {
        return LoanApplication.fromJson(response.data);
      } else {
        throw Exception('Failed to load loan application');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลคำขอสินเชื่อ: $e');
    }
  }

  /// ➕ สร้างคำขอสินเชื่อใหม่
  Future<LoanApplication> createLoanApplication({
    required LoanApplication application,
  }) async {
    try {
      final response = await _dio.post(
        '/api/applications',
        data: application.toJson(),
      );
      
      if (response.statusCode == 201) {
        return LoanApplication.fromJson(response.data);
      } else {
        throw Exception('Failed to create loan application');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง');
      } else {
        throw Exception('ไม่สามารถสร้างคำขอสินเชื่อ: ${e.message}');
      }
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการสร้างคำขอ: $e');
    }
  }

  /// ✏️ อัปเดตคำขอสินเชื่อ
  Future<LoanApplication> updateLoanApplication({
    required int id,
    required LoanApplication application,
  }) async {
    try {
      final response = await _dio.put(
        '/api/applications/$id',
        data: application.toJson(),
      );
      
      if (response.statusCode == 200) {
        return LoanApplication.fromJson(response.data);
      } else {
        throw Exception('Failed to update loan application');
      }
    } catch (e) {
      throw Exception('ไม่สามารถอัปเดตคำขอสินเชื่อ: $e');
    }
  }

  /// 🗑️ ลบคำขอสินเชื่อ
  Future<void> deleteLoanApplication(int id) async {
    try {
      final response = await _dio.delete('/api/applications/$id');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete loan application');
      }
    } catch (e) {
      throw Exception('ไม่สามารถลบคำขอสินเชื่อ: $e');
    }
  }

  /// 🔍 ค้นหาคำขอสินเชื่อ
  Future<List<LoanApplication>> searchLoanApplications({
    String? query,
    String? status,
    String? borrowerType,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (borrowerType != null && borrowerType.isNotEmpty) {
        queryParams['borrower_type'] = borrowerType;
      }
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/api/applications/search',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => LoanApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search loan applications');
      }
    } catch (e) {
      throw Exception('ไม่สามารถค้นหาคำขอสินเชื่อ: $e');
    }
  }

  /// 📊 ดึงสถิติคำขอสินเชื่อ
  Future<Map<String, dynamic>> getLoanStatistics() async {
    try {
      final response = await _dio.get('/api/applications/statistics');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load loan statistics');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลสถิติ: $e');
    }
  }

  /// 📋 ดึงคำขอสินเชื่อตามผู้ใช้
  Future<List<LoanApplication>> getLoanApplicationsByUser(String staffId) async {
    try {
      final response = await _dio.get(
        '/api/applications/user/$staffId',
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LoanApplication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user loan applications');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลคำขอสินเชื่อของผู้ใช้: $e');
    }
  }

  /// 🔄 อัปเดตสถานะคำขอสินเชื่อ
  Future<LoanApplication> updateApplicationStatus({
    required int id,
    required String status,
    String? remark,
  }) async {
    try {
      final response = await _dio.patch(
        '/api/applications/$id/status',
        data: {
          'status': status,
          if (remark != null) 'remark': remark,
        },
      );
      
      if (response.statusCode == 200) {
        return LoanApplication.fromJson(response.data);
      } else {
        throw Exception('Failed to update application status');
      }
    } catch (e) {
      throw Exception('ไม่สามารถอัปเดตสถานะคำขอ: $e');
    }
  }

  /// 📤 ส่งคำขอสินเชื่อ (Submit)
  Future<LoanApplication> submitApplication(int id) async {
    try {
      final response = await _dio.post('/api/applications/$id/submit');
      
      if (response.statusCode == 200) {
        return LoanApplication.fromJson(response.data);
      } else {
        throw Exception('Failed to submit application');
      }
    } catch (e) {
      throw Exception('ไม่สามารถส่งคำขอสินเชื่อ: $e');
    }
  }

  /// 📄 ส่งออกข้อมูลคำขอสินเชื่อ
  Future<String> exportApplications({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String format = 'csv', // csv, excel, pdf
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'format': format,
      };
      
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/api/applications/export',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        return response.data['download_url'] ?? '';
      } else {
        throw Exception('Failed to export applications');
      }
    } catch (e) {
      throw Exception('ไม่สามารถส่งออกข้อมูล: $e');
    }
  }

  /// 📊 ดึงข้อมูล Dropdown/Reference
  Future<Map<String, List<Map<String, dynamic>>>> getReferenceData() async {
    try {
      final response = await _dio.get('/api/reference-data');
      
      if (response.statusCode == 200) {
        return Map<String, List<Map<String, dynamic>>>.from(
          response.data,
        );
      } else {
        throw Exception('Failed to load reference data');
      }
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลอ้างอิง: $e');
    }
  }

  /// 🔍 ตรวจสอบ Ref Code ซ้ำ
  Future<bool> isRefCodeExists(String refCode) async {
    try {
      final response = await _dio.get(
        '/api/check-refcode',
        queryParameters: {'ref_code': refCode},
      );
      
      if (response.statusCode == 200) {
        return response.data['exists'] ?? false;
      } else {
        return true; // ถ้าไม่แน่ใจ ให้ถือว่ามีอยู่แล้ว
      }
    } catch (e) {
      return true; // ถ้า error ให้ถือว่ามีอยู่แล้ว
    }
  }
}
