import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 👥 Step 4 - ข้อมูลผู้ค้ำประกัน / อื่นๆ
class Step4Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step4Screen({super.key, required this.formData, required this.onNext, required this.onPrevious});

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _guarantorNameCtrl = TextEditingController();
  final _guarantorIdCardCtrl = TextEditingController();
  final _guarantorPhoneCtrl = TextEditingController();
  final _guarantorAddressCtrl = TextEditingController();
  final _guarantorRelationCtrl = TextEditingController();
  final _guarantorOccupationCtrl = TextEditingController();
  final _guarantorIncomeCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _guarantorNameCtrl.text = d['guarantor_name'] ?? '';
    _guarantorIdCardCtrl.text = d['guarantor_id_card'] ?? '';
    _guarantorPhoneCtrl.text = d['guarantor_phone'] ?? '';
    _guarantorAddressCtrl.text = d['guarantor_address'] ?? '';
    _guarantorRelationCtrl.text = d['guarantor_relation'] ?? '';
    _guarantorOccupationCtrl.text = d['guarantor_occupation'] ?? '';
    _guarantorIncomeCtrl.text = d['guarantor_income'] ?? '';
    _remarkCtrl.text = d['remark'] ?? '';
  }

  void _saveToFormData() {
    widget.formData['guarantor_name'] = _guarantorNameCtrl.text;
    widget.formData['guarantor_id_card'] = _guarantorIdCardCtrl.text;
    widget.formData['guarantor_phone'] = _guarantorPhoneCtrl.text;
    widget.formData['guarantor_address'] = _guarantorAddressCtrl.text;
    widget.formData['guarantor_relation'] = _guarantorRelationCtrl.text;
    widget.formData['guarantor_occupation'] = _guarantorOccupationCtrl.text;
    widget.formData['guarantor_income'] = _guarantorIncomeCtrl.text;
    widget.formData['remark'] = _remarkCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(icon: FontAwesomeIcons.users, title: 'ข้อมูลผู้ค้ำประกัน', children: [
            _buildTextField('ชื่อ-นามสกุล', _guarantorNameCtrl),
            _buildTextField('เลขบัตรประชาชน', _guarantorIdCardCtrl, keyboardType: TextInputType.number),
            _buildTextField('เบอร์โทรศัพท์', _guarantorPhoneCtrl, keyboardType: TextInputType.phone),
            _buildTextField('ที่อยู่', _guarantorAddressCtrl, maxLines: 3),
            _buildTextField('ความสัมพันธ์กับผู้เช่าซื้อ', _guarantorRelationCtrl),
            _buildTextField('อาชีพ', _guarantorOccupationCtrl),
            _buildTextField('รายได้ต่อเดือน', _guarantorIncomeCtrl, keyboardType: TextInputType.number),
          ]),
          SizedBox(height: 20.h),
          _buildSection(icon: FontAwesomeIcons.noteSticky, title: 'หมายเหตุ', children: [
            _buildTextField('หมายเหตุ / อื่นๆ', _remarkCtrl, maxLines: 4),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: navy, width: 3))),
            child: Row(children: [
              Container(width: 36.w, height: 36.w, decoration: BoxDecoration(color: navy.withOpacity(0.1), shape: BoxShape.circle), child: Center(child: Icon(icon, color: navy, size: 16.sp))),
              SizedBox(width: 10.w),
              Text(title, style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600, color: navy)),
            ]),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
          SizedBox(height: 6.h),
          TextField(
            controller: ctrl, keyboardType: keyboardType, maxLines: maxLines,
            style: GoogleFonts.kanit(fontSize: 14.sp),
            decoration: InputDecoration(
              filled: true, fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: navy, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() { _saveToFormData(); _guarantorNameCtrl.dispose(); _guarantorIdCardCtrl.dispose(); _guarantorPhoneCtrl.dispose(); _guarantorAddressCtrl.dispose(); _guarantorRelationCtrl.dispose(); _guarantorOccupationCtrl.dispose(); _guarantorIncomeCtrl.dispose(); _remarkCtrl.dispose(); super.dispose(); }
}
