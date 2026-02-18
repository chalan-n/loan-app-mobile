import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🛡️ Step 6 - ประกันภัย
class Step6Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step6Screen({super.key, required this.formData, required this.onNext, required this.onPrevious});

  @override
  State<Step6Screen> createState() => _Step6ScreenState();
}

class _Step6ScreenState extends State<Step6Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _insuranceCompanyCtrl = TextEditingController();
  final _insuranceTypeCtrl = TextEditingController();
  final _insurancePremiumCtrl = TextEditingController();
  final _insuranceSumCtrl = TextEditingController();
  final _insuranceStartCtrl = TextEditingController();
  final _insuranceEndCtrl = TextEditingController();
  final _insurancePolicyCtrl = TextEditingController();

  bool _hasInsurance = false;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _insuranceCompanyCtrl.text = d['car_insurance_company'] ?? '';
    _insuranceTypeCtrl.text = d['car_insurance_type'] ?? '';
    _insurancePremiumCtrl.text = d['car_insurance_premium'] ?? '';
    _insuranceSumCtrl.text = d['car_insurance_sum'] ?? '';
    _insuranceStartCtrl.text = d['car_insurance_start'] ?? '';
    _insuranceEndCtrl.text = d['car_insurance_end'] ?? '';
    _insurancePolicyCtrl.text = d['car_insurance_policy'] ?? '';
    _hasInsurance = d['has_car_insurance'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['car_insurance_company'] = _insuranceCompanyCtrl.text;
    widget.formData['car_insurance_type'] = _insuranceTypeCtrl.text;
    widget.formData['car_insurance_premium'] = _insurancePremiumCtrl.text;
    widget.formData['car_insurance_sum'] = _insuranceSumCtrl.text;
    widget.formData['car_insurance_start'] = _insuranceStartCtrl.text;
    widget.formData['car_insurance_end'] = _insuranceEndCtrl.text;
    widget.formData['car_insurance_policy'] = _insurancePolicyCtrl.text;
    widget.formData['has_car_insurance'] = _hasInsurance;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(icon: FontAwesomeIcons.shieldHalved, title: 'ข้อมูลประกันภัย', children: [
            _buildCheckbox('ทำประกันภัย', _hasInsurance, (v) => setState(() => _hasInsurance = v ?? false)),
            if (_hasInsurance) ...[
              _buildTextField('บริษัทประกัน', _insuranceCompanyCtrl),
              _buildTextField('ประเภทประกัน', _insuranceTypeCtrl),
              _buildTextField('เบี้ยประกันภัย', _insurancePremiumCtrl, keyboardType: TextInputType.number),
              _buildTextField('ทุนประกัน', _insuranceSumCtrl, keyboardType: TextInputType.number),
              _buildTextField('วันเริ่มคุ้มครอง', _insuranceStartCtrl),
              _buildTextField('วันสิ้นสุดความคุ้มครอง', _insuranceEndCtrl),
              _buildTextField('เลขกรมธรรม์', _insurancePolicyCtrl),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: light, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ]),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
        SizedBox(height: 6.h),
        TextField(
          controller: ctrl, keyboardType: keyboardType,
          style: GoogleFonts.kanit(fontSize: 14.sp),
          decoration: InputDecoration(
            filled: true, fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: navy, width: 2)),
          ),
        ),
      ]),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: navy),
        Text(label, style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF4b5563))),
      ]),
    );
  }

  @override
  void dispose() { _saveToFormData(); _insuranceCompanyCtrl.dispose(); _insuranceTypeCtrl.dispose(); _insurancePremiumCtrl.dispose(); _insuranceSumCtrl.dispose(); _insuranceStartCtrl.dispose(); _insuranceEndCtrl.dispose(); _insurancePolicyCtrl.dispose(); super.dispose(); }
}
