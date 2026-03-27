import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';
import '../../utils/image_preprocessor.dart';

/// 👤 Step 1 — ข้อมูลผู้เช่าซื้อ (ตรงตามภาพ reference)
class Step1Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  const Step1Screen({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  // ─── ข้อมูลส่วนตัว ────────────────────────────────────────
  final _prefixCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _idCardCtrl = TextEditingController();
  final _idCardIssueDateCtrl = TextEditingController();
  final _idCardExpiryDateCtrl = TextEditingController();
  final _dateOfBirthCtrl = TextEditingController();
  final _ageCtrl = TextEditingController(); // read-only
  final _phoneCtrl = TextEditingController();
  final _otherCardNoCtrl = TextEditingController();
  final _otherCardIssueDateCtrl = TextEditingController();
  final _otherCardExpiryDateCtrl = TextEditingController();

  // ─── ข้อมูลการทำงาน / รายได้ ──────────────────────────────
  final _companyCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _otherIncomeCtrl = TextEditingController();
  final _incomeSourceCtrl = TextEditingController(); // แหล่งที่มา
  final _workPhoneCtrl = TextEditingController();

  // ─── ที่อยู่ตามทะเบียนบ้าน ────────────────────────────────
  final _houseNoCtrl = TextEditingController();
  final _buildingCtrl = TextEditingController();  // อาคาร/หมู่บ้าน
  final _floorCtrl = TextEditingController();     // ชั้นที่
  final _roomCtrl = TextEditingController();      // เลขที่ห้อง
  final _mooCtrl = TextEditingController();
  final _alleyCtrl = TextEditingController();     // ซอย
  final _roadCtrl = TextEditingController();      // ถนน
  final _tambonCtrl = TextEditingController();    // ตำบล/แขวง
  final _amphoeCtrl = TextEditingController();    // อำเภอ/เขต
  final _provinceCtrl = TextEditingController();  // จังหวัด
  final _zipCtrl = TextEditingController();

  // ─── ที่อยู่ปัจจุบัน ──────────────────────────────────────
  final _curCompanyCtrl = TextEditingController();  // บริษัท/ห้างร้าน/นิติบุคคล
  final _curHouseNoCtrl = TextEditingController();
  final _curBuildingCtrl = TextEditingController(); // อาคาร/หมู่บ้าน
  final _curFloorCtrl = TextEditingController();    // ชั้นที่
  final _curRoomCtrl = TextEditingController();     // เลขที่ห้อง
  final _curMooCtrl = TextEditingController();
  final _curAlleyCtrl = TextEditingController();
  final _curRoadCtrl = TextEditingController();
  final _curTambonCtrl = TextEditingController();
  final _curAmphoeCtrl = TextEditingController();
  final _curProvinceCtrl = TextEditingController();
  final _curZipCtrl = TextEditingController();

  // ─── ที่อยู่ที่ทำงาน ──────────────────────────────────────
  final _workHouseNoCtrl = TextEditingController();
  final _workBuildingCtrl = TextEditingController();
  final _workFloorCtrl = TextEditingController();
  final _workRoomCtrl = TextEditingController();
  final _workMooCtrl = TextEditingController();
  final _workAlleyCtrl = TextEditingController();
  final _workRoadCtrl = TextEditingController();
  final _workTambonCtrl = TextEditingController();
  final _workAmphoeCtrl = TextEditingController();
  final _workProvinceCtrl = TextEditingController();
  final _workZipCtrl = TextEditingController();

  // ─── ที่อยู่จัดส่งเอกสาร ──────────────────────────────────
  final _delHouseNoCtrl = TextEditingController();
  final _delMooCtrl = TextEditingController();
  final _delAlleyCtrl = TextEditingController();
  final _delRoadCtrl = TextEditingController();
  final _delTambonCtrl = TextEditingController();
  final _delAmphoeCtrl = TextEditingController();
  final _delProvinceCtrl = TextEditingController();
  final _delZipCtrl = TextEditingController();

  // ─── ข้อมูลนิติบุคคล ──────────────────────────────────────
  final _tradeRegCtrl = TextEditingController();
  final _regDateCtrl = TextEditingController();
  final _taxIdCtrl = TextEditingController();

  // ─── Dropdown / Radio State ────────────────────────────────
  String _borrowerType = 'individual';
  String _prefix = 'นาย';
  String _gender = 'ชาย';
  String _otherCardType = '';
  String _occupation = '';
  bool _sameAsRegistered = false;
  String _deliveryChoice = 'registered';
  String _creditBureauResult = 'found';

  // ─── OCR State ─────────────────────────────────────────────
  bool _isOcrLoading = false;
  String _ocrError = '';
  final ImagePicker _imagePicker = ImagePicker();

  // ─── Reference Data (จาก Server) ───────────────────────────
  List<String> _titleNames = ['นาย', 'นาง', 'นางสาว', 'เด็กชาย', 'เด็กหญิง'];
  List<String> _occupationNames = [];
  List<String> _religionNames = [];
  List<String> _ethnicityNames = [];
  List<String> _nationalityNames = [];
  bool _refDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    _loadRefData();
  }

  // ─── โหลด Reference Data จาก Server ──────────────────────
  Future<void> _loadRefData() async {
    if (_refDataLoaded) return;
    try {
      final results = await Future.wait([
        ApiService.getTitles(),
        ApiService.getOccupations(),
        ApiService.getReligions(),
        ApiService.getRaces(),
        ApiService.getNations(),
      ]);

      if (!mounted) return;
      setState(() {
        final titles = results[0];
        if (titles.isNotEmpty) {
          _titleNames = titles.map((e) => e.name).toList();
          // ถ้า prefix ปัจจุบันไม่อยู่ในรายการ ให้ใช้ตัวแรก
          if (!_titleNames.contains(_prefix) && _titleNames.isNotEmpty) {
            _prefix = _titleNames.first;
          }
        }

        final occupations = results[1];
        if (occupations.isNotEmpty) {
          _occupationNames = occupations.map((e) => e.name).toList();
        }

        final religions = results[2];
        if (religions.isNotEmpty) {
          _religionNames = ['', ...religions.map((e) => e.name)];
        }

        final races = results[3];
        if (races.isNotEmpty) {
          _ethnicityNames = ['', ...races.map((e) => e.name)];
        }

        final nations = results[4];
        if (nations.isNotEmpty) {
          _nationalityNames = ['', ...nations.map((e) => e.name)];
        }

        _refDataLoaded = true;
      });
    } catch (e) {
      debugPrint('⚠️ [Step1] loadRefData error: $e');
    }
  }

  void _load() {
    final d = widget.formData;
    _borrowerType = d['borrower_type'] ?? 'individual';
    _prefix = d['prefix'] ?? 'นาย';
    _firstNameCtrl.text = d['first_name'] ?? '';
    _lastNameCtrl.text = d['last_name'] ?? '';
    _gender = d['gender'] ?? 'ชาย';
    _idCardCtrl.text = d['id_card'] ?? '';
    _idCardIssueDateCtrl.text = d['id_card_issue_date'] ?? '';
    _idCardExpiryDateCtrl.text = d['id_card_expiry_date'] ?? '';
    _dateOfBirthCtrl.text = d['date_of_birth'] ?? '';
    _ageCtrl.text = d['age']?.toString() ?? '';
    _phoneCtrl.text = d['mobile_phone'] ?? '';
    _otherCardType = d['other_card_type'] ?? '';
    _otherCardNoCtrl.text = d['other_card_no'] ?? '';
    _otherCardIssueDateCtrl.text = d['other_card_issue_date'] ?? '';
    _otherCardExpiryDateCtrl.text = d['other_card_expiry_date'] ?? '';

    _companyCtrl.text = d['company_name'] ?? '';
    _occupation = d['occupation'] ?? '';
    _positionCtrl.text = d['position'] ?? '';
    _salaryCtrl.text = d['salary']?.toString() ?? '';
    _otherIncomeCtrl.text = d['other_income']?.toString() ?? '';
    _incomeSourceCtrl.text = d['income_source'] ?? '';
    _workPhoneCtrl.text = d['work_phone'] ?? '';

    _houseNoCtrl.text = d['house_number'] ?? '';
    _buildingCtrl.text = d['building'] ?? '';
    _floorCtrl.text = d['floor'] ?? '';
    _roomCtrl.text = d['room'] ?? '';
    _mooCtrl.text = d['village'] ?? '';
    _alleyCtrl.text = d['alley'] ?? '';
    _roadCtrl.text = d['road'] ?? '';
    _provinceCtrl.text = d['province'] ?? '';
    _amphoeCtrl.text = d['district'] ?? '';
    _tambonCtrl.text = d['subdistrict'] ?? '';
    _zipCtrl.text = d['postal_code'] ?? '';

    _sameAsRegistered = d['same_as_registered'] == true;
    _curCompanyCtrl.text = d['cur_company'] ?? '';
    _curHouseNoCtrl.text = d['cur_house_number'] ?? '';
    _curBuildingCtrl.text = d['cur_building'] ?? '';
    _curFloorCtrl.text = d['cur_floor'] ?? '';
    _curRoomCtrl.text = d['cur_room'] ?? '';
    _curMooCtrl.text = d['cur_village'] ?? '';
    _curAlleyCtrl.text = d['cur_alley'] ?? '';
    _curRoadCtrl.text = d['cur_road'] ?? '';
    _curProvinceCtrl.text = d['cur_province'] ?? '';
    _curAmphoeCtrl.text = d['cur_district'] ?? '';
    _curTambonCtrl.text = d['cur_subdistrict'] ?? '';
    _curZipCtrl.text = d['cur_postal_code'] ?? '';

    _workHouseNoCtrl.text = d['work_house_number'] ?? '';
    _workBuildingCtrl.text = d['work_building'] ?? '';
    _workFloorCtrl.text = d['work_floor'] ?? '';
    _workRoomCtrl.text = d['work_room'] ?? '';
    _workMooCtrl.text = d['work_village'] ?? '';
    _workAlleyCtrl.text = d['work_alley'] ?? '';
    _workRoadCtrl.text = d['work_road'] ?? '';
    _workProvinceCtrl.text = d['work_province'] ?? '';
    _workAmphoeCtrl.text = d['work_district'] ?? '';
    _workTambonCtrl.text = d['work_subdistrict'] ?? '';
    _workZipCtrl.text = d['work_postal_code'] ?? '';

    _deliveryChoice = d['delivery_choice'] ?? 'registered';
    _delHouseNoCtrl.text = d['del_house_number'] ?? '';
    _delMooCtrl.text = d['del_village'] ?? '';
    _delAlleyCtrl.text = d['del_alley'] ?? '';
    _delRoadCtrl.text = d['del_road'] ?? '';
    _delTambonCtrl.text = d['del_subdistrict'] ?? '';
    _delAmphoeCtrl.text = d['del_district'] ?? '';
    _delProvinceCtrl.text = d['del_province'] ?? '';
    _delZipCtrl.text = d['del_postal_code'] ?? '';

    _tradeRegCtrl.text = d['trade_registration_id'] ?? '';
    _regDateCtrl.text = d['registration_date'] ?? '';
    _taxIdCtrl.text = d['tax_id'] ?? '';
    _creditBureauResult = d['credit_bureau_result'] ?? 'found';
  }

  void _save() {
    final d = widget.formData;
    d['borrower_type'] = _borrowerType;
    d['prefix'] = _prefix;
    d['first_name'] = _firstNameCtrl.text;
    d['last_name'] = _lastNameCtrl.text;
    d['gender'] = _gender;
    d['id_card'] = _idCardCtrl.text;
    d['id_card_issue_date'] = _idCardIssueDateCtrl.text;
    d['id_card_expiry_date'] = _idCardExpiryDateCtrl.text;
    d['date_of_birth'] = _dateOfBirthCtrl.text;
    d['age'] = _ageCtrl.text;
    d['mobile_phone'] = _phoneCtrl.text;
    d['other_card_type'] = _otherCardType;
    d['other_card_no'] = _otherCardNoCtrl.text;
    d['other_card_issue_date'] = _otherCardIssueDateCtrl.text;
    d['other_card_expiry_date'] = _otherCardExpiryDateCtrl.text;
    d['company_name'] = _companyCtrl.text;
    d['occupation'] = _occupation;
    d['position'] = _positionCtrl.text;
    d['salary'] = _salaryCtrl.text;
    d['other_income'] = _otherIncomeCtrl.text;
    d['income_source'] = _incomeSourceCtrl.text;
    d['work_phone'] = _workPhoneCtrl.text;
    d['house_number'] = _houseNoCtrl.text;
    d['building'] = _buildingCtrl.text;
    d['floor'] = _floorCtrl.text;
    d['room'] = _roomCtrl.text;
    d['village'] = _mooCtrl.text;
    d['alley'] = _alleyCtrl.text;
    d['road'] = _roadCtrl.text;
    d['province'] = _provinceCtrl.text;
    d['district'] = _amphoeCtrl.text;
    d['subdistrict'] = _tambonCtrl.text;
    d['postal_code'] = _zipCtrl.text;
    d['same_as_registered'] = _sameAsRegistered;
    d['cur_company'] = _curCompanyCtrl.text;
    d['cur_house_number'] = _curHouseNoCtrl.text;
    d['cur_building'] = _curBuildingCtrl.text;
    d['cur_floor'] = _curFloorCtrl.text;
    d['cur_room'] = _curRoomCtrl.text;
    d['cur_village'] = _curMooCtrl.text;
    d['cur_alley'] = _curAlleyCtrl.text;
    d['cur_road'] = _curRoadCtrl.text;
    d['cur_province'] = _curProvinceCtrl.text;
    d['cur_district'] = _curAmphoeCtrl.text;
    d['cur_subdistrict'] = _curTambonCtrl.text;
    d['cur_postal_code'] = _curZipCtrl.text;
    d['work_house_number'] = _workHouseNoCtrl.text;
    d['work_building'] = _workBuildingCtrl.text;
    d['work_floor'] = _workFloorCtrl.text;
    d['work_room'] = _workRoomCtrl.text;
    d['work_village'] = _workMooCtrl.text;
    d['work_alley'] = _workAlleyCtrl.text;
    d['work_road'] = _workRoadCtrl.text;
    d['work_province'] = _workProvinceCtrl.text;
    d['work_district'] = _workAmphoeCtrl.text;
    d['work_subdistrict'] = _workTambonCtrl.text;
    d['work_postal_code'] = _workZipCtrl.text;
    d['delivery_choice'] = _deliveryChoice;
    d['del_house_number'] = _delHouseNoCtrl.text;
    d['del_village'] = _delMooCtrl.text;
    d['del_alley'] = _delAlleyCtrl.text;
    d['del_road'] = _delRoadCtrl.text;
    d['del_subdistrict'] = _delTambonCtrl.text;
    d['del_district'] = _delAmphoeCtrl.text;
    d['del_province'] = _delProvinceCtrl.text;
    d['del_postal_code'] = _delZipCtrl.text;
    d['trade_registration_id'] = _tradeRegCtrl.text;
    d['registration_date'] = _regDateCtrl.text;
    d['tax_id'] = _taxIdCtrl.text;
    d['credit_bureau_result'] = _creditBureauResult;
  }

  void _calcAge(String dob) {
    try {
      final p = dob.split('/');
      if (p.length != 3) return;
      final birth =
          DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      setState(() => _ageCtrl.text = age.toString());
    } catch (_) {}
  }

  // ─── OCR บัตรประชาชน ────────────────────────────────────
  Future<void> _scanIDCard(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2048,
      );
      if (picked == null) return;

      setState(() {
        _isOcrLoading = true;
        _ocrError = '';
      });

      // ── Preprocess ภาพ (Contrast + Sharpen) ก่อนส่ง OCR ──────────
      final imageFile = await ImagePreprocessor.preprocessIDCard(File(picked.path));
      final result = await ApiService.ocrIDCard(imageFile);
      final d = result.data;

      setState(() {
        // auto-fill ข้อมูลส่วนตัว
        if (d.title.isNotEmpty) _prefix = d.title;
        if (d.firstName.isNotEmpty) _firstNameCtrl.text = d.firstName;
        if (d.lastName.isNotEmpty) _lastNameCtrl.text = d.lastName;
        if (d.idNumber.isNotEmpty) _idCardCtrl.text = d.idNumber;
        if (d.gender.isNotEmpty) _gender = d.gender;
        if (d.dateOfBirth.isNotEmpty) {
          _dateOfBirthCtrl.text = d.dateOfBirth;
          _calcAge(d.dateOfBirth);
        }
        if (d.issueDate.isNotEmpty) _idCardIssueDateCtrl.text = d.issueDate;
        if (d.expiryDate.isNotEmpty) _idCardExpiryDateCtrl.text = d.expiryDate;

        // auto-fill ที่อยู่ตามทะเบียนบ้าน
        if (d.houseNo.isNotEmpty) _houseNoCtrl.text = d.houseNo;
        if (d.moo.isNotEmpty) _mooCtrl.text = d.moo;
        if (d.soi.isNotEmpty) _alleyCtrl.text = d.soi;
        if (d.road.isNotEmpty) _roadCtrl.text = d.road;
        if (d.subdistrict.isNotEmpty) _tambonCtrl.text = d.subdistrict;
        if (d.district.isNotEmpty) _amphoeCtrl.text = d.district;
        if (d.province.isNotEmpty) _provinceCtrl.text = d.province;
        if (d.zipcode.isNotEmpty) _zipCtrl.text = d.zipcode;

        _isOcrLoading = false;
      });

      // แสดงผลสำเร็จ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                result.idValid
                    ? 'OCR สำเร็จ — บัตรประชาชนถูกต้อง'
                    : 'OCR สำเร็จ — กรุณาตรวจสอบข้อมูล',
                style: GoogleFonts.kanit(color: Colors.white),
              ),
            ]),
            backgroundColor: result.idValid
                ? const Color(0xFF059669)
                : const Color(0xFFd97706),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isOcrLoading = false;
        _ocrError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ─── แสดง bottom sheet เลือกแหล่งรูป ────────────────────
  void _showImageSourceSheet(Future<void> Function(ImageSource) onPick) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFe2e8f0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text('เลือกรูปภาพจาก',
                  style: GoogleFonts.kanit(
                      fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _sheetOption(
                      icon: FontAwesomeIcons.camera,
                      label: 'กล้อง',
                      onTap: () {
                        Navigator.pop(context);
                        onPick(ImageSource.camera);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _sheetOption(
                      icon: FontAwesomeIcons.images,
                      label: 'คลังรูปภาพ',
                      onTap: () {
                        Navigator.pop(context);
                        onPick(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFf8fafc),
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: const Color(0xFFe2e8f0), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: navy, size: 24.sp),
            SizedBox(height: 8.h),
            Text(label,
                style: GoogleFonts.kanit(
                    fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ─── OCR Button Widget ──────────────────────────────────
  Widget _ocrButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isOcrLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1e3a8a), Color(0xFF1e40af)],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1e3a8a).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isOcrLoading)
              SizedBox(
                width: 18.sp,
                height: 18.sp,
                child: const CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            else
              Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 10.w),
            Text(
              _isOcrLoading ? 'กำลังวิเคราะห์...' : label,
              style: GoogleFonts.kanit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [1] ประเภทผู้เช่าซื้อ
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.users,
            title: 'ประเภทผู้เช่าซื้อ',
            children: [
              _radio('ประเภทผู้กู้', _borrowerType, {
                'individual': 'บุคคลธรรมดา',
                'juristic': 'นิติบุคคล',
              }, (v) => setState(() => _borrowerType = v!)),
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [2] ข้อมูลส่วนตัว
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.idCard,
            title: 'ข้อมูลส่วนตัว',
            children: [
              // ─── ปุ่ม OCR บัตรประชาชน ───────────────
              _ocrButton(
                label: 'สแกนบัตรประชาชน (AI)',
                icon: FontAwesomeIcons.idCard,
                onTap: () => _showImageSourceSheet(_scanIDCard),
              ),
              if (_ocrError.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFfef2f2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFfca5a5)),
                  ),
                  child: Row(children: [
                    Icon(Icons.error_outline,
                        color: const Color(0xFFdc2626), size: 16.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(_ocrError,
                          style: GoogleFonts.kanit(
                              fontSize: 13.sp,
                              color: const Color(0xFFdc2626))),
                    ),
                  ]),
                ),
              ],
              SizedBox(height: 12.h),
              // ─── ฟิลด์ข้อมูลส่วนตัว ────────────────
              _dropdown('คำนำหน้า', _prefix, _titleNames,
                  (v) => setState(() => _prefix = v!)),
              _field('ชื่อ *', _firstNameCtrl),
              _field('นามสกุล *', _lastNameCtrl),
              _field('เลขบัตรประชาชน (13 หลัก) *', _idCardCtrl,
                  kb: TextInputType.number),
              _field('วันออกบัตร', _idCardIssueDateCtrl, isDate: true),
              _field('วันหมดอายุ', _idCardExpiryDateCtrl, isDate: true),
              _field('วันเกิด *', _dateOfBirthCtrl,
                  isDate: true, onDatePicked: _calcAge),
              _field('อายุ (ปี)', _ageCtrl,
                  readOnly: true, kb: TextInputType.number),
              _dropdown('เพศ', _gender, ['ชาย', 'หญิง'],
                  (v) => setState(() => _gender = v!)),
              _field('เบอร์โทรศัพท์มือถือ *', _phoneCtrl,
                  kb: TextInputType.phone),
              _dropdown('บัตรอื่นๆ', _otherCardType,
                  ['', 'ใบขับขี่', 'พาสปอร์ต', 'บัตรข้าราชการ', 'อื่นๆ'],
                  (v) => setState(() => _otherCardType = v!)),
              if (_otherCardType.isNotEmpty) ...[
                _field('เลขบัตร', _otherCardNoCtrl),
                _row2(
                  _fieldHalf('วันออกบัตร', _otherCardIssueDateCtrl, isDate: true),
                  _fieldHalf('วันบัตรหมดอายุ', _otherCardExpiryDateCtrl, isDate: true),
                ),
              ],
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [3] ที่อยู่ตามทะเบียนบ้าน
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.houseChimney,
            title: 'ที่อยู่ตามทะเบียนบ้าน',
            children: [
              _field('เลขที่', _houseNoCtrl),
              _field('อาคาร/หมู่บ้าน', _buildingCtrl),
              _field('ชั้นที่', _floorCtrl),
              _field('เลขที่ห้อง', _roomCtrl),
              _field('หมู่', _mooCtrl, kb: TextInputType.number),
              _field('ซอย', _alleyCtrl),
              _field('ถนน', _roadCtrl),
              _field('จังหวัด', _provinceCtrl),
              _field('อำเภอ/เขต', _amphoeCtrl),
              _field('ตำบล/แขวง', _tambonCtrl),
              _field('รหัสไปรษณีย์', _zipCtrl,
                  kb: TextInputType.number),
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [4] ที่อยู่ปัจจุบัน
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.locationDot,
            title: 'ที่อยู่ปัจจุบัน',
            children: [
              // Checkbox ที่อยู่เดียวกับทะเบียนบ้าน
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Checkbox(
                        value: _sameAsRegistered,
                        activeColor: navy,
                        onChanged: (v) {
                          setState(() {
                            _sameAsRegistered = v ?? false;
                            if (_sameAsRegistered) {
                              _curHouseNoCtrl.text = _houseNoCtrl.text;
                              _curBuildingCtrl.text = _buildingCtrl.text;
                              _curFloorCtrl.text = _floorCtrl.text;
                              _curRoomCtrl.text = _roomCtrl.text;
                              _curMooCtrl.text = _mooCtrl.text;
                              _curAlleyCtrl.text = _alleyCtrl.text;
                              _curRoadCtrl.text = _roadCtrl.text;
                              _curProvinceCtrl.text = _provinceCtrl.text;
                              _curAmphoeCtrl.text = _amphoeCtrl.text;
                              _curTambonCtrl.text = _tambonCtrl.text;
                              _curZipCtrl.text = _zipCtrl.text;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text('ที่อยู่เดียวกับทะเบียนบ้าน',
                        style: GoogleFonts.kanit(
                            fontSize: 13.sp,
                            color: const Color(0xFF374151))),
                  ],
                ),
              ),
              _field('บริษัท/ห้างร้าน/นิติบุคคล', _curCompanyCtrl),
              _field('เลขที่', _curHouseNoCtrl),
              _field('อาคาร/หมู่บ้าน', _curBuildingCtrl),
              _field('ชั้นที่', _curFloorCtrl),
              _field('เลขที่ห้อง', _curRoomCtrl),
              _field('หมู่', _curMooCtrl, kb: TextInputType.number),
              _field('ซอย', _curAlleyCtrl),
              _field('ถนน', _curRoadCtrl),
              _field('จังหวัด', _curProvinceCtrl),
              _field('อำเภอ/เขต', _curAmphoeCtrl),
              _field('ตำบล/แขวง', _curTambonCtrl),
              _field('รหัสไปรษณีย์', _curZipCtrl,
                  kb: TextInputType.number),
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [5] ข้อมูลที่ทำงาน / รายได้
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.briefcase,
            title: 'ข้อมูลที่ทำงาน',
            children: [
              _field('ชื่อบริษัท', _companyCtrl),
              _dropdown(
                'อาชีพ',
                _occupation,
                _occupationNames.isEmpty
                    ? ['', 'พนักงานบริษัทเอกชน', 'ข้าราชการ', 'ธุรกิจส่วนตัว', 'เกษตรกร', 'รับจ้างทั่วไป', 'อื่นๆ']
                    : ['', ..._occupationNames],
                (v) => setState(() => _occupation = v!),
              ),
              _field('ตำแหน่ง', _positionCtrl),
              _field('เงินเดือน', _salaryCtrl,
                  kb: TextInputType.number),
              _field('รายได้อื่นๆ', _otherIncomeCtrl,
                  kb: TextInputType.number),
              _field('แหล่งที่มา', _incomeSourceCtrl),

              // Sub-header: ที่อยู่ที่ทำงาน
              Padding(
                padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
                child: Text('ที่อยู่ที่ทำงาน',
                    style: GoogleFonts.kanit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: navy)),
              ),
              _field('เลขที่', _workHouseNoCtrl),
              _field('อาคาร/หมู่บ้าน', _workBuildingCtrl),
              _field('ชั้นที่', _workFloorCtrl),
              _field('เลขที่ห้อง', _workRoomCtrl),
              _field('หมู่', _workMooCtrl, kb: TextInputType.number),
              _field('ซอย', _workAlleyCtrl),
              _field('ถนน', _workRoadCtrl),
              _field('จังหวัด', _workProvinceCtrl),
              _field('อำเภอ/เขต', _workAmphoeCtrl),
              _field('ตำบล/แขวง', _workTambonCtrl),
              _field('รหัสไปรษณีย์', _workZipCtrl,
                  kb: TextInputType.number),
              _field('เบอร์โทรศัพท์ที่ทำงาน', _workPhoneCtrl,
                  kb: TextInputType.phone),
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [6] ที่อยู่จัดส่งเอกสาร
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.envelope,
            title: 'ที่อยู่จัดส่งเอกสาร',
            children: [
              _radio('', _deliveryChoice, {
                'registered': 'ตามทะเบียนบ้าน',
                'current': 'ตามที่อยู่ปัจจุบัน',
                'work': 'ที่ทำงาน',
                'other': 'อื่นๆ',
              }, (v) => setState(() => _deliveryChoice = v!)),
              if (_deliveryChoice == 'other') ...[
                _field('เลขที่', _delHouseNoCtrl),
                _field('หมู่', _delMooCtrl,
                    kb: TextInputType.number),
                _field('ซอย', _delAlleyCtrl),
                _field('ถนน', _delRoadCtrl),
                _field('จังหวัด', _delProvinceCtrl),
                _field('อำเภอ/เขต', _delAmphoeCtrl),
                _field('ตำบล/แขวง', _delTambonCtrl),
                _field('รหัสไปรษณีย์', _delZipCtrl,
                    kb: TextInputType.number),
              ],
            ],
          ),

          SizedBox(height: 14.h),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [7] ข้อมูลเครดิตบูโร
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          _section(
            icon: FontAwesomeIcons.creditCard,
            title: 'ข้อมูลเครดิตบูโร',
            children: [
              _radio('ตรวจเครดิตบูโร', _creditBureauResult, {
                'found': 'พบ',
                'not_found': 'ไม่พบ',
              }, (v) => setState(() => _creditBureauResult = v!)),
            ],
          ),

          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          // [7] ข้อมูลนิติบุคคล (เฉพาะเมื่อเลือกนิติบุคคล)
          // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          if (_borrowerType == 'juristic') ...[
            SizedBox(height: 14.h),
            _section(
              icon: FontAwesomeIcons.buildingColumns,
              title: 'ข้อมูลนิติบุคคล',
              children: [
                _field('เลขทะเบียนพาณิชย์', _tradeRegCtrl),
                _field('วันที่จดทะเบียน', _regDateCtrl,
                    isDate: true),
                _field('เลขประจำตัวผู้เสียภาษี', _taxIdCtrl,
                    kb: TextInputType.number),
              ],
            ),
          ],

          SizedBox(height: 20.h),

          // Info bar
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFeff6ff),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFbfdbfe)),
            ),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.circleInfo,
                    color: navy, size: 15.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'กรุณาตรวจสอบข้อมูลให้ครบถ้วนก่อนดำเนินการต่อ',
                    style: GoogleFonts.kanit(
                        fontSize: 12.sp,
                        color: const Color(0xFF6b7280)),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // Widget Builders
  // ════════════════════════════════════════════════════════

  /// Section card
  Widget _section({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: navy, width: 3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: const BoxDecoration(
                      color: navy, shape: BoxShape.circle),
                  child: Center(
                      child: Icon(icon,
                          color: Colors.white, size: 15.sp)),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.kanit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: navy)),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  /// 2-column row
  Widget _row2(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 10.w),
        Expanded(child: right),
      ],
    );
  }

  /// Full-width text field
  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType? kb,
    bool readOnly = false,
    bool isDate = false,
    void Function(String)? onDatePicked,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: _fieldContent(label, ctrl,
          kb: kb, readOnly: readOnly, isDate: isDate,
          onDatePicked: onDatePicked),
    );
  }

  /// Half-width text field (for use inside _row2)
  Widget _fieldHalf(
    String label,
    TextEditingController ctrl, {
    TextInputType? kb,
    bool readOnly = false,
    bool isDate = false,
    void Function(String)? onDatePicked,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: _fieldContent(label, ctrl,
          kb: kb,
          readOnly: readOnly,
          isDate: isDate,
          onDatePicked: onDatePicked),
    );
  }

  Widget _fieldContent(
    String label,
    TextEditingController ctrl, {
    TextInputType? kb,
    bool readOnly = false,
    bool isDate = false,
    void Function(String)? onDatePicked,
  }) {
    final isReadOnly = readOnly || isDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.kanit(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151))),
        SizedBox(height: 5.h),
        TextField(
          controller: ctrl,
          keyboardType: kb,
          readOnly: isReadOnly,
          onTap: isDate
              ? () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now()
                        .add(const Duration(days: 365 * 50)),
                    locale: const Locale('th', 'TH'),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: navy,
                          onPrimary: Colors.white,
                          surface: Color(0xFFf8fafc),
                          onSurface: Color(0xFF1e293b),
                        ),
                      ),
                      child: Localizations.override(
                        context: ctx,
                        locale: const Locale('th', 'TH'),
                        child: child!,
                      ),
                    ),
                  );
                  if (picked != null) {
                    final s =
                        '${picked.day.toString().padLeft(2, '0')}/'
                        '${picked.month.toString().padLeft(2, '0')}/'
                        '${picked.year}';
                    ctrl.text = s;
                    onDatePicked?.call(s);
                  }
                }
              : null,
          style: GoogleFonts.kanit(fontSize: 13.sp),
          decoration: InputDecoration(
            filled: true,
            fillColor: (readOnly && !isDate)
                ? const Color(0xFFf3f4f6)
                : Colors.white,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w, vertical: 10.h),
            suffixIcon: isDate
                ? Icon(FontAwesomeIcons.calendar,
                    size: 13.sp, color: navy)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  const BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  const BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: navy, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  /// Dropdown
  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.kanit(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151))),
          SizedBox(height: 5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : null,
                isExpanded: true,
                style: GoogleFonts.kanit(
                    fontSize: 13.sp,
                    color: const Color(0xFF1e293b)),
                hint: Text('— เลือก —',
                    style: GoogleFonts.kanit(
                        fontSize: 13.sp,
                        color: const Color(0xFF9ca3af))),
                items: items
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Radio group
  Widget _radio(
    String label,
    String value,
    Map<String, String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.kanit(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151))),
          SizedBox(height: 6.h),
          Wrap(
            spacing: 16.w,
            children: options.entries
                .map((e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: e.key,
                          groupValue: value,
                          onChanged: onChanged,
                          activeColor: navy,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(e.value,
                            style: GoogleFonts.kanit(
                                fontSize: 13.sp,
                                color: const Color(0xFF4b5563))),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  @override
  void dispose() {
    _save();
    for (final c in [
      _firstNameCtrl, _lastNameCtrl, _idCardCtrl,
      _idCardIssueDateCtrl, _idCardExpiryDateCtrl,
      _dateOfBirthCtrl, _ageCtrl, _phoneCtrl, _prefixCtrl,
      _otherCardNoCtrl, _otherCardIssueDateCtrl,
      _otherCardExpiryDateCtrl,
      _companyCtrl, _positionCtrl,
      _salaryCtrl, _otherIncomeCtrl, _incomeSourceCtrl,
      _workPhoneCtrl,
      _houseNoCtrl, _buildingCtrl, _floorCtrl, _roomCtrl,
      _mooCtrl, _alleyCtrl, _roadCtrl,
      _tambonCtrl, _amphoeCtrl, _provinceCtrl, _zipCtrl,
      _curCompanyCtrl, _curHouseNoCtrl, _curBuildingCtrl,
      _curFloorCtrl, _curRoomCtrl,
      _curMooCtrl, _curAlleyCtrl, _curRoadCtrl,
      _curTambonCtrl, _curAmphoeCtrl, _curProvinceCtrl,
      _curZipCtrl,
      _workHouseNoCtrl, _workBuildingCtrl, _workFloorCtrl,
      _workRoomCtrl, _workMooCtrl, _workAlleyCtrl,
      _workRoadCtrl, _workTambonCtrl, _workAmphoeCtrl,
      _workProvinceCtrl, _workZipCtrl,
      _delHouseNoCtrl, _delMooCtrl, _delAlleyCtrl, _delRoadCtrl,
      _delTambonCtrl, _delAmphoeCtrl, _delProvinceCtrl,
      _delZipCtrl, _tradeRegCtrl, _regDateCtrl, _taxIdCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }
}
