import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// ✅ Step 8 - สรุปข้อมูลและยืนยัน
class Step8Screen extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const Step8Screen({super.key, required this.formData, required this.onPrevious, required this.onSubmit});

  static const Color navy = Color(0xFF1e3a8a);
  static const Color blue = Color(0xFF1e40af);
  static const Color green = Color(0xFF059669);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Header ===
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [navy, blue]),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(FontAwesomeIcons.clipboardCheck, color: Colors.white, size: 32.sp),
                SizedBox(height: 12.h),
                Text('สรุปข้อมูลคำขอสินเชื่อ', style: GoogleFonts.kanit(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white)),
                SizedBox(height: 4.h),
                Text('กรุณาตรวจสอบข้อมูลก่อนส่ง', style: GoogleFonts.kanit(fontSize: 13.sp, color: Colors.white70)),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // === Step 1: ผู้เช่าซื้อ ===
          _buildSummarySection(FontAwesomeIcons.user, 'ข้อมูลผู้เช่าซื้อ', {
            'คำนำหน้า': formData['prefix'] ?? '-',
            'ชื่อ': formData['first_name'] ?? '-',
            'นามสกุล': formData['last_name'] ?? '-',
            'เลขบัตรประชาชน': formData['id_card'] ?? '-',
            'เบอร์โทร': formData['phone'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 2: รถยนต์ ===
          _buildSummarySection(FontAwesomeIcons.car, 'ข้อมูลรถยนต์', {
            'รหัสรถ': formData['car_code'] ?? '-',
            'ยี่ห้อ': formData['car_brand'] ?? '-',
            'รุ่น': formData['car_model'] ?? '-',
            'ปีรถ': formData['car_year'] ?? '-',
            'ราคารถ': formData['car_price'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 3: สัญญา ===
          _buildSummarySection(FontAwesomeIcons.fileContract, 'ข้อมูลสัญญา', {
            'วงเงินกู้': formData['loan_amount'] ?? '-',
            'อัตราดอกเบี้ย': '${formData['interest_rate'] ?? '-'}%',
            'จำนวนงวด': formData['installments'] ?? '-',
            'ค่างวด': formData['installment_amount'] ?? '-',
            'เงินดาวน์': formData['down_payment'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 4: ค้ำประกัน ===
          _buildSummarySection(FontAwesomeIcons.users, 'ข้อมูลผู้ค้ำประกัน', {
            'ชื่อ-นามสกุล': formData['guarantor_name'] ?? '-',
            'ความสัมพันธ์': formData['guarantor_relation'] ?? '-',
            'เบอร์โทร': formData['guarantor_phone'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 5: ประกันชีวิต ===
          _buildSummarySection(FontAwesomeIcons.heartPulse, 'ประกันชีวิต', {
            'ทำประกัน': (formData['has_life_insurance'] == true) ? 'ใช่' : 'ไม่',
            'ค่าเบี้ย': formData['life_premium'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 6: ประกันภัย ===
          _buildSummarySection(FontAwesomeIcons.shieldHalved, 'ประกันภัย', {
            'ทำประกัน': (formData['has_car_insurance'] == true) ? 'ใช่' : 'ไม่',
            'เบี้ยประกันภัย': formData['car_insurance_premium'] ?? '-',
          }),
          SizedBox(height: 16.h),

          // === Step 7: หักภาษี ===
          _buildSummarySection(FontAwesomeIcons.fileInvoiceDollar, 'หักภาษี ณ ที่จ่าย', {
            'หักภาษี': (formData['has_withholding_tax'] == true) ? 'ใช่' : 'ไม่',
            'ยอดจ่ายสุทธิ': formData['net_payment'] ?? '-',
          }),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildSummarySection(IconData icon, String title, Map<String, String> data) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: navy, width: 3))),
            child: Row(
              children: [
                Container(
                  width: 32.w, height: 32.w,
                  decoration: BoxDecoration(color: navy.withOpacity(0.1), shape: BoxShape.circle),
                  child: Center(child: Icon(icon, color: navy, size: 14.sp)),
                ),
                SizedBox(width: 8.w),
                Text(title, style: GoogleFonts.kanit(fontSize: 14.sp, fontWeight: FontWeight.w600, color: navy)),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Data Rows
          ...data.entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120.w,
                  child: Text(e.key, style: GoogleFonts.kanit(fontSize: 12.sp, color: const Color(0xFF6b7280))),
                ),
                Expanded(
                  child: Text(
                    e.value.isEmpty ? '-' : e.value,
                    style: GoogleFonts.kanit(fontSize: 13.sp, fontWeight: FontWeight.w500, color: const Color(0xFF1e293b)),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
