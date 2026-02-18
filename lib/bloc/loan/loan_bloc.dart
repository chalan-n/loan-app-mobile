import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/loan_service.dart';

/// 📊 Loan BLoC สำหรับจัดการคำขอสินเชื่อ
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final LoanService _loanService;

  LoanBloc({required LoanService loanService}) 
      : _loanService = loanService,
        super(LoanInitial()) {
    on<LoadLoanApplications>(_onLoadLoanApplications);
    on<CreateLoanApplication>(_onCreateLoanApplication);
    on<UpdateLoanApplication>(_onUpdateLoanApplication);
    on<DeleteLoanApplication>(_onDeleteLoanApplication);
    on<SearchLoanApplications>(_onSearchLoanApplications);
  }

  /// 📋 โหลดคำขอสินเชื่อทั้งหมด
  Future<void> _onLoadLoanApplications(
    LoadLoanApplications event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    
    try {
      final applications = await _loanService.getLoanApplications();
      emit(LoanLoaded(applications: applications));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  /// ➕ สร้างคำขอสินเชื่อใหม่
  Future<void> _onCreateLoanApplication(
    CreateLoanApplication event,
    Emitter<LoanState> emit,
  ) async {
    try {
      emit(LoanLoading());
      
      final application = await _loanService.createLoanApplication(
        application: event.application,
      );
      
      // โหลดข้อมูลใหม่
      final applications = await _loanService.getLoanApplications();
      emit(LoanLoaded(applications: applications));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  /// ✏️ อัปเดตคำขอสินเชื่อ
  Future<void> _onUpdateLoanApplication(
    UpdateLoanApplication event,
    Emitter<LoanState> emit,
  ) async {
    try {
      emit(LoanLoading());
      
      await _loanService.updateLoanApplication(
        id: event.id,
        application: event.application,
      );
      
      // โหลดข้อมูลใหม่
      final applications = await _loanService.getLoanApplications();
      emit(LoanLoaded(applications: applications));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  /// 🗑️ ลบคำขอสินเชื่อ
  Future<void> _onDeleteLoanApplication(
    DeleteLoanApplication event,
    Emitter<LoanState> emit,
  ) async {
    try {
      emit(LoanLoading());
      
      final id = event.id;
      await _loanService.deleteLoanApplication(id);
      
      // โหลดข้อมูลใหม่
      final applications = await _loanService.getLoanApplications();
      emit(LoanLoaded(applications: applications));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }

  /// 🔍 ค้นหาคำขอสินเชื่อ
  Future<void> _onSearchLoanApplications(
    SearchLoanApplications event,
    Emitter<LoanState> emit,
  ) async {
    emit(LoanLoading());
    
    try {
      final applications = await _loanService.searchLoanApplications(
        query: event.query,
        status: event.status,
      );
      emit(LoanLoaded(applications: applications));
    } catch (e) {
      emit(LoanError(message: e.toString()));
    }
  }
}

/// 🎯 Loan Events
abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object?> get props => [];
}

class LoadLoanApplications extends LoanEvent {
  const LoadLoanApplications();
}

class CreateLoanApplication extends LoanEvent {
  final LoanApplication application;

  const CreateLoanApplication({required this.application});

  @override
  List<Object> get props => [application];
}

class UpdateLoanApplication extends LoanEvent {
  final int id;
  final LoanApplication application;

  const UpdateLoanApplication({
    required this.id,
    required this.application,
  });

  @override
  List<Object> get props => [id, application];
}

class DeleteLoanApplication extends LoanEvent {
  final int id;

  const DeleteLoanApplication({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchLoanApplications extends LoanEvent {
  final String? query;
  final String? status;

  const SearchLoanApplications({this.query, this.status});

  @override
  List<Object?> get props => [query, status];
}

/// 🎯 Loan States
abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object?> get props => [];
}

class LoanInitial extends LoanState {
  const LoanInitial();
}

class LoanLoading extends LoanState {
  const LoanLoading();
}

class LoanLoaded extends LoanState {
  final List<LoanApplication> applications;

  const LoanLoaded({required this.applications});

  @override
  List<Object> get props => [applications];
}

class LoanError extends LoanState {
  final String message;

  const LoanError({required this.message});

  @override
  List<Object> get props => [message];
}

/// 📋 Loan Application Model (พื้นฐาน)
class LoanApplication extends Equatable {
  final int? id;
  final String? refCode;
  final String? status;
  final String? submittedDate;
  final String? lastUpdateDate;
  final String? firstName;
  final String? lastName;
  final String? borrowerType;
  final String? gender;
  final String? idCard;
  final String? mobilePhone;
  final String? companyName;
  final String? occupation;
  final double? salary;
  final String? staffId;

  const LoanApplication({
    this.id,
    this.refCode,
    this.status,
    this.submittedDate,
    this.lastUpdateDate,
    this.firstName,
    this.lastName,
    this.borrowerType,
    this.gender,
    this.idCard,
    this.mobilePhone,
    this.companyName,
    this.occupation,
    this.salary,
    this.staffId,
  });

  /// 🏭 สร้างจาก JSON
  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['ID'],
      refCode: json['ref_code'],
      status: json['status'],
      submittedDate: json['submitted_date'],
      lastUpdateDate: json['last_update_date'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      borrowerType: json['borrower_type'],
      gender: json['gender'],
      idCard: json['id_card'],
      mobilePhone: json['mobile_phone'],
      companyName: json['company_name'],
      occupation: json['occupation'],
      salary: json['salary']?.toDouble(),
      staffId: json['staff_id'],
    );
  }

  /// 📝 แปลงเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ref_code': refCode,
      'status': status,
      'submitted_date': submittedDate,
      'last_update_date': lastUpdateDate,
      'first_name': firstName,
      'last_name': lastName,
      'borrower_type': borrowerType,
      'gender': gender,
      'id_card': idCard,
      'mobile_phone': mobilePhone,
      'company_name': companyName,
      'occupation': occupation,
      'salary': salary,
      'staff_id': staffId,
    };
  }

  /// 📋 คัดลอกพร้อมแก้ไข
  LoanApplication copyWith({
    int? id,
    String? refCode,
    String? status,
    String? submittedDate,
    String? lastUpdateDate,
    String? firstName,
    String? lastName,
    String? borrowerType,
    String? gender,
    String? idCard,
    String? mobilePhone,
    String? companyName,
    String? occupation,
    double? salary,
    String? staffId,
  }) {
    return LoanApplication(
      id: id ?? this.id,
      refCode: refCode ?? this.refCode,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      borrowerType: borrowerType ?? this.borrowerType,
      gender: gender ?? this.gender,
      idCard: idCard ?? this.idCard,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      companyName: companyName ?? this.companyName,
      occupation: occupation ?? this.occupation,
      salary: salary ?? this.salary,
      staffId: staffId ?? this.staffId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        refCode,
        status,
        submittedDate,
        lastUpdateDate,
        firstName,
        lastName,
        borrowerType,
        gender,
        idCard,
        mobilePhone,
        companyName,
        occupation,
        salary,
        staffId,
      ];
}
