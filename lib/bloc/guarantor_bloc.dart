import 'package:flutter_bloc/flutter_bloc.dart';

/// 🎯 Guarantor BLoC สำหรับจัดการสถานะและข้อมูลผู้ค้ำประกัน
/// รองรับการเพิ่ม, ลบ, แก้ไข และค้นหาผู้ค้ำประกัน
abstract class GuarantorEvent {}

class LoadGuarantors extends GuarantorEvent {
  final String loanId;
  
  LoadGuarantors(this.loanId);
}

class AddGuarantor extends GuarantorEvent {
  final Map<String, dynamic> guarantorData;
  
  AddGuarantor(this.guarantorData);
}

class UpdateGuarantor extends GuarantorEvent {
  final int guarantorId;
  final Map<String, dynamic> guarantorData;
  
  UpdateGuarantor(this.guarantorId, this.guarantorData);
}

class DeleteGuarantor extends GuarantorEvent {
  final int guarantorId;
  
  DeleteGuarantor(this.guarantorId);
}

class SearchGuarantors extends GuarantorEvent {
  final String query;
  
  SearchGuarantors(this.query);
}

abstract class GuarantorState {}

class GuarantorInitial extends GuarantorState {}

class GuarantorLoading extends GuarantorState {}

class GuarantorLoaded extends GuarantorState {
  final List<Map<String, dynamic>> guarantors;
  
  GuarantorLoaded(this.guarantors);
}

class GuarantorOperationSuccess extends GuarantorState {
  final String message;
  
  GuarantorOperationSuccess(this.message);
}

class GuarantorError extends GuarantorState {
  final String error;
  
  GuarantorError(this.error);
}

/// 🎯 Guarantor Model
class Guarantor {
  final int? id;
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

  Guarantor({
    this.id,
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
  });

  factory Guarantor.fromJson(Map<String, dynamic> json) {
    return Guarantor(
      id: json['id'] as int?,
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
    };
  }

  Guarantor copyWith({
    int? id,
    int? loanId,
    String? guarantorType,
    String? tradeRegistrationId,
    String? registrationDate,
    String? taxId,
    String? title,
    String? firstName,
    String? lastName,
    String? gender,
    String? idCard,
    String? idCardIssueDate,
    String? idCardExpiryDate,
    String? dateOfBirth,
    String? ethnicity,
    String? nationality,
    String? religion,
    String? maritalStatus,
    String? mobilePhone,
    String? houseRegNo,
    String? houseRegBuilding,
    String? houseRegFloor,
    String? houseRegRoom,
    String? houseRegMoo,
    String? houseRegSoi,
    String? houseRegRoad,
    String? houseRegProvince,
    String? houseRegDistrict,
    String? houseRegSubdistrict,
    String? houseRegZipcode,
    bool? sameAsHouseReg,
    String? currentNo,
    String? currentBuilding,
    String? currentFloor,
    String? currentRoom,
    String? currentMoo,
    String? currentSoi,
    String? currentRoad,
    String? currentProvince,
    String? currentDistrict,
    String? currentSubdistrict,
    String? currentZipcode,
    String? companyName,
    String? occupation,
    String? position,
    double? salary,
    double? otherIncome,
    String? incomeSource,
    String? workPhone,
    String? workNo,
    String? workBuilding,
    String? workFloor,
    String? workRoom,
    String? workMoo,
    String? workSoi,
    String? workRoad,
    String? workProvince,
    String? workDistrict,
    String? workSubdistrict,
    String? workZipcode,
    String? otherCardType,
    String? otherCardNumber,
    String? otherCardIssueDate,
    String? otherCardExpiryDate,
    String? docDeliveryType,
    String? docNo,
    String? docBuilding,
    String? docFloor,
    String? docRoom,
    String? docMoo,
    String? docSoi,
    String? docRoad,
    String? docProvince,
    String? docDistrict,
    String? docSubdistrict,
    String? docZipcode,
    String? syncStatus,
  }) {
    return Guarantor(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      guarantorType: guarantorType ?? this.guarantorType,
      tradeRegistrationId: tradeRegistrationId ?? this.tradeRegistrationId,
      registrationDate: registrationDate ?? this.registrationDate,
      taxId: taxId ?? this.taxId,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      idCard: idCard ?? this.idCard,
      idCardIssueDate: idCardIssueDate ?? this.idCardIssueDate,
      idCardExpiryDate: idCardExpiryDate ?? this.idCardExpiryDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      ethnicity: ethnicity ?? this.ethnicity,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      houseRegNo: houseRegNo ?? this.houseRegNo,
      houseRegBuilding: houseRegBuilding ?? this.houseRegBuilding,
      houseRegFloor: houseRegFloor ?? this.houseRegFloor,
      houseRegRoom: houseRegRoom ?? this.houseRegRoom,
      houseRegMoo: houseRegMoo ?? this.houseRegMoo,
      houseRegSoi: houseRegSoi ?? this.houseRegSoi,
      houseRegRoad: houseRegRoad ?? this.houseRegRoad,
      houseRegProvince: houseRegProvince ?? this.houseRegProvince,
      houseRegDistrict: houseRegDistrict ?? this.houseRegDistrict,
      houseRegSubdistrict: houseRegSubdistrict ?? this.houseRegSubdistrict,
      houseRegZipcode: houseRegZipcode ?? this.houseRegZipcode,
      sameAsHouseReg: sameAsHouseReg ?? this.sameAsHouseReg,
      currentNo: currentNo ?? this.currentNo,
      currentBuilding: currentBuilding ?? this.currentBuilding,
      currentFloor: currentFloor ?? this.currentFloor,
      currentRoom: currentRoom ?? this.currentRoom,
      currentMoo: currentMoo ?? this.currentMoo,
      currentSoi: currentSoi ?? this.currentSoi,
      currentRoad: currentRoad ?? this.currentRoad,
      currentProvince: currentProvince ?? this.currentProvince,
      currentDistrict: currentDistrict ?? this.currentDistrict,
      currentSubdistrict: currentSubdistrict ?? this.currentSubdistrict,
      currentZipcode: currentZipcode ?? this.currentZipcode,
      companyName: companyName ?? this.companyName,
      occupation: occupation ?? this.occupation,
      position: position ?? this.position,
      salary: salary ?? this.salary,
      otherIncome: otherIncome ?? this.otherIncome,
      incomeSource: incomeSource ?? this.incomeSource,
      workPhone: workPhone ?? this.workPhone,
      workNo: workNo ?? this.workNo,
      workBuilding: workBuilding ?? this.workBuilding,
      workFloor: workFloor ?? this.workFloor,
      workRoom: workRoom ?? this.workRoom,
      workMoo: workMoo ?? this.workMoo,
      workSoi: workSoi ?? this.workSoi,
      workRoad: workRoad ?? this.workRoad,
      workProvince: workProvince ?? this.workProvince,
      workDistrict: workDistrict ?? this.workDistrict,
      workSubdistrict: workSubdistrict ?? this.workSubdistrict,
      workZipcode: workZipcode ?? this.workZipcode,
      otherCardType: otherCardType ?? this.otherCardType,
      otherCardNumber: otherCardNumber ?? this.otherCardNumber,
      otherCardIssueDate: otherCardIssueDate ?? this.otherCardIssueDate,
      otherCardExpiryDate: otherCardExpiryDate ?? this.otherCardExpiryDate,
      docDeliveryType: docDeliveryType ?? this.docDeliveryType,
      docNo: docNo ?? this.docNo,
      docBuilding: docBuilding ?? this.docBuilding,
      docFloor: docFloor ?? this.docFloor,
      docRoom: docRoom ?? this.docRoom,
      docMoo: docMoo ?? this.docMoo,
      docSoi: docSoi ?? this.docSoi,
      docRoad: docRoad ?? this.docRoad,
      docProvince: docProvince ?? this.docProvince,
      docDistrict: docDistrict ?? this.docDistrict,
      docSubdistrict: docSubdistrict ?? this.docSubdistrict,
      docZipcode: docZipcode ?? this.docZipcode,
      syncStatus: syncStatus ?? this.syncStatus,
    );
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
}

/// 🎯 Guarantor BLoC Implementation
class GuarantorBloc extends Bloc<GuarantorEvent, GuarantorState> {
  GuarantorBloc() : super(GuarantorInitial()) {
    on<LoadGuarantors>(_onLoadGuarantors);
    on<AddGuarantor>(_onAddGuarantor);
    on<UpdateGuarantor>(_onUpdateGuarantor);
    on<DeleteGuarantor>(_onDeleteGuarantor);
    on<SearchGuarantors>(_onSearchGuarantors);
  }

  Future<void> _onLoadGuarantors(LoadGuarantors event, Emitter<GuarantorState> emit) async {
    emit(GuarantorLoading());
    
    try {
      // TODO: เชื่อมต่อกับ API จริง
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data สำหรับทดสอบ
      final mockGuarantors = [
        {
          'id': 1,
          'loan_id': int.parse(event.loanId),
          'guarantor_type': 'individual',
          'title': 'นาย',
          'first_name': 'สมชาย',
          'last_name': 'ใจดี',
          'id_card': '1234567890123',
          'mobile_phone': '0812345678',
          'company_name': 'บริษัท ABC จำกัด',
          'occupation': 'พนักงานบัญชี',
          'salary': 25000.0,
          'sync_status': 'synced',
        },
        {
          'id': 2,
          'loan_id': int.parse(event.loanId),
          'guarantor_type': 'juristic',
          'title': 'บริษัท',
          'first_name': 'XYZ',
          'last_name': 'คอร์ปอเรชั่น',
          'trade_registration_id': '0105556000001',
          'tax_id': '0105556000001',
          'mobile_phone': '022345678',
          'company_name': 'บริษัท XYZ คอร์ปอเรชั่น',
          'occupation': 'นิติบุคคล',
          'salary': 100000.0,
          'sync_status': 'pending',
        },
      ];
      
      emit(GuarantorLoaded(mockGuarantors));
    } catch (error) {
      emit(GuarantorError('ไม่สามารถโหลดข้อมูลผู้ค้ำประกัน: $error'));
    }
  }

  Future<void> _onAddGuarantor(AddGuarantor event, Emitter<GuarantorState> emit) async {
    emit(GuarantorLoading());
    
    try {
      // TODO: เชื่อมต่อกับ API จริง
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success
      emit(GuarantorOperationSuccess('เพิ่มผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors
      final loanId = event.guarantorData['loan_id']?.toString() ?? '0';
      add(LoadGuarantors(loanId));
    } catch (error) {
      emit(GuarantorError('ไม่สามารถเพิ่มผู้ค้ำประกัน: $error'));
    }
  }

  Future<void> _onUpdateGuarantor(UpdateGuarantor event, Emitter<GuarantorState> emit) async {
    emit(GuarantorLoading());
    
    try {
      // TODO: เชื่อมต่อกับ API จริง
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success
      emit(GuarantorOperationSuccess('แก้ไขข้อมูลผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors
      add(LoadGuarantors('0')); // TODO: ใช้ loanId ที่ถูกต้อง
    } catch (error) {
      emit(GuarantorError('ไม่สามารถแก้ไขข้อมูลผู้ค้ำประกัน: $error'));
    }
  }

  Future<void> _onDeleteGuarantor(DeleteGuarantor event, Emitter<GuarantorState> emit) async {
    emit(GuarantorLoading());
    
    try {
      // TODO: เชื่อมต่อกับ API จริง
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success
      emit(GuarantorOperationSuccess('ลบผู้ค้ำประกันสำเร็จแล้ว'));
      
      // Reload guarantors
      add(LoadGuarantors('0')); // TODO: ใช้ loanId ที่ถูกต้อง
    } catch (error) {
      emit(GuarantorError('ไม่สามารถลบผู้ค้ำประกัน: $error'));
    }
  }

  Future<void> _onSearchGuarantors(SearchGuarantors event, Emitter<GuarantorState> emit) async {
    emit(GuarantorLoading());
    
    try {
      // TODO: เชื่อมต่อกับ API จริง
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock search results
      final searchResults = [
        {
          'id': 3,
          'loan_id': 1,
          'guarantor_type': 'individual',
          'title': 'นางสาว',
          'first_name': 'มานี',
          'last_name': 'รักษาดี',
          'id_card': '9876543210987',
          'mobile_phone': '0898765432',
          'company_name': 'บริษัท DEF จำกัด',
          'occupation': 'พนักงานขาย',
          'salary': 20000.0,
          'sync_status': 'synced',
        },
      ];
      
      emit(GuarantorLoaded(searchResults));
    } catch (error) {
      emit(GuarantorError('ไม่สามารถค้นหาผู้ค้ำประกัน: $error'));
    }
  }
}
