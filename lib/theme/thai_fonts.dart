import 'package:flutter/material.dart';

/// 🇹🇭 Thai Font Configuration สำหรับ Ultra-Luxury Loan App
/// รองรับภาษาไทยและอังกฤษอย่างสมบูรณ์

class ThaiFonts {
  // 📝 Font Families
  static const String inter = 'Inter';           // ภาษาอังกฤษ
  static const String kanit = 'Kanit';           // ภาษาไทยสวยงาม
  static const String sarabun = 'Sarabun';       // ภาษาไทยทางการ
  
  // 🎯 Thai Text Styles สำหรับ Headings
  static TextStyle get thaiHeadline1 => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    fontFamily: kanit,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  static TextStyle get thaiHeadline2 => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    fontFamily: kanit,
    height: 1.3,
    letterSpacing: -0.25,
  );
  
  static TextStyle get thaiHeadline3 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: kanit,
    height: 1.3,
  );
  
  static TextStyle get thaiHeadline4 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
    height: 1.4,
  );
  
  static TextStyle get thaiHeadline5 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
    height: 1.4,
  );
  
  static TextStyle get thaiHeadline6 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: kanit,
    height: 1.4,
  );
  
  // 📋 Thai Text Styles สำหรับ Subheadings
  static TextStyle get thaiSubtitle1 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
    height: 1.4,
  );
  
  static TextStyle get thaiSubtitle2 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
    height: 1.4,
  );
  
  // 📝 Thai Text Styles สำหรับ Body Text
  static TextStyle get thaiBody1 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: sarabun,
    height: 1.5,
  );
  
  static TextStyle get thaiBody2 => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: sarabun,
    height: 1.5,
  );
  
  static TextStyle get thaiBody3 => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: sarabun,
    height: 1.4,
  );
  
  // 🏷️ Thai Text Styles สำหรับ Labels
  static TextStyle get thaiLabel => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
  );
  
  static TextStyle get thaiCaption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: kanit,
  );
  
  // 🔤 Mixed Language Styles (EN + TH)
  static TextStyle get mixedHeading => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: inter,
    height: 1.3,
    package: null,
  );
  
  static TextStyle get mixedBody => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: inter,
    height: 1.5,
    package: null,
  );
}

/// 🎨 Text Utility สำหรับตรวจสอบภาษาและใช้ Font ที่เหมาะสม
class TextUtils {
  /// ตรวจสอบว่า String มีอักขระไทยหรือไม่
  static bool containsThai(String text) {
    return text.contains(RegExp(r'[\u0E00-\u0E7F]'));
  }
  
  /// เลือก Font Family ตามภาษา
  static String getFontFamily(String text, {String? englishFont, String? thaiFont}) {
    return containsThai(text) 
        ? (thaiFont ?? ThaiFonts.sarabun)
        : (englishFont ?? ThaiFonts.inter);
  }
  
  /// สร้าง TextStyle ที่รองรับทั้งไทยและอังกฤษ
  static TextStyle getAdaptiveTextStyle({
    required String text,
    TextStyle? baseStyle,
    String? englishFont,
    String? thaiFont,
  }) {
    final fontFamily = getFontFamily(text, englishFont: englishFont, thaiFont: thaiFont);
    return (baseStyle ?? ThaiFonts.thaiBody1).copyWith(fontFamily: fontFamily);
  }
}

/// 🎯 Adaptive Text Widget สำหรับแสดงข้อความหลายภาษา
class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const AdaptiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final adaptiveStyle = TextUtils.getAdaptiveTextStyle(
      text: text,
      baseStyle: style,
    );
    
    return Text(
      text,
      style: adaptiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// 🇹🇭 Thai Vocabulary Constants
class ThaiVocabulary {
  // 🔐 Authentication
  static const String login = 'เข้าสู่ระบบ';
  static const String username = 'รหัสพนักงาน';
  static const String password = 'รหัสผ่าน';
  static const String forgotPassword = 'ลืมรหัสผ่าน?';
  static const String logout = 'ออกจากระบบ';
  
  // 📊 Dashboard
  static const String dashboard = 'แดชบอร์ด';
  static const String loanApplications = 'คำขอสินเชื่อ';
  static const String newApplication = 'สร้างคำขอใหม่';
  static const String search = 'ค้นหา';
  static const String statistics = 'สถิติ';
  
  // � Forms
  static const String save = 'บันทึก';
  static const String cancel = 'ยกเลิก';
  static const String edit = 'แก้ไข';
  static const String delete = 'ลบ';
  static const String submit = 'ส่ง';
  static const String clear = 'ล้างข้อมูล';
  
  // � Navigation
  static const String home = 'หน้าแรก';
  static const String profile = 'โปรไฟล์';
  static const String settings = 'ตั้งค่า';
  static const String back = 'ย้อนกลับ';
  static const String next = 'ถัดไป';
  static const String previous = 'ก่อนหน้า';
  
  // � Loan Related
  static const String loanAmount = 'จำนวนเงินกู้';
  static const String interestRate = 'อัตราดอกเบี้ย';
  static const String monthlyPayment = 'งวดต่อเดือน';
  static const String totalPayment = 'ยอดรวมทั้งหมด';
  static const String loanTerm = 'ระยะเวลากู้';
  
  // 📋 Status
  static const String pending = 'รอดำเนินการ';
  static const String approved = 'อนุมัติ';
  static const String rejected = 'ปฏิเสธ';
  static const String completed = 'เสร็จสิ้น';
  static const String draft = 'ฉบับร่าง';
  static const String conditional = 'มีเงื่อนไข';
  
  // 📋 Status with prefix (สำหรับ Dashboard)
  static const String statusDraft = 'ฉบับร่าง';
  static const String statusPending = 'รอดำเนินการ';
  static const String statusApproved = 'อนุมัติ';
  static const String statusRejected = 'ปฏิเสธ';
  static const String statusConditional = 'มีเงื่อนไข';
  
  // 🎯 Actions
  static const String view = 'ดูรายละเอียด';
  static const String update = 'อัปเดต';
  static const String create = 'สร้าง';
  static const String confirm = 'ยืนยัน';
  static const String close = 'ปิด';
  
  // � Messages
  static const String success = 'สำเร็จ';
  static const String error = 'ข้อผิดพลาด';
  static const String warning = 'คำเตือน';
  static const String info = 'ข้อมูล';
  static const String loading = 'กำลังโหลด...';
  
  // 📞 Contact
  static const String phone = 'เบอร์โทรศัพท์';
  static const String email = 'อีเมล';
  static const String address = 'ที่อยู่';
  
  // 📅 Date & Time
  static const String today = 'วันนี้';
  static const String yesterday = 'เมื่อวาน';
  static const String thisMonth = 'เดือนนี้';
  static const String thisYear = 'ปีนี้';
  
  // 🏢 Organization
  static const String company = 'บริษัท';
  static const String department = 'แผนก';
  static const String position = 'ตำแหน่ง';
  static const String employeeId = 'รหัสพนักงาน';
  
  // 🎨 UI Elements
  static const String searchHint = 'ค้นหา...';
  static const String noData = 'ไม่มีข้อมูล';
  static const String selectOption = 'เลือกตัวเลือก';
  static const String required = 'กรุณากรอกข้อมูล';
  
  // 🌟 Premium Labels
  static const String premium = 'พรีเมียม';
  static const String exclusive = 'พิเศษ';
  static const String recommended = 'แนะนำ';
  static const String popular = 'ยอดนิยม';
}
