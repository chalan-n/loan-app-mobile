import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

/// 🛡️ Step 6 - ประกันภัยรถยนต์
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

  final _notifyNoCtrl = TextEditingController();
  final _notifyDateCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _premiumCtrl = TextEditingController();
  final _beginningCtrl = TextEditingController();
  final _refinanceFeeCtrl = TextEditingController();
  final _avoidanceFeeCtrl = TextEditingController();

  String _insuranceType = '';
  String _insuranceCompany = '';
  String _insuranceClass = '';

  // ─── Reference Data ─────────────────────────────────────
  List<String> _companyNames = [];
  List<String> _classNames = [];

  // ─── File Upload State ──────────────────────────────────
  List<String> _uploadedFiles = [];
  bool _isUploading = false;
  String _uploadError = '';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadFromFormData();
    _loadRefData();
  }

  void _loadFromFormData() {
    final d = widget.formData;
    _insuranceType = d['car_insurance_type'] ?? '';
    _insuranceCompany = d['car_insurance_company'] ?? '';
    _insuranceClass = d['car_insurance_class'] ?? '';
    _notifyNoCtrl.text = d['car_insurance_notify_no'] ?? '';
    _notifyDateCtrl.text = d['car_insurance_notify_date'] ?? '';
    _startDateCtrl.text = d['car_insurance_start_date'] ?? '';
    _premiumCtrl.text = d['car_insurance_premium']?.toString() ?? '';
    _beginningCtrl.text = d['car_insurance_beginning']?.toString() ?? '';
    _refinanceFeeCtrl.text = d['car_insurance_refinance_fee']?.toString() ?? '';
    _avoidanceFeeCtrl.text = d['car_insurance_avoidance_fee']?.toString() ?? '';
    // โหลด filename ที่บันทึกไว้ (comma-separated)
    final saved = d['car_insurance_file']?.toString() ?? '';
    if (saved.isNotEmpty) {
      _uploadedFiles = saved.split(',').where((f) => f.isNotEmpty).toList();
    }
  }

  void _saveToFormData() {
    widget.formData['car_insurance_type'] = _insuranceType;
    widget.formData['car_insurance_company'] = _insuranceCompany;
    widget.formData['car_insurance_class'] = _insuranceClass;
    widget.formData['car_insurance_notify_no'] = _notifyNoCtrl.text;
    widget.formData['car_insurance_notify_date'] = _notifyDateCtrl.text;
    widget.formData['car_insurance_start_date'] = _startDateCtrl.text;
    widget.formData['car_insurance_premium'] = _premiumCtrl.text;
    widget.formData['car_insurance_beginning'] = _beginningCtrl.text;
    widget.formData['car_insurance_refinance_fee'] = _refinanceFeeCtrl.text;
    widget.formData['car_insurance_avoidance_fee'] = _avoidanceFeeCtrl.text;
    widget.formData['car_insurance_file'] = _uploadedFiles.join(',');
  }

  Future<void> _loadRefData() async {
    try {
      final results = await Future.wait([
        ApiService.getInsuComps(),
        ApiService.getInsuClasses(),
      ]);
      if (!mounted) return;
      setState(() {
        final comps = results[0];
        if (comps.isNotEmpty) {
          _companyNames = ['', ...comps.map((e) => e.name)];
        }
        final classes = results[1];
        if (classes.isNotEmpty) {
          _classNames = ['', ...classes.map((e) => e.name)];
        }
      });
    } catch (e) {
      debugPrint('⚠️ [Step6] loadRefData error: $e');
    }
  }

  // ─── File Upload ─────────────────────────────────────────
  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (picked == null) return;

      setState(() {
        _isUploading = true;
        _uploadError = '';
      });

      final result = await ApiService.uploadInsuranceFile(File(picked.path));
      final filename = result['filename'] ?? '';

      setState(() {
        if (filename.isNotEmpty) _uploadedFiles.add(filename);
        _isUploading = false;
      });
      _saveToFormData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8.w),
            Text('อัปโหลดสำเร็จ', style: GoogleFonts.kanit(color: Colors.white)),
          ]),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _deleteFile(String filename) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('ยืนยันการลบ', style: GoogleFonts.kanit(fontWeight: FontWeight.w600)),
        content: Text('ต้องการลบไฟล์นี้ใช่หรือไม่?',
            style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('ยกเลิก', style: GoogleFonts.kanit()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('ลบ',
                style: GoogleFonts.kanit(color: const Color(0xFFdc2626))),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ApiService.deleteInsuranceFile(filename);
      setState(() => _uploadedFiles.remove(filename));
      _saveToFormData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('ลบไฟล์ไม่สำเร็จ: ${e.toString().replaceFirst("Exception: ", "")}',
              style: GoogleFonts.kanit(color: Colors.white)),
          backgroundColor: const Color(0xFFdc2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ));
      }
    }
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w, height: 4.h,
                decoration: BoxDecoration(
                    color: const Color(0xFFe2e8f0),
                    borderRadius: BorderRadius.circular(2.r)),
              ),
              SizedBox(height: 16.h),
              Text('อัปโหลดไฟล์ประกันภัย',
                  style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 16.h),
              Row(children: [
                Expanded(child: _sheetOption(
                  icon: FontAwesomeIcons.camera, label: 'กล้อง',
                  onTap: () { Navigator.pop(context); _pickAndUpload(ImageSource.camera); },
                )),
                SizedBox(width: 12.w),
                Expanded(child: _sheetOption(
                  icon: FontAwesomeIcons.images, label: 'คลังรูปภาพ',
                  onTap: () { Navigator.pop(context); _pickAndUpload(ImageSource.gallery); },
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(children: [
          Icon(icon, color: navy, size: 24.sp),
          SizedBox(height: 8.h),
          Text(label, style: GoogleFonts.kanit(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            icon: FontAwesomeIcons.shieldHalved,
            title: 'ข้อมูลประกันภัยรถยนต์',
            children: [
              _buildDropdown('ประเภทประกัน', _insuranceType,
                  ['', 'ต่อปี', 'ต่ออายุ', 'ใหม่'],
                  (v) => setState(() => _insuranceType = v ?? '')),
              _buildDropdown(
                'บริษัทประกัน',
                _insuranceCompany,
                _companyNames.isEmpty
                    ? ['', 'กรุงเทพประกันภัย', 'ทิพยประกันภัย', 'อาคเนย์ประกันภัย', 'อื่นๆ']
                    : _companyNames,
                (v) => setState(() => _insuranceCompany = v ?? ''),
              ),
              _buildDropdown(
                'ชั้นประกัน',
                _insuranceClass,
                _classNames.isEmpty
                    ? ['', 'ชั้น 1', 'ชั้น 2', 'ชั้น 2+', 'ชั้น 3', 'ชั้น 3+']
                    : _classNames,
                (v) => setState(() => _insuranceClass = v ?? ''),
              ),
              _buildTextField('เลขที่ใบแจ้งงาน', _notifyNoCtrl),
              _buildTextField('วันที่ใบแจ้งงาน', _notifyDateCtrl, isDate: true),
              _buildTextField('วันที่เริ่มคุ้มครอง', _startDateCtrl, isDate: true),
              _buildTextField('เบี้ยประกันภัย', _premiumCtrl,
                  keyboardType: TextInputType.number),
              _buildTextField('ทุนประกัน (เริ่มต้น)', _beginningCtrl,
                  keyboardType: TextInputType.number),
              _buildTextField('ค่าธรรมเนียมการโอน (Refinance)', _refinanceFeeCtrl,
                  keyboardType: TextInputType.number),
              _buildTextField('ค่าธรรมเนียมหลีกเลี่ยง', _avoidanceFeeCtrl,
                  keyboardType: TextInputType.number),
            ],
          ),

          SizedBox(height: 16.h),

          // ─── Section: ไฟล์แนบประกันภัย ────────────────
          _buildSection(
            icon: FontAwesomeIcons.filePdf,
            title: 'ไฟล์แนบประกันภัย',
            children: [
              // ปุ่มอัปโหลด
              GestureDetector(
                onTap: _isUploading ? null : _showUploadSheet,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF1e3a8a), Color(0xFF1e40af)]),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1e3a8a).withOpacity(0.3),
                        blurRadius: 12, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isUploading)
                        SizedBox(
                          width: 18.sp, height: 18.sp,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      else
                        Icon(FontAwesomeIcons.cloudArrowUp,
                            color: Colors.white, size: 18.sp),
                      SizedBox(width: 10.w),
                      Text(
                        _isUploading ? 'กำลังอัปโหลด...' : 'อัปโหลดไฟล์ประกันภัย',
                        style: GoogleFonts.kanit(
                          fontSize: 15.sp, fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Error message
              if (_uploadError.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      child: Text(_uploadError,
                          style: GoogleFonts.kanit(
                              fontSize: 13.sp, color: const Color(0xFFdc2626))),
                    ),
                  ]),
                ),
              ],

              // รายการไฟล์ที่อัปโหลดแล้ว
              if (_uploadedFiles.isNotEmpty) ...[
                SizedBox(height: 12.h),
                ..._uploadedFiles.map((f) => _buildFileItem(f)),
              ] else ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  alignment: Alignment.center,
                  child: Column(children: [
                    Icon(FontAwesomeIcons.fileCirclePlus,
                        color: const Color(0xFFcbd5e1), size: 32.sp),
                    SizedBox(height: 8.h),
                    Text('ยังไม่มีไฟล์แนบ',
                        style: GoogleFonts.kanit(
                            fontSize: 13.sp, color: const Color(0xFF94a3b8))),
                  ]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(String filename) {
    // ตัดชื่อไฟล์ให้สั้นลง แสดงเฉพาะส่วนท้าย
    final shortName = filename.length > 40
        ? '...${filename.substring(filename.length - 37)}'
        : filename;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFdbeafe)),
      ),
      child: Row(children: [
        Icon(FontAwesomeIcons.fileImage, color: navy, size: 16.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(shortName,
              style: GoogleFonts.kanit(fontSize: 13.sp),
              overflow: TextOverflow.ellipsis),
        ),
        GestureDetector(
          onTap: () => _deleteFile(filename),
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFFfef2f2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(Icons.delete_outline,
                color: const Color(0xFFdc2626), size: 16.sp),
          ),
        ),
      ]),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.h),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: navy, width: 3))),
          child: Row(children: [
            Container(
                width: 36.w, height: 36.w,
                decoration: BoxDecoration(
                    color: navy.withOpacity(0.1), shape: BoxShape.circle),
                child: Center(child: Icon(icon, color: navy, size: 16.sp))),
            SizedBox(width: 10.w),
            Text(title,
                style: GoogleFonts.kanit(
                    fontSize: 16.sp, fontWeight: FontWeight.w600, color: navy)),
          ]),
        ),
        SizedBox(height: 16.h),
        ...children,
      ]),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl,
      {TextInputType? keyboardType, bool isDate = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: GoogleFonts.kanit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151))),
        SizedBox(height: 6.h),
        TextField(
          controller: ctrl,
          keyboardType: isDate ? TextInputType.none : keyboardType,
          readOnly: isDate,
          style: GoogleFonts.kanit(fontSize: 14.sp),
          onTap: isDate ? () => _pickDate(ctrl) : null,
          decoration: InputDecoration(
            filled: true, fillColor: Colors.white,
            suffixIcon: isDate
                ? Icon(Icons.calendar_today, color: navy, size: 18.sp)
                : null,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: navy, width: 2)),
          ),
        ),
      ]),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      ValueChanged<String?> onChanged) {
    final safeValue = options.contains(value) ? value : (options.isNotEmpty ? options.first : '');
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: GoogleFonts.kanit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151))),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          value: safeValue,
          items: options
              .map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(o.isEmpty ? '-- เลือก --' : o,
                      style: GoogleFonts.kanit(fontSize: 14.sp))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true, fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: borderColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: navy, width: 2)),
          ),
        ),
      ]),
    );
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('th', 'TH'),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  void dispose() {
    _saveToFormData();
    _notifyNoCtrl.dispose();
    _notifyDateCtrl.dispose();
    _startDateCtrl.dispose();
    _premiumCtrl.dispose();
    _beginningCtrl.dispose();
    _refinanceFeeCtrl.dispose();
    _avoidanceFeeCtrl.dispose();
    super.dispose();
  }
}
