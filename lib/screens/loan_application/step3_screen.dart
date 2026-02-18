import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 📄 Step 3 - ข้อมูลสัญญา
class Step3Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step3Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _contractSignDateCtrl = TextEditingController();
  final _loanAmountCtrl = TextEditingController();
  final _interestRateCtrl = TextEditingController();
  final _installmentsCtrl = TextEditingController();
  final _installmentAmountCtrl = TextEditingController();
  final _downPaymentCtrl = TextEditingController();
  final _beginningCtrl = TextEditingController();
  final _refinanceFeeCtrl = TextEditingController();
  final _contractStartDateCtrl = TextEditingController();
  final _paymentDayCtrl = TextEditingController();
  final _firstPaymentDateCtrl = TextEditingController();
  final _transferFeeCtrl = TextEditingController();
  final _taxFeeCtrl = TextEditingController();
  final _dutyFeeCtrl = TextEditingController();

  String _loanType = '';
  String _transferType = 'company_transfer';
  bool _isLifeInsurance = false;

  @override
  void initState() {
    super.initState();
    _loadFromFormData();
  }

  void _loadFromFormData() {
    final d = widget.formData;
    _contractSignDateCtrl.text = d['contract_sign_date'] ?? '';
    _loanAmountCtrl.text = d['loan_amount'] ?? '';
    _interestRateCtrl.text = d['interest_rate'] ?? '';
    _installmentsCtrl.text = d['installments'] ?? '';
    _installmentAmountCtrl.text = d['installment_amount'] ?? '';
    _downPaymentCtrl.text = d['down_payment'] ?? '';
    _beginningCtrl.text = d['beginning_amount'] ?? '';
    _refinanceFeeCtrl.text = d['refinance_fee'] ?? '';
    _contractStartDateCtrl.text = d['contract_start_date'] ?? '';
    _paymentDayCtrl.text = d['payment_day'] ?? '';
    _firstPaymentDateCtrl.text = d['first_payment_date'] ?? '';
    _transferFeeCtrl.text = d['transfer_fee'] ?? '';
    _taxFeeCtrl.text = d['tax_fee'] ?? '';
    _dutyFeeCtrl.text = d['duty_fee'] ?? '';
    _loanType = d['loan_type'] ?? '';
    _transferType = d['transfer_type'] ?? 'company_transfer';
    _isLifeInsurance = d['is_life_insurance'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['contract_sign_date'] = _contractSignDateCtrl.text;
    widget.formData['loan_amount'] = _loanAmountCtrl.text;
    widget.formData['interest_rate'] = _interestRateCtrl.text;
    widget.formData['installments'] = _installmentsCtrl.text;
    widget.formData['installment_amount'] = _installmentAmountCtrl.text;
    widget.formData['down_payment'] = _downPaymentCtrl.text;
    widget.formData['beginning_amount'] = _beginningCtrl.text;
    widget.formData['refinance_fee'] = _refinanceFeeCtrl.text;
    widget.formData['contract_start_date'] = _contractStartDateCtrl.text;
    widget.formData['payment_day'] = _paymentDayCtrl.text;
    widget.formData['first_payment_date'] = _firstPaymentDateCtrl.text;
    widget.formData['transfer_fee'] = _transferFeeCtrl.text;
    widget.formData['tax_fee'] = _taxFeeCtrl.text;
    widget.formData['duty_fee'] = _dutyFeeCtrl.text;
    widget.formData['loan_type'] = _loanType;
    widget.formData['transfer_type'] = _transferType;
    widget.formData['is_life_insurance'] = _isLifeInsurance;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === วันที่เซ็นสัญญา ===
          _buildSection(icon: FontAwesomeIcons.calendarDay, title: 'วันที่เซ็นสัญญา', children: [
            _buildDateField('วันที่เซ็นสัญญา', _contractSignDateCtrl),
          ]),
          SizedBox(height: 20.h),

          // === รายละเอียดสัญญา ===
          _buildSection(icon: FontAwesomeIcons.fileLines, title: 'รายละเอียดสัญญา', children: [
            _buildDropdown('ประเภทสินเชื่อ', _loanType, [''], (v) => setState(() => _loanType = v ?? '')),
            _buildTextField('วงเงินกู้', _loanAmountCtrl, keyboardType: TextInputType.number),
            _buildTextField('อัตราดอกเบี้ย (%)', _interestRateCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            _buildTextField('จำนวนงวด', _installmentsCtrl, keyboardType: TextInputType.number),
            _buildTextField('ค่างวด', _installmentAmountCtrl, readOnly: true),
            _buildTextField('เงินดาวน์', _downPaymentCtrl, keyboardType: TextInputType.number),
            _buildTextField('Beginning', _beginningCtrl, keyboardType: TextInputType.number),
            _buildTextField('ค่าธรรมเนียม Refinance', _refinanceFeeCtrl, keyboardType: TextInputType.number),
            _buildDateField('วันเริ่มสัญญา', _contractStartDateCtrl),
            _buildTextField('ชำระทุกวันที่', _paymentDayCtrl, keyboardType: TextInputType.number),
          ]),
          SizedBox(height: 20.h),

          // === เงื่อนไขการชำระเงิน ===
          _buildSection(icon: FontAwesomeIcons.moneyCheckDollar, title: 'เงื่อนไขการชำระเงิน', children: [
            _buildDateField('ชำระงวดแรก', _firstPaymentDateCtrl),
          ]),
          SizedBox(height: 20.h),

          // === โอนเล่มทะเบียน ===
          _buildSection(icon: FontAwesomeIcons.handHoldingDollar, title: 'โอนเล่มทะเบียน', children: [
            _buildRadioGroup('ประเภทโอนเล่ม', _transferType, {
              'company_transfer': 'บริษัทโอน',
              'customer_transfer': 'ลูกค้าโอน',
            }, (v) => setState(() => _transferType = v ?? 'company_transfer')),
            _buildTextField('ค่าโอนเล่มทะเบียน', _transferFeeCtrl, keyboardType: TextInputType.number),
            _buildTextField('ค่าภาษีรถยนต์', _taxFeeCtrl, keyboardType: TextInputType.number),
            _buildTextField('ค่าธรรมเนียมชุดโอน', _dutyFeeCtrl, keyboardType: TextInputType.number),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: navy, width: 3))),
            child: Row(
              children: [
                Container(
                  width: 36.w, height: 36.w,
                  decoration: BoxDecoration(color: navy.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(child: Icon(icon, color: navy, size: 16.sp)),
                ),
                SizedBox(width: 10.w),
                Expanded(child: Text(title, style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600, color: navy))),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool readOnly = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController ctrl) {
    return _buildTextField(label, ctrl, keyboardType: TextInputType.datetime);
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: borderColor, width: 2)),
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

  @override
  void dispose() {
    _saveToFormData();
    _contractSignDateCtrl.dispose();
    _loanAmountCtrl.dispose();
    _interestRateCtrl.dispose();
    _installmentsCtrl.dispose();
    _installmentAmountCtrl.dispose();
    _downPaymentCtrl.dispose();
    _beginningCtrl.dispose();
    _refinanceFeeCtrl.dispose();
    _contractStartDateCtrl.dispose();
    _paymentDayCtrl.dispose();
    _firstPaymentDateCtrl.dispose();
    _transferFeeCtrl.dispose();
    _taxFeeCtrl.dispose();
    _dutyFeeCtrl.dispose();
    super.dispose();
  }
}
