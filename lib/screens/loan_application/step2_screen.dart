import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🚗 Step 2 - ข้อมูลรถยนต์
class Step2Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  static const Color navy = Color(0xFF1e3a8a);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  final _carCodeCtrl = TextEditingController();
  final _carModelCtrl = TextEditingController();
  final _carYearCtrl = TextEditingController();
  final _carWeightCtrl = TextEditingController();
  final _carCCCtrl = TextEditingController();
  final _carMileageCtrl = TextEditingController();
  final _carChassisCtrl = TextEditingController();
  final _carEngineCtrl = TextEditingController();
  final _licensePlateCtrl = TextEditingController();
  final _carPriceCtrl = TextEditingController();
  final _vatRateCtrl = TextEditingController();

  String _carType = '';
  String _carBrand = '';
  String _carColor = '';
  String _carGear = 'Manual';
  String _carCondition = 'OLD';
  String _licenseProvince = '';
  bool _isRefinance = false;

  @override
  void initState() {
    super.initState();
    _loadFromFormData();
  }

  void _loadFromFormData() {
    final d = widget.formData;
    _carCodeCtrl.text = d['car_code'] ?? '';
    _carModelCtrl.text = d['car_model'] ?? '';
    _carYearCtrl.text = d['car_year'] ?? '';
    _carWeightCtrl.text = d['car_weight'] ?? '';
    _carCCCtrl.text = d['car_cc'] ?? '';
    _carMileageCtrl.text = d['car_mileage'] ?? '';
    _carChassisCtrl.text = d['car_chassis_no'] ?? '';
    _carEngineCtrl.text = d['car_engine_no'] ?? '';
    _licensePlateCtrl.text = d['license_plate'] ?? '';
    _carPriceCtrl.text = d['car_price'] ?? '';
    _vatRateCtrl.text = d['vat_rate'] ?? '';
    _carType = d['car_type'] ?? '';
    _carBrand = d['car_brand'] ?? '';
    _carColor = d['car_color'] ?? '';
    _carGear = d['car_gear'] ?? 'Manual';
    _carCondition = d['car_condition'] ?? 'OLD';
    _licenseProvince = d['license_province'] ?? '';
    _isRefinance = d['is_refinance'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['car_code'] = _carCodeCtrl.text;
    widget.formData['car_type'] = _carType;
    widget.formData['car_brand'] = _carBrand;
    widget.formData['car_model'] = _carModelCtrl.text;
    widget.formData['car_year'] = _carYearCtrl.text;
    widget.formData['car_color'] = _carColor;
    widget.formData['car_weight'] = _carWeightCtrl.text;
    widget.formData['car_cc'] = _carCCCtrl.text;
    widget.formData['car_mileage'] = _carMileageCtrl.text;
    widget.formData['car_gear'] = _carGear;
    widget.formData['car_chassis_no'] = _carChassisCtrl.text;
    widget.formData['car_engine_no'] = _carEngineCtrl.text;
    widget.formData['car_condition'] = _carCondition;
    widget.formData['license_plate'] = _licensePlateCtrl.text;
    widget.formData['license_province'] = _licenseProvince;
    widget.formData['vat_rate'] = _vatRateCtrl.text;
    widget.formData['car_price'] = _carPriceCtrl.text;
    widget.formData['is_refinance'] = _isRefinance;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Section: ข้อมูลรถ ===
          _buildSection(
            icon: FontAwesomeIcons.car,
            title: 'ข้อมูลรถ',
            children: [
              _buildTextField('รหัสรถ', _carCodeCtrl, readOnly: true),
              _buildDropdown('ประเภทรถยนต์', _carType, [''], (v) => setState(() => _carType = v ?? '')),
              _buildDropdown('ยี่ห้อ', _carBrand, [''], (v) => setState(() => _carBrand = v ?? '')),
              _buildTextField('รุ่น', _carModelCtrl),
              _buildTextField('ปีรถ', _carYearCtrl, keyboardType: TextInputType.number),
              _buildDropdown('สี', _carColor, [''], (v) => setState(() => _carColor = v ?? '')),
              _buildTextField('น้ำหนักรถ', _carWeightCtrl, keyboardType: TextInputType.number),
              _buildTextField('จำนวน CC', _carCCCtrl, keyboardType: TextInputType.number),
              _buildTextField('เลขไมล์', _carMileageCtrl, keyboardType: TextInputType.number),
              _buildDropdown('ประเภทเกียร์', _carGear, ['Manual', 'Automatic'], (v) => setState(() => _carGear = v ?? 'Manual')),
              _buildTextField('เลขตัวถัง', _carChassisCtrl),
              _buildTextField('เลขเครื่อง', _carEngineCtrl),
              _buildDropdown('สภาพรถ', _carCondition, ['OLD', 'NEW'], (v) => setState(() => _carCondition = v ?? 'OLD')),
              _buildTextField('เลขทะเบียน', _licensePlateCtrl),
            ],
          ),

          SizedBox(height: 20.h),

          // === Section: ภาษีมูลค่าเพิ่ม ===
          _buildSection(
            icon: FontAwesomeIcons.calculator,
            title: 'ภาษีมูลค่าเพิ่ม',
            children: [
              _buildTextField('อัตรา VAT (%)', _vatRateCtrl, keyboardType: TextInputType.number),
              _buildTextField('ราคารถ', _carPriceCtrl, keyboardType: TextInputType.number),
              _buildCheckbox('จำนำ / Refinance', _isRefinance, (v) => setState(() => _isRefinance = v ?? false)),
            ],
          ),
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
          // Section Title
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: navy, width: 3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w, height: 36.w,
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(icon, color: navy, size: 16.sp)),
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

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType, bool readOnly = false}) {
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
            readOnly: readOnly,
            style: GoogleFonts.kanit(fontSize: 14.sp),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFf3f4f6) : Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged, activeColor: navy),
          Text(label, style: GoogleFonts.kanit(fontSize: 14.sp, color: const Color(0xFF4b5563))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _saveToFormData();
    _carCodeCtrl.dispose();
    _carModelCtrl.dispose();
    _carYearCtrl.dispose();
    _carWeightCtrl.dispose();
    _carCCCtrl.dispose();
    _carMileageCtrl.dispose();
    _carChassisCtrl.dispose();
    _carEngineCtrl.dispose();
    _licensePlateCtrl.dispose();
    _carPriceCtrl.dispose();
    _vatRateCtrl.dispose();
    super.dispose();
  }
}
