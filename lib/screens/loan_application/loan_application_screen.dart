import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../bloc/loan_bloc.dart';
import 'step1_screen.dart';
import 'step2_screen.dart';
import 'step3_screen.dart';
import 'step4_screen.dart';
import 'step5_screen.dart';
import 'step6_screen.dart';
import 'step7_screen.dart';

/// 📝 Loan Application Screen - หน้าจอหลักสำหรับสร้างคำขอสินเชื่อ
/// จัดการการทำงาน 7 Steps ตามระบบเดิม
class LoanApplicationScreen extends StatefulWidget {
  final String? loanId; // สำหรับ Edit Mode
  
  const LoanApplicationScreen({
    super.key,
    this.loanId,
  });

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  
  int _currentStep = 1;
  bool _isEditMode = false;
  
  // Form Data ที่จะส่งข้าม Steps
  final Map<String, dynamic> _formData = {};
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 1.0 / 7.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    _isEditMode = widget.loanId != null;
    if (_isEditMode) {
      // TODO: Load existing loan data
      _loadExistingLoan();
    }
    
    _progressController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _loadExistingLoan() {
    // TODO: Implement loading existing loan data
    // context.read<LoanBloc>().add(LoadLoanApplication(widget.loanId!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 📊 Progress Bar
          _buildProgressBar(),
          
          // 📝 Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // ป้องกัน swipe
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index + 1;
                });
                _updateProgress();
              },
              children: [
                Step1Screen(formData: _formData, onNext: _nextStep),
                Step2Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                Step3Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                Step4Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                Step5Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                Step6Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep),
                Step7Screen(formData: _formData, onNext: _nextStep, onPrevious: _previousStep, onSubmit: _submitApplication),
              ],
            ),
          ),
          
          // 🎯 Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        children: [
          Text(
            _isEditMode ? 'แก้ไขคำขอสินเชื่อ' : 'สร้างคำขอสินเชื่อ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'ขั้นตอนที่ $_currentStep จาก 7',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.snowWhite,
      foregroundColor: AppTheme.deepNavy,
      elevation: 0,
      actions: [
        if (_currentStep > 1)
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'บันทึกร่าง',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.sapphireBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Step Indicators
          Row(
            children: List.generate(7, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < _currentStep;
              final isCurrent = stepNumber == _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    // Step Circle
                    GestureDetector(
                      onTap: stepNumber < _currentStep ? () => _goToStep(stepNumber) : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted 
                            ? AppTheme.successGreen
                            : isCurrent 
                              ? AppTheme.sapphireBlue
                              : AppTheme.lightGray,
                          borderRadius: BorderRadius.circular(16),
                          border: isCurrent 
                            ? Border.all(color: AppTheme.sapphireBlue, width: 2)
                            : null,
                          boxShadow: isCurrent 
                            ? PremiumShadows.buttonShadow
                            : null,
                        ),
                        child: Center(
                          child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: AppTheme.pureWhite,
                              )
                            : Text(
                                '$stepNumber',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isCurrent 
                                    ? AppTheme.pureWhite
                                    : AppTheme.mediumGray,
                                ),
                              ),
                        ),
                      ),
                    ),
                    
                    // Progress Line
                    if (index < 6)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isCompleted 
                              ? AppTheme.successGreen
                              : AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 16),
          
          // Progress Bar Animation
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.sapphireBlue, AppTheme.deepNavy],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 8),
          
          // Step Title
          Text(
            _getStepTitle(_currentStep),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.deepNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.snowWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepNavy.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous Button
            if (_currentStep > 1)
              Expanded(
                child: GlassButton(
                  text: 'ก่อนหน้า',
                  onPressed: _previousStep,
                  icon: Icons.arrow_back,
                ),
              ),
            
            if (_currentStep > 1) const SizedBox(width: 12),
            
            // Next/Submit Button
            Expanded(
              child: GlassButton(
                text: _currentStep == 7 ? 'ส่งคำขอ' : 'ถัดไป',
                onPressed: _currentStep == 7 ? _submitApplication : _nextStep,
                icon: _currentStep == 7 ? Icons.send : Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 7) {
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

  void _updateProgress() {
    _progressController.animateTo(
      _currentStep / 7.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _saveDraft() {
    // TODO: Implement save draft functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('บันทึกร่างสำเร็จ'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _submitApplication() {
    // TODO: Validate all steps before submission
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการส่งคำขอ'),
        content: const Text('คุณต้องการส่งคำขอสินเชื่อนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          GlassButton(
            text: 'ยืนยัน',
            onPressed: () {
              Navigator.of(context).pop();
              _performSubmission();
            },
          ),
        ],
      ),
    );
  }

  void _performSubmission() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('กำลังส่งคำขอ...'),
          ],
        ),
      ),
    );

    // Submit application
    context.read<LoanBloc>().add(
      CreateLoanApplication(applicationData: _formData),
    );

    // Listen for result
    final subscription = context.read<LoanBloc>().stream.listen((state) {
      Navigator.of(context).pop(); // Close loading dialog
      
      if (state is LoanLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ส่งคำขอสำเร็จ!'),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        // Navigate back to dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else if (state is LoanError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${state.message}'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    // Clean up subscription
    Future.delayed(const Duration(seconds: 5), () {
      subscription.cancel();
    });
  }

  String _getStepTitle(int step) {
    const titles = [
      '',
      'ข้อมูลผู้เช่าซื้อ',
      'ที่อยู่ตามทะเบียนบ้าน',
      'ที่อยู่ปัจจุบัน',
      'ที่อยู่ที่ทำงาน',
      'ข้อมูลผู้กู้และรายได้',
      'ข้อมูลรถยนต์',
      'สรุปข้อมูล',
    ];
    return titles[step];
  }
}
