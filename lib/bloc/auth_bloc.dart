import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import '../services/api_service.dart';

// 🎯 Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

// 🎯 Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

// 👤 User Model
class User extends Equatable {
  final String id;
  final String username;
  final String? token;

  const User({
    required this.id,
    required this.username,
    this.token,
  });

  @override
  List<Object?> get props => [id, username, token];

  User copyWith({
    String? id,
    String? username,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      token: token ?? this.token,
    );
  }
}

// 🧠 Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      debugPrint('🔐 [AuthBloc] Login attempt: ${event.username}');
      final response = await ApiService.login(event.username, event.password);
      debugPrint('🔐 [AuthBloc] Login response keys: ${response.keys.toList()}');
      
      // 🔧 รองรับหลาย format ของ API response
      String userId = event.username;
      String username = event.username;
      String token = '';
      
      // ดึง token — รองรับทั้ง response['token'] และ response['access_token']
      if (response.containsKey('token')) {
        token = response['token']?.toString() ?? '';
      } else if (response.containsKey('access_token')) {
        token = response['access_token']?.toString() ?? '';
      }

      // ดึง user data — รองรับทั้ง response['user'] เป็น Map หรือไม่มี
      if (response.containsKey('user') && response['user'] is Map) {
        final userData = response['user'] as Map<String, dynamic>;
        userId = userData['id']?.toString() ?? event.username;
        username = (userData['username'] ?? userData['name'] ?? event.username).toString();
      } else {
        // ถ้าไม่มี user object ให้ดึงจาก root level
        if (response.containsKey('id')) {
          userId = response['id'].toString();
        }
        if (response.containsKey('username')) {
          username = response['username'].toString();
        } else if (response.containsKey('name')) {
          username = response['name'].toString();
        }
      }
      
      final user = User(
        id: userId,
        username: username,
        token: token,
      );
      
      // Store token in ApiService for subsequent requests
      if (token.isNotEmpty) {
        ApiService.setToken(token);
      }
      
      debugPrint('✅ [AuthBloc] Login success: $username');
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      debugPrint('❌ [AuthBloc] Login error: $e');
      
      String errorMessage = e.toString();
      
      // 🧹 ล้าง prefix "Exception: " ที่ซ้ำซ้อน
      errorMessage = errorMessage
          .replaceAll('Exception: Exception: ', '')
          .replaceAll('Exception: ', '');
      
      // 🎯 แปลง error เป็นข้อความที่ user เข้าใจ
      if (errorMessage.contains('401') || errorMessage.contains('ไม่ถูกต้อง')) {
        errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
      } else if (errorMessage.contains('SocketException') || 
                 errorMessage.contains('ClientException') ||
                 errorMessage.contains('เชื่อมต่อ')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ กรุณาตรวจสอบอินเทอร์เน็ต';
      } else if (errorMessage.contains('Timeout') || errorMessage.contains('หมดเวลา')) {
        errorMessage = 'หมดเวลาเชื่อมต่อ กรุณาลองใหม่อีกครั้ง';
      } else if (errorMessage.contains('500') || errorMessage.contains('Server Error')) {
        errorMessage = 'เซิร์ฟเวอร์มีปัญหา กรุณาลองใหม่ภายหลัง';
      }
      
      emit(AuthError(message: errorMessage));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Call API logout
      await ApiService.logout();
      
      // Clear any stored tokens/session
      ApiService.setToken(null);
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Force logout even if API fails
      ApiService.setToken(null);
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Check for stored session/token
      // For now, we'll just emit unauthenticated
      // In a real app, you'd check secure storage
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}
