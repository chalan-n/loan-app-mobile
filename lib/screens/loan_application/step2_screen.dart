import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

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

// Animated Section Widget
class AnimatedSection extends StatefulWidget {
  final bool isVisible;
  final Widget child;
  final Duration duration;

  const AnimatedSection({
    super.key,
    required this.isVisible,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start from below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
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
  final _carRegDateCtrl = TextEditingController();
  final _carPriceCtrl = TextEditingController();
  final _vatRateCtrl = TextEditingController();

  String _carType = '';
  String _carBrand = '';
  String _carColor = '';
  String _carGear = 'Manual';
  String _carCondition = 'เก่า';
  String _licenseProvince = '';
  bool _isRefinance = false;
  
  // Animation controllers
  bool _showCarInfoSection = false;
  bool _showVatSection = false;

  // ─── OCR State ─────────────────────────────────────────────
  bool _isOcrLoading = false;
  String _ocrError = '';
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carCodeCtrl.addListener(() => setState(() {}));
    _loadFromFormData();
    _startAnimations();
  }

  void _startAnimations() {
    // เริ่มแสดง Card แรกทันที
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showCarInfoSection = true;
        });
      }
    });
    
    // เริ่มแสดง Card ที่สองหลังจาก Card แรก 300ms
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _showVatSection = true;
        });
      }
    });
  }

  // ─── OCR เล่มทะเบียนรถ ────────────────────────────────
  Future<void> _scanVehicleBook(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (picked == null) return;

      setState(() {
        _isOcrLoading = true;
        _ocrError = '';
      });

      final result = await ApiService.ocrVehicleBook(File(picked.path));

      setState(() {
        // auto-fill ข้อมูลรถ
        if (result.vehicleBrand.isNotEmpty) _carBrand = result.vehicleBrand;
        if (result.color.isNotEmpty) _carColor = result.color;
        if (result.chassisNumber.isNotEmpty) _carChassisCtrl.text = result.chassisNumber;
        if (result.engineNumber.isNotEmpty) _carEngineCtrl.text = result.engineNumber;
        if (result.modelYear != 0) _carYearCtrl.text = result.modelYear.toString();
        if (result.engineCC != 0) _carCCCtrl.text = result.engineCC.toString();
        if (result.carWeight != 0) _carWeightCtrl.text = result.carWeight.toString();
        if (result.plateNumber.isNotEmpty) _licensePlateCtrl.text = result.plateNumber;
        if (result.province.isNotEmpty) _licenseProvince = result.province;
        if (result.registrationDate.isNotEmpty) _carRegDateCtrl.text = result.registrationDate;

        _isOcrLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'OCR สำเร็จ — กรุณาตรวจสอบข้อมูล',
                  style: GoogleFonts.kanit(color: Colors.white),
                ),
              ),
            ]),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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

  // ─── แสดง bottom sheet เลือกแหล่งรูป ─────────────────
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
                  style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600)),
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
          border: Border.all(color: const Color(0xFFe2e8f0), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: navy, size: 24.sp),
            SizedBox(height: 8.h),
            Text(label,
                style: GoogleFonts.kanit(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ─── OCR Button Widget ─────────────────────────────────
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
    _carRegDateCtrl.text = d['car_reg_date'] ?? '';
    _carPriceCtrl.text = d['car_price'] ?? '';
    _vatRateCtrl.text = d['vat_rate'] ?? '';
    _carType = d['car_type'] ?? '';
    _carBrand = d['car_brand'] ?? '';
    _carColor = d['car_color'] ?? '';
    _carGear = d['car_gear'] ?? 'Manual';
    _carCondition = d['car_condition'] ?? 'เก่า';
    _licenseProvince = d['license_province'] ?? '';
    _isRefinance = d['is_refinance'] ?? false;
  }

  void _saveToFormData() {
    widget.formData['car_code'] = _carCodeCtrl.text;
    widget.formData['car_type'] = _carType;
    widget.formData['car_brand'] = _carBrand;
    widget.formData['car_reg_date'] = _carRegDateCtrl.text;
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

  void _searchCar() async {
    final code = _carCodeCtrl.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกรหัสรถเพื่อค้นหา'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await ApiService.searchCarData(code);
      if (res['success'] == true && res['car'] != null) {
        final car = res['car'];
        setState(() {
          _carModelCtrl.text = car['car_model']?.toString() ?? '';
          _carYearCtrl.text = car['car_year']?.toString() ?? '';
          _carWeightCtrl.text = car['car_weight']?.toString() ?? '';
          _carCCCtrl.text = car['car_cc']?.toString() ?? '';
          _carMileageCtrl.text = car['car_mileage']?.toString() ?? '';
          _carChassisCtrl.text = car['car_chassis_no']?.toString() ?? '';
          _carEngineCtrl.text = car['car_engine_no']?.toString() ?? '';
          _licensePlateCtrl.text = car['license_plate']?.toString() ?? '';
          _carRegDateCtrl.text = car['car_reg_date']?.toString() ?? '';
          _carPriceCtrl.text = car['car_price']?.toString() ?? '';
          
          if (car['car_type'] != null) _carType = car['car_type'];
          if (car['car_brand'] != null) _carBrand = car['car_brand'];
          if (car['car_color'] != null) _carColor = car['car_color'];
          if (car['car_gear'] != null) _carGear = car['car_gear'];
          if (car['car_condition'] != null) _carCondition = car['car_condition'];
          if (car['license_province'] != null) _licenseProvince = car['license_province'];
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('พบข้อมูลรถยนต์'), backgroundColor: Colors.green),
          );
        }
      } else {
        throw Exception('ไม่พบข้อมูลรถยนต์รหัส: $code');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Section: ข้อมูลรถ ===
          AnimatedSection(
            isVisible: _showCarInfoSection,
            child: _buildSection(
              icon: FontAwesomeIcons.car,
              title: 'ข้อมูลรถ',
              children: [
                // ─── ปุ่ม OCR เล่มทะเบียนรถ ──────────────
                _ocrButton(
                  label: 'สแกนเล่มทะเบียนรถ (AI)',
                  icon: FontAwesomeIcons.bookOpen,
                  onTap: () => _showImageSourceSheet(_scanVehicleBook),
                ),
                if (_ocrError.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFfef2f2),
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: const Color(0xFFfca5a5)),
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
                // ─── ฟิลด์ข้อมูลรถ ────────────────────────
                _buildTextField('รหัสรถ', _carCodeCtrl, isUppercase: true),
                // ปุ่มค้นหาจากรหัสรถ
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isLoading || _carCodeCtrl.text.trim().length < 7) 
                          ? null 
                          : _searchCar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _carCodeCtrl.text.trim().length >= 7 ? navy : const Color(0xFFe2e8f0),
                        foregroundColor: _carCodeCtrl.text.trim().length >= 7 ? Colors.white : const Color(0xFF6b7280),
                        disabledBackgroundColor: const Color(0xFFe2e8f0),
                        disabledForegroundColor: const Color(0xFF6b7280),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isLoading 
                        ? SizedBox(
                            width: 20.w, 
                            height: 20.w, 
                            child: const CircularProgressIndicator(color: navy, strokeWidth: 2)
                          )
                        : Text('ค้นหา',
                            style: GoogleFonts.kanit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                _buildDropdown('ประเภทรถยนต์', _carType,
                    ['', 'รถเก๋ง', 'รถกระบะ', 'รถตู้', 'รถจักรยานยนต์', 'อื่นๆ'],
                    (v) => setState(() => _carType = v ?? '')),
                _buildDropdown('ยี่ห้อ', _carBrand,
                    ['', 'Toyota', 'Honda', 'Isuzu', 'Mitsubishi',
                     'Nissan', 'Mazda', 'Ford', 'Suzuki', 'อื่นๆ'],
                    (v) => setState(() => _carBrand = v ?? '')),
                _buildTextField('วันจดทะเบียน', _carRegDateCtrl, isDate: true),
                _buildTextField('รุ่น', _carModelCtrl),
                _buildTextField('ปีรถ', _carYearCtrl, keyboardType: TextInputType.number),
                _buildDropdown('สี', _carColor,
                    ['', 'ขาว', 'ดำ', 'เทา', 'เงิน', 'แดง', 'น้ำเงิน',
                     'น้ำตาล', 'ชมพู', 'อื่นๆ'],
                    (v) => setState(() => _carColor = v ?? '')),
                _buildTextField('น้ำหนักรถ', _carWeightCtrl, keyboardType: TextInputType.number),
                _buildTextField('จำนวน cc', _carCCCtrl, keyboardType: TextInputType.number),
                _buildTextField('เลขไมล์', _carMileageCtrl, keyboardType: TextInputType.number),
                _buildDropdown('ประเภทเกียร์', _carGear,
                    ['Manual', 'Automatic'],
                    (v) => setState(() => _carGear = v ?? 'Manual')),
                _buildTextField('เลขตัวถัง', _carChassisCtrl),
                _buildTextField('เลขเครื่อง', _carEngineCtrl),
                _buildDropdown('สภาพรถ', _carCondition,
                    ['เก่า', 'ใหม่'],
                    (v) => setState(() => _carCondition = v ?? 'เก่า')),
                _buildTextField('เลขทะเบียน', _licensePlateCtrl),
                _buildDropdown('จังหวัด', _licenseProvince,
                    ['', 'กรุงเทพมหานคร', 'เชียงใหม่', 'นนทบุรี',
                     'ชลบุรี', 'ขอนแก่น', 'อื่นๆ'],
                    (v) => setState(() => _licenseProvince = v ?? '')),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // === Section: ภาษีมูลค่าเพิ่ม ===
          AnimatedSection(
            isVisible: _showVatSection,
            child: _buildSection(
              icon: FontAwesomeIcons.calculator,
              title: 'ภาษีมูลค่าเพิ่ม',
              children: [
                _buildTextField('ภาษีมูลค่าเพิ่ม', _vatRateCtrl, keyboardType: TextInputType.number),
                _buildTextField('ราคารถ', _carPriceCtrl, keyboardType: TextInputType.number),
                _buildCheckbox('จำนำ/ Refinance', _isRefinance, (v) => setState(() => _isRefinance = v ?? false)),
              ],
            ),
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
                    color: navy.withValues(alpha: 0.1),
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

  Widget _buildTextField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType, bool readOnly = false, bool isDate = false, bool isUppercase = false}) {
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
            readOnly: readOnly || isDate,
            textCapitalization: isUppercase ? TextCapitalization.characters : TextCapitalization.none,
            inputFormatters: isUppercase ? [UpperCaseTextFormatter()] : null,
            onTap: isDate
                ? () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      ctrl.text =
                          '${picked.day.toString().padLeft(2, '0')}'
                          '/${picked.month.toString().padLeft(2, '0')}'
                          '/${picked.year}';
                    }
                  }
                : null,
            style: GoogleFonts.kanit(fontSize: 14.sp),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFf3f4f6) : Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              suffixIcon: isDate
                  ? const Icon(Icons.calendar_today, size: 18)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: borderColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: borderColor, width: 2),
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
    _carRegDateCtrl.dispose();
    _carPriceCtrl.dispose();
    _vatRateCtrl.dispose();
    super.dispose();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
