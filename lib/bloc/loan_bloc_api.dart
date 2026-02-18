import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

/// 📊 Loan BLoC สำหรับเชื่อมต่อกับ API จริง
/// แทนที่ LoanBloc ตัวเดิมที่ใช้ Mock Data
abstract class LoanApiEvent {}

class LoadDashboardData extends LoanApiEvent {}

class LoadLoanApplication extends LoanApiEvent {
  final String loanId;
  
  LoadLoanApplication(this.loanId);
}

class SaveLoanStep extends LoanApiEvent {
  final int step;
  final Map<String, dynamic> data;
  
  SaveLoanStep({required this.step, required this.data});
}

class SearchLoans extends LoanApiEvent {
  final String query;
  
  SearchLoans(this.query);
}

class CreateNewLoan extends LoanApiEvent {}

class UpdateLoanStatus extends LoanApiEvent {
  final String loanId;
  final String status;
  
  UpdateLoanStatus({required this.loanId, required this.status});
}

class GetStatistics extends LoanApiEvent {}

abstract class LoanApiState {}

class LoanApiInitial extends LoanApiState {}

class LoanApiLoading extends LoanApiState {}

class DashboardDataLoaded extends LoanApiState {
  final Map<String, dynamic> dashboardData;
  
  DashboardDataLoaded(this.dashboardData);
}

class LoanApplicationLoaded extends LoanApiState {
  final Map<String, dynamic> loanData;
  
  LoanApplicationLoaded(this.loanData);
}

class LoanStepSaved extends LoanApiState {
  final Map<String, dynamic> response;
  
  LoanStepSaved(this.response);
}

class LoansSearched extends LoanApiState {
  final List<Map<String, dynamic>> loans;
  
  LoansSearched(this.loans);
}

class LoanCreated extends LoanApiState {
  final Map<String, dynamic> loanData;
  
  LoanCreated(this.loanData);
}

class LoanStatusUpdated extends LoanApiState {
  final String message;
  
  LoanStatusUpdated(this.message);
}

class StatisticsLoaded extends LoanApiState {
  final Map<String, dynamic> statistics;
  
  StatisticsLoaded(this.statistics);
}

class LoanApiError extends LoanApiState {
  final String error;
  
  LoanApiError(this.error);
}

/// 🎯 Loan Model (API Version)
class LoanApplication {
  final String id;
  final String borrowerType;
  final String title;
  final String firstName;
  final String lastName;
  final String idCard;
  final String mobilePhone;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> stepData;
  
  LoanApplication({
    required this.id,
    required this.borrowerType,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.idCard,
    required this.mobilePhone,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.stepData,
  });
  
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['id']?.toString() ?? '',
      borrowerType: json['borrower_type'] ?? '',
      title: json['title'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      idCard: json['id_card'] ?? '',
      mobilePhone: json['mobile_phone'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'])
        : null,
      stepData: json['step_data'] ?? {},
    );
  }
  
  String get fullName => '$title $firstName $lastName';
  
  String get formattedStatus {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'รอดำเนินการ';
      case 'processing':
        return 'กำลังดำเนินการ';
      case 'approved':
        return 'อนุมัติ';
      case 'rejected':
        return 'ปฏิเสธ';
      case 'completed':
        return 'เสร็จสิ้น';
      default:
        return status;
    }
  }
}

/// 🎯 Loan API BLoC Implementation
class LoanApiBloc extends Bloc<LoanApiEvent, LoanApiState> {
  LoanApiBloc() : super(LoanApiInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<LoadLoanApplication>(_onLoadLoanApplication);
    on<SaveLoanStep>(_onSaveLoanStep);
    on<SearchLoans>(_onSearchLoans);
    on<CreateNewLoan>(_onCreateNewLoan);
    on<UpdateLoanStatus>(_onUpdateLoanStatus);
    on<GetStatistics>(_onGetStatistics);
  }

  Future<void> _onLoadDashboardData(LoadDashboardData event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      final dashboardData = await ApiService.getDashboardData();
      emit(DashboardDataLoaded(dashboardData));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการโหลดข้อมูล Dashboard';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      } else if (error.toString().contains('connection')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onLoadLoanApplication(LoadLoanApplication event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      final loanData = await ApiService.getLoanApplication(event.loanId);
      emit(LoanApplicationLoaded(loanData));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการโหลดข้อมูลคำขอสินเชื่อ';
      
      if (error.toString().contains('404')) {
        errorMessage = 'ไม่พบข้อมูลคำขอสินเชื่อ';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onSaveLoanStep(SaveLoanStep event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      Map<String, dynamic> response;
      
      switch (event.step) {
        case 1:
          response = await ApiService.saveStep1(event.data);
          break;
        case 2:
          response = await ApiService.saveStep2(event.data);
          break;
        case 3:
          response = await ApiService.saveStep3(event.data);
          break;
        case 4:
          response = await ApiService.saveStep4(event.data);
          break;
        case 5:
          response = await ApiService.saveStep5(event.data);
          break;
        case 6:
          response = await ApiService.saveStep6(event.data);
          break;
        case 7:
          response = await ApiService.saveStep7(event.data);
          break;
        default:
          throw Exception('Invalid step: ${event.step}');
      }
      
      emit(LoanStepSaved(response));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการบันทึกข้อมูล Step ${event.step}';
      
      if (error.toString().contains('400')) {
        errorMessage = 'ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง';
      } else if (error.toString().contains('401')) {
        errorMessage = 'กรุณาเข้าสู่ระบบใหม่';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onSearchLoans(SearchLoans event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      final loans = await ApiService.searchLoans(event.query);
      emit(LoansSearched(loans));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการค้นหาคำขอสินเชื่อ';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onCreateNewLoan(CreateNewLoan event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      // Create new loan with initial data
      final initialData = {
        'status': 'draft',
        'created_at': DateTime.now().toIso8601String(),
        'step_data': {},
      };
      
      // This would be a new API endpoint
      final loanData = await ApiService.saveStep1(initialData);
      emit(LoanCreated(loanData));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการสร้างคำขอสินเชื่อใหม่';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onUpdateLoanStatus(UpdateLoanStatus event, Emitter<LoanApiState> emit) async {
    try {
      // This would be a new API endpoint
      final response = await ApiService.updateLoanStatus(event.loanId, event.status);
      emit(LoanStatusUpdated(response['message'] ?? 'อัปเดตสถานะสำเร็จแล้ว'));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการอัปเดตสถานะ';
      
      if (error.toString().contains('403')) {
        errorMessage = 'ไม่มีสิทธิ์ในการอัปเดตสถานะ';
      } else if (error.toString().contains('404')) {
        errorMessage = 'ไม่พบคำขอสินเชื่อ';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  Future<void> _onGetStatistics(GetStatistics event, Emitter<LoanApiState> emit) async {
    emit(LoanApiLoading());
    
    try {
      final statistics = await ApiService.getStatistics();
      emit(StatisticsLoaded(statistics));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการโหลดสถิติ';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(LoanApiError(errorMessage));
    }
  }

  /// 🔧 Utility Methods
  String formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted บาท';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year + 543}';
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'processing':
        return '#007BFF'; // Blue
      case 'approved':
        return '#28A745'; // Green
      case 'rejected':
        return '#DC3545'; // Red
      case 'completed':
        return '#6F42C1'; // Purple
      default:
        return '#6C757D'; // Gray
    }
  }
}
