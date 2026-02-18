import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/loan_bloc.dart';
import 'step1_screen.dart';
import 'step2_screen.dart';
import 'step3_screen.dart';
import 'step4_screen.dart';
import 'step5_screen.dart';
import 'step6_screen.dart';
import 'step7_screen.dart';
import 'step8_screen.dart';

/// 📝 Loan Application Screen - หน้าจอหลักสำหรับสร้างคำขอสินเชื่อ
/// ดีไซน์ตรงกับต้นฉบับ Go Web App — 8 ขั้นตอน
class LoanApplicationScreen extends StatefulWidget {
  final String? loanId;

  const LoanApplicationScreen({
    super.key,
    this.loanId,
  });

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {

  // === Colors ตรงกับต้นฉบับ ===
  static const Color navy = Color(0xFF1e3a8a);
  static const Color blue = Color(0xFF1e40af);
  static const Color green = Color(0xFF059669);
  static const Color gray = Color(0xFF6b7280);
  static const Color light = Color(0xFFf8fafc);
  static const Color borderColor = Color(0xFFe2e8f0);
  static const Color red = Color(0xFFdc2626);

  static const int totalSteps = 8;

  late PageController _pageController;
  int _currentStep = 1;
  bool _isEditMode = false;
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isEditMode = widget.loanId != null;
    if (_isEditMode) {
      _loadExistingLoan();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadExistingLoan() {
    // TODO: Implement loading existing loan data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // === Top Header (โลโก้ + ปุ่ม) — ชิดขอบเหมือน Dashboard ===
          _buildTopHeader(),
          // === Title Bar ===
          _buildTitleBar(),

          // === Content ===
          Expanded(
            child: Column(
              children: [
                // === Progress Steps ===
                _buildProgressSteps(),
                // === Step Content ===
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index + 1;
                      });
                    },
                    children: [
                      Step1Screen(formData: _formData, onNext: _nextStep),
                      Step2Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step3Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step4Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step5Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step6Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step7Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                      Step8Screen(formData: _formData, onPrevious: _previousStep, onSubmit: _submitApplication),
                    ],
                  ),
                ),
                // === Bottom Navigation ===
                _buildBottomNavigation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Top Header — ชิดขอบเหมือน Dashboard ===
  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, blue],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // โลโก้ + ปุ่มย้อน
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 16.sp),
                SizedBox(width: 12.w),
                Image.asset(
                  'assets/images/logoml_white.png',
                  height: 36.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          // กระดิ่ง
          Stack(
            children: [
              Icon(FontAwesomeIcons.bell, color: Colors.white, size: 20.sp),
              Positioned(
                top: 0, right: 0,
                child: Container(
                  width: 8.w, height: 8.w,
                  decoration: const BoxDecoration(color: red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === Title Bar ตรงกับต้นฉบับ .title-bar ===
  Widget _buildTitleBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [blue, navy],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // วงกลมไอคอนสีขาว
          Container(
            width: 36.w, height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
            child: Center(
              child: Icon(
                _isEditMode ? FontAwesomeIcons.penToSquare : _getStepFaIcon(_currentStep),
                color: Colors.white,
                size: 15.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            _isEditMode ? 'แก้ไขคำขอสินเชื่อ' : _getStepTitle(_currentStep),
            style: GoogleFonts.kanit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // === Progress Steps ตรงกับต้นฉบับ .steps ===
  Widget _buildProgressSteps() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: light,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompleted = stepNumber < _currentStep;
            final isCurrent = stepNumber == _currentStep;

            return Row(
              children: [
                // Step Circle + Label
                GestureDetector(
                  onTap: stepNumber < _currentStep ? () => _goToStep(stepNumber) : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? blue
                              : isCurrent
                                  ? navy
                                  : const Color(0xFFd1d5db),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCurrent
                                ? navy
                                : isCompleted
                                    ? blue
                                    : const Color(0xFFe5e7eb),
                            width: 3,
                          ),
                          boxShadow: isCurrent
                              ? [BoxShadow(color: navy.withOpacity(0.2), blurRadius: 0, spreadRadius: 6)]
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                              : Text(
                                  '$stepNumber',
                                  style: GoogleFonts.kanit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isCurrent ? Colors.white : const Color(0xFF9ca3af),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 55.w,
                        child: Text(
                          _getShortStepTitle(stepNumber),
                          style: GoogleFonts.kanit(
                            fontSize: 8.sp,
                            fontWeight: (isCurrent || isCompleted) ? FontWeight.w600 : FontWeight.w400,
                            color: (isCurrent || isCompleted) ? blue : gray,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Connection Line
                if (index < totalSteps - 1)
                  Container(
                    width: 16.w,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 18.h),
                    decoration: BoxDecoration(
                      color: isCompleted ? blue : const Color(0xFFd1d5db),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // === Bottom Navigation ตรงกับต้นฉบับ .btn-group ===
  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // ปุ่มย้อนกลับ
            if (_currentStep > 1)
              Expanded(
                child: GestureDetector(
                  onTap: _previousStep,
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: gray,
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 14.sp),
                        SizedBox(width: 10.w),
                        Text('ย้อนกลับ', style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),

            if (_currentStep > 1) SizedBox(width: 16.w),

            // ปุ่มถัดไป/ส่ง
            Expanded(
              child: GestureDetector(
                onTap: _currentStep == totalSteps ? _submitApplication : _nextStep,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: _currentStep == totalSteps ? green : navy,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(color: navy.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == totalSteps ? 'ส่งคำขอ' : 'ถัดไป',
                        style: GoogleFonts.kanit(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        _currentStep == totalSteps ? FontAwesomeIcons.paperPlane : FontAwesomeIcons.arrowRight,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < totalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitApplication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('ยืนยันการส่งคำขอ', style: GoogleFonts.kanit(fontWeight: FontWeight.w600, color: navy)),
        content: Text('คุณต้องการส่งคำขอสินเชื่อนี้หรือไม่?', style: GoogleFonts.kanit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ยกเลิก', style: GoogleFonts.kanit(color: gray)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performSubmission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text('ยืนยัน', style: GoogleFonts.kanit(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _performSubmission() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: Row(
          children: [
            const CircularProgressIndicator(color: navy),
            SizedBox(width: 16.w),
            Text('กำลังส่งคำขอ...', style: GoogleFonts.kanit()),
          ],
        ),
      ),
    );

    context.read<LoanBloc>().add(
      CreateLoanApplication(applicationData: _formData),
    );

    final subscription = context.read<LoanBloc>().stream.listen((state) {
      Navigator.of(context).pop();

      if (state is LoanLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ส่งคำขอสำเร็จ!', style: GoogleFonts.kanit()),
            backgroundColor: green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.of(context).pop();
      } else if (state is LoanError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${state.message}', style: GoogleFonts.kanit()),
            backgroundColor: red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      subscription.cancel();
    });
  }

  IconData _getStepFaIcon(int step) {
    const icons = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.user,
      FontAwesomeIcons.car,
      FontAwesomeIcons.fileContract,
      FontAwesomeIcons.users,
      FontAwesomeIcons.heartPulse,
      FontAwesomeIcons.shieldHalved,
      FontAwesomeIcons.fileInvoiceDollar,
      FontAwesomeIcons.clipboardCheck,
    ];
    return step < icons.length ? icons[step] : FontAwesomeIcons.house;
  }

  String _getStepTitle(int step) {
    const titles = [
      '',
      'ข้อมูลผู้เช่าซื้อ',
      'ข้อมูลรถยนต์',
      'ข้อมูลสัญญา',
      'ข้อมูลผู้ค้ำประกัน',
      'ประกันชีวิต',
      'ประกันภัย',
      'หักภาษี ณ ที่จ่าย',
      'สรุปข้อมูลและยืนยัน',
    ];
    return titles[step];
  }

  String _getShortStepTitle(int step) {
    const titles = [
      '',
      'ผู้เช่าซื้อ',
      'รถยนต์',
      'สัญญา',
      'ค้ำประกัน',
      'ประกันชีวิต',
      'ประกันภัย',
      'หักภาษี',
      'สรุป',
    ];
    return titles[step];
  }
}
