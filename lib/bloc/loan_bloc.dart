import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

// 🎯 Loan Events
abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends LoanEvent {
  const LoadDashboardData();
}

class LoadLoanApplications extends LoanEvent {
  final String? status;

  const LoadLoanApplications({this.status});
}

class CreateLoanApplication extends LoanEvent {
  final Map<String, dynamic> applicationData;

  const CreateLoanApplication({required this.applicationData});

  @override
  List<Object> get props => [applicationData];
}

class UpdateLoanStatus extends LoanEvent {
  final String refCode;
  final String status;

  const UpdateLoanStatus({
    required this.refCode,
    required this.status,
  });

  @override
  List<Object> get props => [refCode, status];
}

class SearchLoanApplications extends LoanEvent {
  final String query;

  const SearchLoanApplications({required this.query});

  @override
  List<Object> get props => [query];
}

// 🎯 Loan States
abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object> get props => [];
}

class LoanInitial extends LoanState {
  const LoanInitial();
}

class LoanLoading extends LoanState {
  const LoanLoading();
}

class LoanLoaded extends LoanState {
  final List<LoanApplication> applications;
  final int? totalApplications;
  final int? approvedApplications;
  final int? pendingApplications;
  final int? rejectedApplications;
  final List<LoanApplication>? recentApplications;

  const LoanLoaded({
    required this.applications,
    this.totalApplications,
    this.approvedApplications,
    this.pendingApplications,
    this.rejectedApplications,
    this.recentApplications,
  });

  @override
  List<Object> get props => [
    applications,
    totalApplications ?? 0,
    approvedApplications ?? 0,
    pendingApplications ?? 0,
    rejectedApplications ?? 0,
    recentApplications ?? [],
  ];

  LoanLoaded copyWith({
    List<LoanApplication>? applications,
    int? totalApplications,
    int? approvedApplications,
    int? pendingApplications,
    int? rejectedApplications,
    List<LoanApplication>? recentApplications,
  }) {
    return LoanLoaded(
      applications: applications ?? this.applications,
      totalApplications: totalApplications ?? this.totalApplications,
      approvedApplications: approvedApplications ?? this.approvedApplications,
      pendingApplications: pendingApplications ?? this.pendingApplications,
      rejectedApplications: rejectedApplications ?? this.rejectedApplications,
      recentApplications: recentApplications ?? this.recentApplications,
    );
  }
}

class LoanError extends LoanState {
  final String message;

  const LoanError({required this.message});

  @override
  List<Object> get props => [message];
}

// 📋 Loan Application Model (สอดคล้องกับระบบเดิม)
class LoanApplication extends Equatable {
  final int id;
  final String refCode;
  final String status;
  final String? submittedDate;
  final String? lastUpdateDate;
  final String syncStatus;
  final String staffID;
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? borrowerType;
  final String? gender;
  final String? idCard;
  final String? mobilePhone;
  final String? companyName;
  final String? occupation;
  final double? salary;
  final double? otherIncome;
  // 🚗 Car Info fields
  final String? contractSignDate;
  final String? carBrand;
  final String? carModel;
  final String? carYear;
  final String? licensePlate;
  final String? licenseProvince;

  const LoanApplication({
    required this.id,
    required this.refCode,
    required this.status,
    this.submittedDate,
    this.lastUpdateDate,
    this.syncStatus = 'WAITING',
    this.staffID = '',
    this.title,
    this.firstName,
    this.lastName,
    this.borrowerType,
    this.gender,
    this.idCard,
    this.mobilePhone,
    this.companyName,
    this.occupation,
    this.salary,
    this.otherIncome,
    this.contractSignDate,
    this.carBrand,
    this.carModel,
    this.carYear,
    this.licensePlate,
    this.licenseProvince,
  });

  @override
  List<Object?> get props => [
    id,
    refCode,
    status,
    submittedDate,
    lastUpdateDate,
    syncStatus,
    staffID,
    title,
    firstName,
    lastName,
    borrowerType,
    gender,
    idCard,
    mobilePhone,
    companyName,
    occupation,
    salary,
    otherIncome,
    contractSignDate,
    carBrand,
    carModel,
    carYear,
    licensePlate,
    licenseProvince,
  ];

  // Mock data factory
  factory LoanApplication.mock() {
    return LoanApplication(
      id: 1,
      refCode: 'LOAN${DateTime.now().millisecondsSinceEpoch}',
      status: 'Draft',
      submittedDate: DateTime.now().toString().split(' ')[0],
      lastUpdateDate: DateTime.now().toString().split(' ')[0],
      syncStatus: 'WAITING',
      staffID: '570639',
      title: 'นาย',
      firstName: 'ทดสอบ',
      lastName: 'ระบบ',
      borrowerType: 'individual',
      gender: 'ชาย',
      idCard: '1234567890123',
      mobilePhone: '0812345678',
      companyName: 'บริษัท ทดสอบ จำกัด',
      occupation: 'พนักงาน',
      salary: 30000.0,
      otherIncome: 5000.0,
    );
  }

  LoanApplication copyWith({
    int? id,
    String? refCode,
    String? status,
    String? submittedDate,
    String? lastUpdateDate,
    String? syncStatus,
    String? staffID,
    String? title,
    String? firstName,
    String? lastName,
    String? borrowerType,
    String? gender,
    String? idCard,
    String? mobilePhone,
    String? companyName,
    String? occupation,
    double? salary,
    double? otherIncome,
    String? contractSignDate,
    String? carBrand,
    String? carModel,
    String? carYear,
    String? licensePlate,
    String? licenseProvince,
  }) {
    return LoanApplication(
      id: id ?? this.id,
      refCode: refCode ?? this.refCode,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      syncStatus: syncStatus ?? this.syncStatus,
      staffID: staffID ?? this.staffID,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      borrowerType: borrowerType ?? this.borrowerType,
      gender: gender ?? this.gender,
      idCard: idCard ?? this.idCard,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      companyName: companyName ?? this.companyName,
      occupation: occupation ?? this.occupation,
      salary: salary ?? this.salary,
      otherIncome: otherIncome ?? this.otherIncome,
      contractSignDate: contractSignDate ?? this.contractSignDate,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      carYear: carYear ?? this.carYear,
      licensePlate: licensePlate ?? this.licensePlate,
      licenseProvince: licenseProvince ?? this.licenseProvince,
    );
  }
}

// 🧠 Loan BLoC
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(const LoanInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<LoadLoanApplications>(_onLoadLoanApplications);
    on<CreateLoanApplication>(_onCreateLoanApplication);
    on<UpdateLoanStatus>(_onUpdateLoanStatus);
    on<SearchLoanApplications>(_onSearchLoanApplications);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    
    try {
      debugPrint('📊 [LoanBloc] Loading dashboard data from API...');
      
      // เรียก API จริง
      final loanListData = await ApiService.getLoanList();
      debugPrint('📊 [LoanBloc] Got ${loanListData.length} loans from API');
      
      // Parse เป็น LoanApplication objects
      final applications = _parseApplications(loanListData);
      
      // คำนวณสถิติ
      final totalApplications = applications.length;
      final approvedApplications = applications.where(
        (a) => a.status == 'A' || a.status == 'Approved'
      ).length;
      final pendingApplications = applications.where(
        (a) => a.status == 'P' || a.status == 'Pending'
      ).length;
      final rejectedApplications = applications.where(
        (a) => a.status == 'R' || a.status == 'Rejected'
      ).length;

      emit(LoanLoaded(
        applications: applications,
        totalApplications: totalApplications,
        approvedApplications: approvedApplications,
        pendingApplications: pendingApplications,
        rejectedApplications: rejectedApplications,
        recentApplications: applications.take(5).toList(),
      ));
    } catch (e) {
      debugPrint('❌ [LoanBloc] Dashboard error: $e');
      String errorMsg = e.toString();
      // ทำให้ error message อ่านง่าย
      if (errorMsg.contains('SocketException') || errorMsg.contains('Connection')) {
        errorMsg = 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่อ';
      } else if (errorMsg.contains('TimeoutException') || errorMsg.contains('timeout')) {
        errorMsg = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง';
      } else if (errorMsg.contains('401') || errorMsg.contains('403')) {
        errorMsg = 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่';
      } else {
        errorMsg = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
      }
      emit(LoanError(message: errorMsg));
    }
  }

  /// 📋 Parse API response → LoanApplication list
  List<LoanApplication> _parseApplications(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final map = entry.value;
      return LoanApplication(
        id: map['id'] ?? map['ID'] ?? index,
        refCode: (map['ref_code'] ?? map['refCode'] ?? map['loan_number'] ?? '').toString(),
        status: (map['status'] ?? map['Status'] ?? 'D').toString(),
        submittedDate: (map['submitted_date'] ?? map['submittedDate'] ?? map['submit_date'] ?? '').toString(),
        lastUpdateDate: (map['last_update_date'] ?? map['lastUpdateDate'] ?? map['updated_at'] ?? '').toString(),
        syncStatus: (map['sync_status'] ?? map['syncStatus'] ?? 'WAITING').toString(),
        staffID: (map['staff_id'] ?? map['staffID'] ?? map['staff_ID'] ?? '').toString(),
        title: (map['title'] ?? map['Title'] ?? '').toString(),
        firstName: (map['first_name'] ?? map['firstName'] ?? map['fname'] ?? '').toString(),
        lastName: (map['last_name'] ?? map['lastName'] ?? map['lname'] ?? '').toString(),
        borrowerType: (map['borrower_type'] ?? map['borrowerType'] ?? 'individual').toString(),
        gender: (map['gender'] ?? map['Gender'] ?? '').toString(),
        idCard: (map['id_card'] ?? map['idCard'] ?? map['citizen_id'] ?? '').toString(),
        mobilePhone: (map['mobile_phone'] ?? map['mobilePhone'] ?? map['phone'] ?? '').toString(),
        companyName: (map['company_name'] ?? map['companyName'] ?? '').toString(),
        occupation: (map['occupation'] ?? map['Occupation'] ?? '').toString(),
        salary: _parseDouble(map['salary']),
        otherIncome: _parseDouble(map['other_income'] ?? map['otherIncome']),
        contractSignDate: (map['contract_sign_date'] ?? map['contractSignDate'] ?? map['contract_date'] ?? '').toString(),
        carBrand: (map['car_brand'] ?? map['carBrand'] ?? map['brand'] ?? '').toString(),
        carModel: (map['car_model'] ?? map['carModel'] ?? map['model'] ?? '').toString(),
        carYear: (map['car_year'] ?? map['carYear'] ?? map['year'] ?? '').toString(),
        licensePlate: (map['license_plate'] ?? map['licensePlate'] ?? map['plate'] ?? '').toString(),
        licenseProvince: (map['license_province'] ?? map['licenseProvince'] ?? map['province'] ?? '').toString(),
      );
    }).toList();
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Future<void> _onLoadLoanApplications(
    LoadLoanApplications event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    
    try {
      final loanListData = await ApiService.getLoanList();
      final applications = _parseApplications(loanListData);
      
      // กรองตาม status (ถ้ามี)
      final filtered = event.status != null
        ? applications.where((a) => a.status == event.status).toList()
        : applications;

      emit(LoanLoaded(applications: filtered));
    } catch (e) {
      emit(LoanError(message: 'เกิดข้อผิดพลาดในการโหลดข้อมูล: ${e.toString()}'));
    }
  }

  Future<void> _onCreateLoanApplication(
    CreateLoanApplication event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock creating application
      final newApplication = LoanApplication.mock().copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
        refCode: 'LOAN${DateTime.now().millisecondsSinceEpoch}',
        firstName: event.applicationData['firstName'] ?? 'ทดสอบ',
        lastName: event.applicationData['lastName'] ?? 'ระบบ',
      );

      // Return to previous state with new application
      if (state is LoanLoaded) {
        final currentState = state as LoanLoaded;
        final updatedApplications = [newApplication, ...currentState.applications];
        
        emit(currentState.copyWith(applications: updatedApplications));
      } else {
        emit(LoanLoaded(applications: [newApplication]));
      }
    } catch (e) {
      emit(LoanError(message: 'เกิดข้อผิดพลาดในการสร้างคำขอ: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateLoanStatus(
    UpdateLoanStatus event,
    Emitter<LoanState> emit,
  ) async {
    if (state is! LoanLoaded) return;
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final currentState = state as LoanLoaded;
      final updatedApplications = currentState.applications.map((app) {
        if (app.refCode == event.refCode) {
          return app.copyWith(status: event.status);
        }
        return app;
      }).toList();

      emit(currentState.copyWith(applications: updatedApplications));
    } catch (e) {
      emit(LoanError(message: 'เกิดข้อผิดพลาดในการอัพเดตสถานะ: ${e.toString()}'));
    }
  }

  Future<void> _onSearchLoanApplications(
    SearchLoanApplications event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock search - in real app, this would call API
      final allApplications = List.generate(20, (index) => 
        LoanApplication.mock().copyWith(
          id: index + 1,
          refCode: 'LOAN${3000 + index}',
          firstName: event.query.isEmpty ? 'ผู้กู้${index + 1}' : event.query,
          lastName: 'ค้นหา',
        )
      );

      emit(LoanLoaded(applications: allApplications));
    } catch (e) {
      emit(LoanError(message: 'เกิดข้อผิดพลาดในการค้นหา: ${e.toString()}'));
    }
  }
}
