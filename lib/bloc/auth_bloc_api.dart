import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

/// 🔐 Auth BLoC สำหรับเชื่อมต่อกับ API จริง
/// แทนที่ AuthBloc ตัวเดิมที่ใช้ Mock Data
abstract class AuthApiEvent {}

class LoginRequested extends AuthApiEvent {
  final String username;
  final String password;
  
  LoginRequested({required this.username, required this.password});
}

class LogoutRequested extends AuthApiEvent {}

class CheckAuthStatus extends AuthApiEvent {}

class ChangePasswordRequested extends AuthApiEvent {
  final String oldPassword;
  final String newPassword;
  
  ChangePasswordRequested({required this.oldPassword, required this.newPassword});
}

abstract class AuthApiState {}

class AuthApiInitial extends AuthApiState {}

class AuthApiLoading extends AuthApiState {}

class AuthApiAuthenticated extends AuthApiState {
  final User user;
  final String token;
  
  AuthApiAuthenticated({required this.user, required this.token});
}

class AuthApiUnauthenticated extends AuthApiState {}

class AuthApiError extends AuthApiState {
  final String error;
  
  AuthApiError(this.error);
}

class PasswordChangeSuccess extends AuthApiState {
  final String message;
  
  PasswordChangeSuccess(this.message);
}

/// 🎯 User Model (API Version)
class User {
  final int id;
  final String username;
  final String? fullName;
  final String? role;
  final String? email;
  final String? phone;
  final DateTime? lastLogin;
  final bool isActive;
  
  User({
    required this.id,
    required this.username,
    this.fullName,
    this.role,
    this.email,
    this.phone,
    this.lastLogin,
    required this.isActive,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      lastLogin: json['last_login'] != null 
        ? DateTime.parse(json['last_login'])
        : null,
      isActive: json['is_active'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'role': role,
      'email': email,
      'phone': phone,
      'last_login': lastLogin?.toIso8601String(),
      'is_active': isActive,
    };
  }
}

/// 🎯 Auth API BLoC Implementation
class AuthApiBloc extends Bloc<AuthApiEvent, AuthApiState> {
  User? _currentUser;
  String? _token;
  
  AuthApiBloc() : super(AuthApiInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _currentUser != null && _token != null;

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthApiState> emit) async {
    emit(AuthApiLoading());
    
    try {
      final response = await ApiService.login(event.username, event.password);
      
      // Extract user data and token from response
      final userData = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String? ?? '';
      
      final user = User.fromJson(userData);
      
      _currentUser = user;
      _token = token;
      
      emit(AuthApiAuthenticated(user: user, token: token));
      
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      
      if (error.toString().contains('401')) {
        errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      } else if (error.toString().contains('connection')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้';
      }
      
      emit(AuthApiError(errorMessage));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthApiState> emit) async {
    try {
      await ApiService.logout();
    } catch (error) {
      // Continue with logout even if API call fails
      print('Logout API error: $error');
    }
    
    _currentUser = null;
    _token = null;
    
    emit(AuthApiUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthApiState> emit) async {
    if (_currentUser != null && _token != null) {
      emit(AuthApiAuthenticated(user: _currentUser!, token: _token!));
    } else {
      emit(AuthApiUnauthenticated());
    }
  }

  Future<void> _onChangePasswordRequested(ChangePasswordRequested event, Emitter<AuthApiState> emit) async {
    try {
      final response = await ApiService.changePassword(event.oldPassword, event.newPassword);
      
      emit(PasswordChangeSuccess(response['message'] ?? 'เปลี่ยนรหัสผ่านสำเร็จแล้ว'));
      
      // Return to authenticated state after success
      if (_currentUser != null && _token != null) {
        emit(AuthApiAuthenticated(user: _currentUser!, token: _token!));
      }
      
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน';
      
      if (error.toString().contains('400')) {
        errorMessage = 'รหัสผ่านเดิมไม่ถูกต้อง';
      } else if (error.toString().contains('401')) {
        errorMessage = 'กรุณาเข้าสู่ระบบใหม่';
        emit(AuthApiUnauthenticated());
        return;
      }
      
      emit(AuthApiError(errorMessage));
    }
  }

  /// 🔧 Utility Methods
  void clearAuth() {
    _currentUser = null;
    _token = null;
  }

  void setAuth(User user, String token) {
    _currentUser = user;
    _token = token;
  }
}
