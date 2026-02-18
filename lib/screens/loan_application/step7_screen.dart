import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 💰 Step 7 - หักภาษี ณ ที่จ่าย
class Step7Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step7Screen({super.key, required this.formData, required this.onNext, required this.onPrevious});

  @override
  State<Step7Screen> createState() => _Step7ScreenState();
}

class _Step7ScreenState extends State<Step7Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _taxRateCtrl = TextEditingController();
  final _taxAmountCtrl = TextEditingController();
  final _withholdingTaxCtrl = TextEditingController();
  final _netPaymentCtrl = TextEditingController();

  bool _hasWithholdingTax = false;

  @override
  void initState() {
    super.initState();
    final d = widget.formData;
    _taxRateCtrl.text = d['withholding_tax_rate'] ?? '';
    _taxAmountCtrl.text = d['withholding_tax_amount'] ?? '';
    _withholdingTaxCtrl.text = d['withholding_tax'] ?? '';
    _netPaymentCtrl.text = d['net_payment'] ?? '';
    _hasWithholdingTax = d['has_withholding_tax'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['withholding_tax_rate'] = _taxRateCtrl.text;
    widget.formData['withholding_tax_amount'] = _taxAmountCtrl.text;
    widget.formData['withholding_tax'] = _withholdingTaxCtrl.text;
    widget.formData['net_payment'] = _netPaymentCtrl.text;
    widget.formData['has_withholding_tax'] = _hasWithholdingTax;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(icon: FontAwesomeIcons.fileInvoiceDollar, title: 'หักภาษี ณ ที่จ่าย', children: [
            _buildCheckbox('หักภาษี ณ ที่จ่าย', _hasWithholdingTax, (v) => setState(() => _hasWithholdingTax = v ?? false)),
            if (_hasWithholdingTax) ...[
              _buildTextField('อัตราภาษี (%)', _taxRateCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _buildTextField('จำนวนเงินที่หักภาษี', _taxAmountCtrl, keyboardType: TextInputType.number),
              _buildTextField('ภาษีหัก ณ ที่จ่าย', _withholdingTaxCtrl, keyboardType: TextInputType.number, readOnly: true),
              _buildTextField('ยอดจ่ายสุทธิ', _netPaymentCtrl, keyboardType: TextInputType.number, readOnly: true),
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
  void dispose() { _saveToFormData(); _taxRateCtrl.dispose(); _taxAmountCtrl.dispose(); _withholdingTaxCtrl.dispose(); _netPaymentCtrl.dispose(); super.dispose(); }
}
