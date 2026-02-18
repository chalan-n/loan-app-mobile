import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 👤 Step 1 - ข้อมูลผู้เช่าซื้อ
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

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _idCardCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _otherIncomeCtrl = TextEditingController();
  final _taxIdCtrl = TextEditingController();
  final _tradeRegCtrl = TextEditingController();
  final _idCardIssueDateCtrl = TextEditingController();
  final _idCardExpiryDateCtrl = TextEditingController();
  final _dateOfBirthCtrl = TextEditingController();
  final _registrationDateCtrl = TextEditingController();

  // Dropdown values
  String _borrowerType = 'individual';
  String _prefix = 'นาย';
  String _gender = 'ชาย';
  String _maritalStatus = 'โสด';
  String _ethnicity = 'ไทย';
  String _nationality = 'ไทย';
  String _religion = 'พุทธ';
  String _creditBureauStatus = 'ปกติ';
  String _incomeSource = 'เงินเดือน';

  @override
  void initState() {
    super.initState();
    _loadFromFormData();
  }

  void _loadFromFormData() {
    final d = widget.formData;
    _firstNameCtrl.text = d['first_name'] ?? '';
    _lastNameCtrl.text = d['last_name'] ?? '';
    _idCardCtrl.text = d['id_card'] ?? '';
    _phoneCtrl.text = d['mobile_phone'] ?? '';
    _companyCtrl.text = d['company_name'] ?? '';
    _occupationCtrl.text = d['occupation'] ?? '';
    _positionCtrl.text = d['position'] ?? '';
    _salaryCtrl.text = d['salary']?.toString() ?? '';
    _otherIncomeCtrl.text = d['other_income']?.toString() ?? '';
    _taxIdCtrl.text = d['tax_id'] ?? '';
    _tradeRegCtrl.text = d['trade_registration_id'] ?? '';
    _idCardIssueDateCtrl.text = d['id_card_issue_date'] ?? '';
    _idCardExpiryDateCtrl.text = d['id_card_expiry_date'] ?? '';
    _dateOfBirthCtrl.text = d['date_of_birth'] ?? '';
    _registrationDateCtrl.text = d['registration_date'] ?? '';
    _borrowerType = d['borrower_type'] ?? 'individual';
    _prefix = d['prefix'] ?? 'นาย';
    _gender = d['gender'] ?? 'ชาย';
    _maritalStatus = d['marital_status'] ?? 'โสด';
    _ethnicity = d['ethnicity'] ?? 'ไทย';
    _nationality = d['nationality'] ?? 'ไทย';
    _religion = d['religion'] ?? 'พุทธ';
    _creditBureauStatus = d['credit_bureau_status'] ?? 'ปกติ';
    _incomeSource = d['income_source'] ?? 'เงินเดือน';
  }

  void _saveToFormData() {
    widget.formData['borrower_type'] = _borrowerType;
    widget.formData['prefix'] = _prefix;
    widget.formData['first_name'] = _firstNameCtrl.text;
    widget.formData['last_name'] = _lastNameCtrl.text;
    widget.formData['gender'] = _gender;
    widget.formData['id_card'] = _idCardCtrl.text;
    widget.formData['id_card_issue_date'] = _idCardIssueDateCtrl.text;
    widget.formData['id_card_expiry_date'] = _idCardExpiryDateCtrl.text;
    widget.formData['date_of_birth'] = _dateOfBirthCtrl.text;
    widget.formData['ethnicity'] = _ethnicity;
    widget.formData['nationality'] = _nationality;
    widget.formData['religion'] = _religion;
    widget.formData['marital_status'] = _maritalStatus;
    widget.formData['mobile_phone'] = _phoneCtrl.text;
    widget.formData['company_name'] = _companyCtrl.text;
    widget.formData['occupation'] = _occupationCtrl.text;
    widget.formData['position'] = _positionCtrl.text;
    widget.formData['salary'] = _salaryCtrl.text;
    widget.formData['other_income'] = _otherIncomeCtrl.text;
    widget.formData['income_source'] = _incomeSource;
    widget.formData['credit_bureau_status'] = _creditBureauStatus;
    widget.formData['trade_registration_id'] = _tradeRegCtrl.text;
    widget.formData['registration_date'] = _registrationDateCtrl.text;
    widget.formData['tax_id'] = _taxIdCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Section: ประเภทผู้เช่าซื้อ ===
          _buildSection(
            icon: FontAwesomeIcons.users,
            title: 'ประเภทผู้เช่าซื้อ',
            children: [
              _buildRadioGroup('ประเภทผู้กู้', _borrowerType, {
                'individual': 'บุคคลธรรมดา',
                'juristic': 'นิติบุคคล',
              }, (v) => setState(() => _borrowerType = v ?? 'individual')),
            ],
          ),

          SizedBox(height: 20.h),

          // === Section: ข้อมูลส่วนตัว ===
          _buildSection(
            icon: FontAwesomeIcons.idCard,
            title: 'ข้อมูลส่วนตัว',
            children: [
              _buildDropdown('คำนำหน้า', _prefix, ['นาย', 'นาง', 'นางสาว'], (v) => setState(() => _prefix = v ?? 'นาย')),
              _buildTextField('ชื่อ', _firstNameCtrl),
              _buildTextField('นามสกุล', _lastNameCtrl),
              _buildDropdown('เพศ', _gender, ['ชาย', 'หญิง'], (v) => setState(() => _gender = v ?? 'ชาย')),
              _buildDropdown('สถานะภาพ', _maritalStatus, ['โสด', 'สมรส', 'หย่า', 'ม่าย'], (v) => setState(() => _maritalStatus = v ?? 'โสด')),
              _buildTextField('เลขบัตรประชาชน', _idCardCtrl, keyboardType: TextInputType.number),
              _buildTextField('วันออกบัตร', _idCardIssueDateCtrl, onTap: () => _selectDate(context, _idCardIssueDateCtrl)),
              _buildTextField('วันหมดอายุ', _idCardExpiryDateCtrl, onTap: () => _selectDate(context, _idCardExpiryDateCtrl)),
              _buildTextField('วันเกิด', _dateOfBirthCtrl, onTap: () => _selectDate(context, _dateOfBirthCtrl)),
              _buildDropdown('เชื้อชาติ', _ethnicity, ['ไทย', 'อื่นๆ'], (v) => setState(() => _ethnicity = v ?? 'ไทย')),
              _buildDropdown('สัญชาติ', _nationality, ['ไทย', 'อื่นๆ'], (v) => setState(() => _nationality = v ?? 'ไทย')),
              _buildDropdown('ศาสนา', _religion, ['พุทธ', 'อิสลาม', 'คริสต์', 'อื่นๆ'], (v) => setState(() => _religion = v ?? 'พุทธ')),
            ],
          ),

          SizedBox(height: 20.h),

          // === Section: ข้อมูลติดต่อ ===
          _buildSection(
            icon: FontAwesomeIcons.phone,
            title: 'ข้อมูลติดต่อ',
            children: [
              _buildTextField('เบอร์โทรศัพท์มือถือ', _phoneCtrl, keyboardType: TextInputType.phone),
            ],
          ),

          SizedBox(height: 20.h),

          // === Section: ข้อมูลการทำงาน ===
          _buildSection(
            icon: FontAwesomeIcons.briefcase,
            title: 'ข้อมูลการทำงาน',
            children: [
              _buildTextField('ชื่อบริษัท/หน่วยงาน', _companyCtrl),
              _buildTextField('อาชีพ', _occupationCtrl),
              _buildTextField('ตำแหน่ง', _positionCtrl),
              _buildTextField('เงินเดือน (บาท)', _salaryCtrl, keyboardType: TextInputType.number),
              _buildTextField('รายได้อื่น (บาท)', _otherIncomeCtrl, keyboardType: TextInputType.number),
              _buildDropdown('แหล่งรายได้', _incomeSource, ['เงินเดือน', 'ธุรกิจส่วนตัว', 'อื่นๆ'], (v) => setState(() => _incomeSource = v ?? 'เงินเดือน')),
              _buildDropdown('สถานะเครดิตบูโร', _creditBureauStatus, ['ปกติ', 'ค้างชำระ', 'อื่นๆ'], (v) => setState(() => _creditBureauStatus = v ?? 'ปกติ')),
            ],
          ),

          // === Section: ข้อมูลนิติบุคคล (แสดงเฉพาะเมื่อเลือกนิติบุคคล) ===
          if (_borrowerType == 'juristic') ...[
            SizedBox(height: 20.h),
            _buildSection(
              icon: FontAwesomeIcons.building,
              title: 'ข้อมูลนิติบุคคล',
              children: [
                _buildTextField('เลขทะเบียนพาณิชย์', _tradeRegCtrl),
                _buildTextField('วันที่จดทะเบียน', _registrationDateCtrl, onTap: () => _selectDate(context, _registrationDateCtrl)),
                _buildTextField('เลขประจำตัวผู้เสียภาษี', _taxIdCtrl),
              ],
            ),
          ],

          SizedBox(height: 20.h),

          // === Info Box ===
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFeff6ff),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFbfdbfe)),
            ),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.circleInfo, color: navy, size: 16.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'กรุณาตรวจสอบข้อมูลให้ครบถ้วนก่อนดำเนินการต่อ',
                    style: GoogleFonts.kanit(fontSize: 12.sp, color: const Color(0xFF6b7280)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Reusable Widgets (เหมือน Step2) ===

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
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
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: navy, width: 3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w, height: 36.w,
                  decoration: const BoxDecoration(
                    color: navy,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(icon, color: Colors.white, size: 16.sp)),
                ),
                SizedBox(width: 10.w),
                Text(title, style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600, color: navy)),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
          SizedBox(height: 6.h),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            readOnly: onTap != null || readOnly,
            onTap: onTap,
            style: GoogleFonts.kanit(fontSize: 14.sp),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFf3f4f6) : Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              suffixIcon: onTap != null ? Icon(FontAwesomeIcons.calendar, size: 14.sp, color: navy) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: navy, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : null,
                isExpanded: true,
                style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF1e293b)),
                hint: Text('— เลือก —', style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF9ca3af))),
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup(String label, String value, Map<String, String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 20.w,
            children: options.entries.map((e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(value: e.key, groupValue: value, onChanged: onChanged, activeColor: navy),
                Text(e.value, style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF4b5563))),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
      locale: const Locale('th', 'TH'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: navy,
              onPrimary: Colors.white,
              surface: Color(0xFFf8fafc),
              onSurface: Color(0xFF1e293b),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  @override
  void dispose() {
    _saveToFormData();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _idCardCtrl.dispose();
    _phoneCtrl.dispose();
    _companyCtrl.dispose();
    _occupationCtrl.dispose();
    _positionCtrl.dispose();
    _salaryCtrl.dispose();
    _otherIncomeCtrl.dispose();
    _taxIdCtrl.dispose();
    _tradeRegCtrl.dispose();
    _idCardIssueDateCtrl.dispose();
    _idCardExpiryDateCtrl.dispose();
    _dateOfBirthCtrl.dispose();
    _registrationDateCtrl.dispose();
    super.dispose();
  }
}
