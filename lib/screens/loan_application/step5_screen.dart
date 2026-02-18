import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// ❤️ Step 5 - ประกันชีวิต
class Step5Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step5Screen({super.key, required this.formData, required this.onNext, required this.onPrevious});

  @override
  State<Step5Screen> createState() => _Step5ScreenState();
}

class _Step5ScreenState extends State<Step5Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _lifePrincipalCtrl = TextEditingController();
  final _lifeInterestCtrl = TextEditingController();
  final _lifeInstallmentsCtrl = TextEditingController();
  final _lifePremiumRateCtrl = TextEditingController();
  final _lifePremiumCtrl = TextEditingController();

  String _lifeInsuranceCompany = '';
  bool _hasLifeInsurance = false;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _lifePrincipalCtrl.text = d['life_loan_principal'] ?? '';
    _lifeInterestCtrl.text = d['life_interest_rate'] ?? '';
    _lifeInstallmentsCtrl.text = d['life_installments'] ?? '';
    _lifePremiumRateCtrl.text = d['life_premium_rate'] ?? '';
    _lifePremiumCtrl.text = d['life_premium'] ?? '';
    _lifeInsuranceCompany = d['life_insurance_company'] ?? '';
    _hasLifeInsurance = d['has_life_insurance'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['life_loan_principal'] = _lifePrincipalCtrl.text;
    widget.formData['life_interest_rate'] = _lifeInterestCtrl.text;
    widget.formData['life_installments'] = _lifeInstallmentsCtrl.text;
    widget.formData['life_premium_rate'] = _lifePremiumRateCtrl.text;
    widget.formData['life_premium'] = _lifePremiumCtrl.text;
    widget.formData['life_insurance_company'] = _lifeInsuranceCompany;
    widget.formData['has_life_insurance'] = _hasLifeInsurance;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(icon: FontAwesomeIcons.heartPulse, title: 'ข้อมูลประกันชีวิต', children: [
            _buildCheckbox('ทำประกันชีวิต', _hasLifeInsurance, (v) => setState(() => _hasLifeInsurance = v ?? false)),
            if (_hasLifeInsurance) ...[
              _buildDropdown('บริษัทประกัน', _lifeInsuranceCompany, [''], (v) => setState(() => _lifeInsuranceCompany = v ?? '')),
              _buildTextField('วงเงินกู้', _lifePrincipalCtrl, keyboardType: TextInputType.number),
              _buildTextField('อัตราดอกเบี้ย (%)', _lifeInterestCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _buildTextField('จำนวนงวด', _lifeInstallmentsCtrl, keyboardType: TextInputType.number),
            ],
          ]),
          if (_hasLifeInsurance) ...[
            SizedBox(height: 20.h),
            _buildSection(icon: FontAwesomeIcons.calculator, title: 'ผลการคำนวณ', children: [
              _buildTextField('อัตราเบี้ยประกัน (%)', _lifePremiumRateCtrl, readOnly: true),
              _buildTextField('ค่าเบี้ยประกัน', _lifePremiumCtrl, readOnly: true),
            ]),
          ],
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

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool readOnly = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
        SizedBox(height: 6.h),
        TextField(
          controller: ctrl, keyboardType: keyboardType, readOnly: readOnly,
          style: GoogleFonts.kanit(fontSize: 14.sp),
          decoration: InputDecoration(
            filled: true, fillColor: readOnly ? const Color(0xFFf3f4f6) : Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor, width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: navy, width: 2)),
          ),
        ),
      ]),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: borderColor, width: 2)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
            value: items.contains(value) ? value : null, isExpanded: true,
            style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF1e293b)),
            hint: Text('— เลือก —', style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF9ca3af))),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          )),
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
  void dispose() { _saveToFormData(); _lifePrincipalCtrl.dispose(); _lifeInterestCtrl.dispose(); _lifeInstallmentsCtrl.dispose(); _lifePremiumRateCtrl.dispose(); _lifePremiumCtrl.dispose(); super.dispose(); }
}
