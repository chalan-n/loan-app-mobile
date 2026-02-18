import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

/// 👥 Guarantor BLoC สำหรับเชื่อมต่อกับ API จริง
/// แทนที่ GuarantorBloc ตัวเดิมที่ใช้ Mock Data
abstract class GuarantorApiEvent {}

class LoadGuarantors extends GuarantorApiEvent {
  final String loanId;
  
  LoadGuarantors(this.loanId);
}

class AddGuarantor extends GuarantorApiEvent {
  final Map<String, dynamic> guarantorData;
  
  AddGuarantor(this.guarantorData);
}

class UpdateGuarantor extends GuarantorApiEvent {
  final int guarantorId;
  final Map<String, dynamic> guarantorData;
  
  UpdateGuarantor(this.guarantorId, this.guarantorData);
}

class DeleteGuarantor extends GuarantorApiEvent {
  final int guarantorId;
  
  DeleteGuarantor(this.guarantorId);
}

class SearchGuarantors extends GuarantorApiEvent {
  final String query;
  
  SearchGuarantors(this.query);
}

class SyncGuarantor extends GuarantorApiEvent {
  final int guarantorId;
  
  SyncGuarantor(this.guarantorId);
}

abstract class GuarantorApiState {}

class GuarantorApiInitial extends GuarantorApiState {}

class GuarantorApiLoading extends GuarantorApiState {}

class GuarantorApiLoaded extends GuarantorApiState {
  final List<Guarantor> guarantors;
  
  GuarantorApiLoaded(this.guarantors);
}

class GuarantorApiOperationSuccess extends GuarantorApiState {
  final String message;
  
  GuarantorApiOperationSuccess(this.message);
}

class GuarantorApiSynced extends GuarantorApiState {
  final int guarantorId;
  final String syncStatus;
  
  GuarantorApiSynced({required this.guarantorId, required this.syncStatus});
}

class GuarantorApiError extends GuarantorApiState {
  final String error;
  
  GuarantorApiError(this.error);
}

/// 🎯 Guarantor Model (API Version)
class Guarantor {
  final int id;
  final int loanId;
  final String guarantorType;
  final String? tradeRegistrationId;
  final String? registrationDate;
  final String? taxId;
  final String title;
  final String firstName;
  final String lastName;
  final String? gender;
  final String idCard;
  final String? idCardIssueDate;
  final String? idCardExpiryDate;
  final String? dateOfBirth;
  final String? ethnicity;
  final String? nationality;
  final String? religion;
  final String? maritalStatus;
  final String mobilePhone;
  final String? houseRegNo;
  final String? houseRegBuilding;
  final String? houseRegFloor;
  final String? houseRegRoom;
  final String? houseRegMoo;
  final String? houseRegSoi;
  final String? houseRegRoad;
  final String? houseRegProvince;
  final String? houseRegDistrict;
  final String? houseRegSubdistrict;
  final String? houseRegZipcode;
  final bool? sameAsHouseReg;
  final String? currentNo;
  final String? currentBuilding;
  final String? currentFloor;
  final String? currentRoom;
  final String? currentMoo;
  final String? currentSoi;
  final String? currentRoad;
  final String? currentProvince;
  final String? currentDistrict;
  final String? currentSubdistrict;
  final String? currentZipcode;
  final String? companyName;
  final String? occupation;
  final String? position;
  final double? salary;
  final double? otherIncome;
  final String? incomeSource;
  final String? workPhone;
  final String? workNo;
  final String? workBuilding;
  final String? workFloor;
  final String? workRoom;
  final String? workMoo;
  final String? workSoi;
  final String? workRoad;
  final String? workProvince;
  final String? workDistrict;
  final String? workSubdistrict;
  final String? workZipcode;
  final String? otherCardType;
  final String? otherCardNumber;
  final String? otherCardIssueDate;
  final String? otherCardExpiryDate;
  final String? docDeliveryType;
  final String? docNo;
  final String? docBuilding;
  final String? docFloor;
  final String? docRoom;
  final String? docMoo;
  final String? docSoi;
  final String? docRoad;
  final String? docProvince;
  final String? docDistrict;
  final String? docSubdistrict;
  final String? docZipcode;
  final String? syncStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;

  Guarantor({
    required this.id,
    required this.loanId,
    required this.guarantorType,
    this.tradeRegistrationId,
    this.registrationDate,
    this.taxId,
    required this.title,
    required this.firstName,
    required this.lastName,
    this.gender,
    required this.idCard,
    this.idCardIssueDate,
    this.idCardExpiryDate,
    this.dateOfBirth,
    this.ethnicity,
    this.nationality,
    this.religion,
    this.maritalStatus,
    required this.mobilePhone,
    this.houseRegNo,
    this.houseRegBuilding,
    this.houseRegFloor,
    this.houseRegRoom,
    this.houseRegMoo,
    this.houseRegSoi,
    this.houseRegRoad,
    this.houseRegProvince,
    this.houseRegDistrict,
    this.houseRegSubdistrict,
    this.houseRegZipcode,
    this.sameAsHouseReg,
    this.currentNo,
    this.currentBuilding,
    this.currentFloor,
    this.currentRoom,
    this.currentMoo,
    this.currentSoi,
    this.currentRoad,
    this.currentProvince,
    this.currentDistrict,
    this.currentSubdistrict,
    this.currentZipcode,
    this.companyName,
    this.occupation,
    this.position,
    this.salary,
    this.otherIncome,
    this.incomeSource,
    this.workPhone,
    this.workNo,
    this.workBuilding,
    this.workFloor,
    this.workRoom,
    this.workMoo,
    this.workSoi,
    this.workRoad,
    this.workProvince,
    this.workDistrict,
    this.workSubdistrict,
    this.workZipcode,
    this.otherCardType,
    this.otherCardNumber,
    this.otherCardIssueDate,
    this.otherCardExpiryDate,
    this.docDeliveryType,
    this.docNo,
    this.docBuilding,
    this.docFloor,
    this.docRoom,
    this.docMoo,
    this.docSoi,
    this.docRoad,
    this.docProvince,
    this.docDistrict,
    this.docSubdistrict,
    this.docZipcode,
    this.syncStatus,
    required this.createdAt,
    this.updatedAt,
    this.syncedAt,
  });

  factory Guarantor.fromJson(Map<String, dynamic> json) {
    return Guarantor(
      id: json['id'] as int? ?? 0,
      loanId: json['loan_id'] as int? ?? 0,
      guarantorType: json['guarantor_type'] as String? ?? '',
      tradeRegistrationId: json['trade_registration_id'] as String?,
      registrationDate: json['registration_date'] as String?,
      taxId: json['tax_id'] as String?,
      title: json['title'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      gender: json['gender'] as String?,
      idCard: json['id_card'] as String? ?? '',
      idCardIssueDate: json['id_card_issue_date'] as String?,
      idCardExpiryDate: json['id_card_expiry_date'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      ethnicity: json['ethnicity'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
      maritalStatus: json['marital_status'] as String?,
      mobilePhone: json['mobile_phone'] as String? ?? '',
      houseRegNo: json['house_reg_no'] as String?,
      houseRegBuilding: json['house_reg_building'] as String?,
      houseRegFloor: json['house_reg_floor'] as String?,
      houseRegRoom: json['house_reg_room'] as String?,
      houseRegMoo: json['house_reg_moo'] as String?,
      houseRegSoi: json['house_reg_soi'] as String?,
      houseRegRoad: json['house_reg_road'] as String?,
      houseRegProvince: json['house_reg_province'] as String?,
      houseRegDistrict: json['house_reg_district'] as String?,
      houseRegSubdistrict: json['house_reg_subdistrict'] as String?,
      houseRegZipcode: json['house_reg_zipcode'] as String?,
      sameAsHouseReg: json['same_as_house_reg'] as bool?,
      currentNo: json['current_no'] as String?,
      currentBuilding: json['current_building'] as String?,
      currentFloor: json['current_floor'] as String?,
      currentRoom: json['current_room'] as String?,
      currentMoo: json['current_moo'] as String?,
      currentSoi: json['current_soi'] as String?,
      currentRoad: json['current_road'] as String?,
      currentProvince: json['current_province'] as String?,
      currentDistrict: json['current_district'] as String?,
      currentSubdistrict: json['current_subdistrict'] as String?,
      currentZipcode: json['current_zipcode'] as String?,
      companyName: json['company_name'] as String?,
      occupation: json['occupation'] as String?,
      position: json['position'] as String?,
      salary: (json['salary'] as num?)?.toDouble(),
      otherIncome: (json['other_income'] as num?)?.toDouble(),
      incomeSource: json['income_source'] as String?,
      workPhone: json['work_phone'] as String?,
      workNo: json['work_no'] as String?,
      workBuilding: json['work_building'] as String?,
      workFloor: json['work_floor'] as String?,
      workRoom: json['work_room'] as String?,
      workMoo: json['work_moo'] as String?,
      workSoi: json['work_soi'] as String?,
      workRoad: json['work_road'] as String?,
      workProvince: json['work_province'] as String?,
      workDistrict: json['work_district'] as String?,
      workSubdistrict: json['work_subdistrict'] as String?,
      workZipcode: json['work_zipcode'] as String?,
      otherCardType: json['other_card_type'] as String?,
      otherCardNumber: json['other_card_number'] as String?,
      otherCardIssueDate: json['other_card_issue_date'] as String?,
      otherCardExpiryDate: json['other_card_expiry_date'] as String?,
      docDeliveryType: json['doc_delivery_type'] as String?,
      docNo: json['doc_no'] as String?,
      docBuilding: json['doc_building'] as String?,
      docFloor: json['doc_floor'] as String?,
      docRoom: json['doc_room'] as String?,
      docMoo: json['doc_moo'] as String?,
      docSoi: json['doc_soi'] as String?,
      docRoad: json['doc_road'] as String?,
      docProvince: json['doc_province'] as String?,
      docDistrict: json['doc_district'] as String?,
      docSubdistrict: json['doc_subdistrict'] as String?,
      docZipcode: json['doc_zipcode'] as String?,
      syncStatus: json['sync_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'])
        : null,
      syncedAt: json['synced_at'] != null 
        ? DateTime.parse(json['synced_at'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_id': loanId,
      'guarantor_type': guarantorType,
      'trade_registration_id': tradeRegistrationId,
      'registration_date': registrationDate,
      'tax_id': taxId,
      'title': title,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'id_card': idCard,
      'id_card_issue_date': idCardIssueDate,
      'id_card_expiry_date': idCardExpiryDate,
      'date_of_birth': dateOfBirth,
      'ethnicity': ethnicity,
      'nationality': nationality,
      'religion': religion,
      'marital_status': maritalStatus,
      'mobile_phone': mobilePhone,
      'house_reg_no': houseRegNo,
      'house_reg_building': houseRegBuilding,
      'house_reg_floor': houseRegFloor,
      'house_reg_room': houseRegRoom,
      'house_reg_moo': houseRegMoo,
      'house_reg_soi': houseRegSoi,
      'house_reg_road': houseRegRoad,
      'house_reg_province': houseRegProvince,
      'house_reg_district': houseRegDistrict,
      'house_reg_subdistrict': houseRegSubdistrict,
      'house_reg_zipcode': houseRegZipcode,
      'same_as_house_reg': sameAsHouseReg,
      'current_no': currentNo,
      'current_building': currentBuilding,
      'current_floor': currentFloor,
      'current_room': currentRoom,
      'current_moo': currentMoo,
      'current_soi': currentSoi,
      'current_road': currentRoad,
      'current_province': currentProvince,
      'current_district': currentDistrict,
      'current_subdistrict': currentSubdistrict,
      'current_zipcode': currentZipcode,
      'company_name': companyName,
      'occupation': occupation,
      'position': position,
      'salary': salary,
      'other_income': otherIncome,
      'income_source': incomeSource,
      'work_phone': workPhone,
      'work_no': workNo,
      'work_building': workBuilding,
      'work_floor': workFloor,
      'work_room': workRoom,
      'work_moo': workMoo,
      'work_soi': workSoi,
      'work_road': workRoad,
      'work_province': workProvince,
      'work_district': workDistrict,
      'work_subdistrict': workSubdistrict,
      'work_zipcode': workZipcode,
      'other_card_type': otherCardType,
      'other_card_number': otherCardNumber,
      'other_card_issue_date': otherCardIssueDate,
      'other_card_expiry_date': otherCardExpiryDate,
      'doc_delivery_type': docDeliveryType,
      'doc_no': docNo,
      'doc_building': docBuilding,
      'doc_floor': docFloor,
      'doc_room': docRoom,
      'doc_moo': docMoo,
      'doc_soi': docSoi,
      'doc_road': docRoad,
      'doc_province': docProvince,
      'doc_district': docDistrict,
      'doc_subdistrict': docSubdistrict,
      'doc_zipcode': docZipcode,
      'sync_status': syncStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
    };
  }

  String get fullName => '$title $firstName $lastName';
  
  String get formattedAddress {
    final parts = <String>[];
    if (houseRegNo?.isNotEmpty == true) parts.add('เลขที่ $houseRegNo');
    if (houseRegMoo?.isNotEmpty == true) parts.add('หมู่ที่ $houseRegMoo');
    if (houseRegRoad?.isNotEmpty == true) parts.add('ถนน$houseRegRoad');
    if (houseRegDistrict?.isNotEmpty == true) parts.add('เขต$houseRegDistrict');
    if (houseRegProvince?.isNotEmpty == true) parts.add('จังหวัด$houseRegProvince');
    if (houseRegZipcode?.isNotEmpty == true) parts.add(houseRegZipcode!);
    return parts.join(' ');
  }
  
  double get totalIncome => (salary ?? 0) + (otherIncome ?? 0);
  
  String get formattedSyncStatus {
    switch (syncStatus?.toLowerCase()) {
      case 'synced':
        return 'Synced';
      case 'pending':
        return 'Pending';
      case 'error':
        return 'Error';
      case 'syncing':
        return 'Syncing';
      default:
        return 'Unknown';
    }
  }
  
  bool get isSynced => syncStatus?.toLowerCase() == 'synced';
  bool get isPending => syncStatus?.toLowerCase() == 'pending';
  bool get hasError => syncStatus?.toLowerCase() == 'error';
  bool get isSyncing => syncStatus?.toLowerCase() == 'syncing';
}

/// 🎯 Guarantor API BLoC Implementation
class GuarantorApiBloc extends Bloc<GuarantorApiEvent, GuarantorApiState> {
  GuarantorApiBloc() : super(GuarantorApiInitial()) {
    on<LoadGuarantors>(_onLoadGuarantors);
    on<AddGuarantor>(_onAddGuarantor);
    on<UpdateGuarantor>(_onUpdateGuarantor);
    on<DeleteGuarantor>(_onDeleteGuarantor);
    on<SearchGuarantors>(_onSearchGuarantors);
    on<SyncGuarantor>(_onSyncGuarantor);
  }

  Future<void> _onLoadGuarantors(LoadGuarantors event, Emitter<GuarantorApiState> emit) async {
    emit(GuarantorApiLoading());
    
    try {
      final guarantorsData = await ApiService.getGuarantors(event.loanId);
      final guarantors = guarantorsData.map((data) => Guarantor.fromJson(data)).toList();
      emit(GuarantorApiLoaded(guarantors));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการโหลดข้อมูลผู้ค้ำประกัน';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      } else if (error.toString().contains('connection')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้';
      }
      
      emit(GuarantorApiError(errorMessage));
    }
  }

  Future<void> _onAddGuarantor(AddGuarantor event, Emitter<GuarantorApiState> emit) async {
    emit(GuarantorApiLoading());
    
    try {
      final response = await ApiService.addGuarantor(event.guarantorData);
      emit(GuarantorApiOperationSuccess(response['message'] ?? 'เพิ่มผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors list
      final loanId = event.guarantorData['loan_id']?.toString() ?? '0';
      add(LoadGuarantors(loanId));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการเพิ่มผู้ค้ำประกัน';
      
      if (error.toString().contains('400')) {
        errorMessage = 'ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง';
      } else if (error.toString().contains('401')) {
        errorMessage = 'กรุณาเข้าสู่ระบบใหม่';
      } else if (error.toString().contains('409')) {
        errorMessage = 'ผู้ค้ำประกันนี้มีอยู่ในระบบแล้ว';
      }
      
      emit(GuarantorApiError(errorMessage));
    }
  }

  Future<void> _onUpdateGuarantor(UpdateGuarantor event, Emitter<GuarantorApiState> emit) async {
    emit(GuarantorApiLoading());
    
    try {
      final response = await ApiService.updateGuarantor(event.guarantorId, event.guarantorData);
      emit(GuarantorApiOperationSuccess(response['message'] ?? 'แก้ไขข้อมูลผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors list
      add(LoadGuarantors('0')); // TODO: ใช้ loanId ที่ถูกต้อง
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการแก้ไขข้อมูลผู้ค้ำประกัน';
      
      if (error.toString().contains('400')) {
        errorMessage = 'ข้อมูลไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง';
      } else if (error.toString().contains('404')) {
        errorMessage = 'ไม่พบข้อมูลผู้ค้ำประกัน';
      } else if (error.toString().contains('403')) {
        errorMessage = 'ไม่มีสิทธิ์ในการแก้ไขข้อมูล';
      }
      
      emit(GuarantorApiError(errorMessage));
    }
  }

  Future<void> _onDeleteGuarantor(DeleteGuarantor event, Emitter<GuarantorApiState> emit) async {
    emit(GuarantorApiLoading());
    
    try {
      await ApiService.deleteGuarantor(event.guarantorId);
      emit(GuarantorApiOperationSuccess('ลบผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors list
      add(LoadGuarantors('0')); // TODO: ใช้ loanId ที่ถูกต้อง
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการลบผู้ค้ำประกัน';
      
      if (error.toString().contains('404')) {
        errorMessage = 'ไม่พบข้อมูลผู้ค้ำประกัน';
      } else if (error.toString().contains('403')) {
        errorMessage = 'ไม่มีสิทธิ์ในการลบข้อมูล';
      } else if (error.toString().contains('409')) {
        errorMessage = 'ไม่สามารถลบผู้ค้ำประกันที่ถูกใช้งานอยู่ได้';
      }
      
      emit(GuarantorApiError(errorMessage));
    }
  }

  Future<void> _onSearchGuarantors(SearchGuarantors event, Emitter<GuarantorApiState> emit) async {
    emit(GuarantorApiLoading());
    
    try {
      final guarantorsData = await ApiService.searchGuarantors(event.query);
      final guarantors = guarantorsData.map((data) => Guarantor.fromJson(data)).toList();
      emit(GuarantorApiLoaded(guarantors));
    } catch (error) {
      String errorMessage = 'เกิดข้อผิดพลาดในการค้นหาผู้ค้ำประกัน';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
      }
      
      emit(GuarantorApiError(errorMessage));
    }
  }

  Future<void> _onSyncGuarantor(SyncGuarantor event, Emitter<GuarantorApiState> emit) async {
    try {
      // Update sync status to 'syncing'
      emit(GuarantorApiSynced(guarantorId: event.guarantorId, syncStatus: 'syncing'));
      
      // Call sync API (this would be a new endpoint)
      final response = await ApiService.syncGuarantor(event.guarantorId);
      
      // Update sync status based on response
      final syncStatus = response['sync_status'] ?? 'synced';
      emit(GuarantorApiSynced(guarantorId: event.guarantorId, syncStatus: syncStatus));
      
      // Reload guarantors list to show updated status
      add(LoadGuarantors('0')); // TODO: ใช้ loanId ที่ถูกต้อง
    } catch (error) {
      // Update sync status to 'error'
      emit(GuarantorApiSynced(guarantorId: event.guarantorId, syncStatus: 'error'));
      
      String errorMessage = 'เกิดข้อผิดพลาดในการ Sync ข้อมูล';
      
      if (error.toString().contains('timeout')) {
        errorMessage = 'การ Sync หมดเวลา กรุณาลองใหม่';
      }
      
      emit(GuarantorApiError(errorMessage));
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

  String getSyncStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'synced':
        return '#28A745'; // Green
      case 'pending':
        return '#FFA500'; // Orange
      case 'error':
        return '#DC3545'; // Red
      case 'syncing':
        return '#007BFF'; // Blue
      default:
        return '#6C757D'; // Gray
    }
  }
}
