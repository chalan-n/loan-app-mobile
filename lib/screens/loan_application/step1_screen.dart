import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 1 Screen - ข้อมูลผู้เช่าซื้อ/ผู้กู้
/// จัดการข้อมูลส่วนตัวของผู้กู้ตามระบบเดิม
class Step1Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  const Step1Screen({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idCardController = TextEditingController();
  final _mobilePhoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _otherIncomeController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _tradeRegistrationController = TextEditingController();
  
  // Dropdown values
  String _borrowerType = 'individual';
  String _title = 'นาย';
  String _gender = 'ชาย';
  String _maritalStatus = 'โสด';
  String _ethnicity = 'ไทย';
  String _nationality = 'ไทย';
  String _religion = 'พุทธ';
  String _creditBureauStatus = 'ปกติ';
  String _incomeSource = 'เงินเดือน';
  
  // Date controllers
  final _idCardIssueDateController = TextEditingController();
  final _idCardExpiryDateController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _registrationDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idCardController.dispose();
    _mobilePhoneController.dispose();
    _companyNameController.dispose();
    _occupationController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _otherIncomeController.dispose();
    _taxIdController.dispose();
    _tradeRegistrationController.dispose();
    _idCardIssueDateController.dispose();
    _idCardExpiryDateController.dispose();
    _dateOfBirthController.dispose();
    _registrationDateController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _titleController.text = widget.formData['title'] ?? '';
      _firstNameController.text = widget.formData['first_name'] ?? '';
      _lastNameController.text = widget.formData['last_name'] ?? '';
      _idCardController.text = widget.formData['id_card'] ?? '';
      _mobilePhoneController.text = widget.formData['mobile_phone'] ?? '';
      _companyNameController.text = widget.formData['company_name'] ?? '';
      _occupationController.text = widget.formData['occupation'] ?? '';
      _positionController.text = widget.formData['position'] ?? '';
      _salaryController.text = widget.formData['salary']?.toString() ?? '';
      _otherIncomeController.text = widget.formData['other_income']?.toString() ?? '';
      _taxIdController.text = widget.formData['tax_id'] ?? '';
      _tradeRegistrationController.text = widget.formData['trade_registration_id'] ?? '';
      
      _borrowerType = widget.formData['borrower_type'] ?? 'individual';
      _title = widget.formData['title'] ?? 'นาย';
      _gender = widget.formData['gender'] ?? 'ชาย';
      _maritalStatus = widget.formData['marital_status'] ?? 'โสด';
      _ethnicity = widget.formData['ethnicity'] ?? 'ไทย';
      _nationality = widget.formData['nationality'] ?? 'ไทย';
      _religion = widget.formData['religion'] ?? 'พุทธ';
      _creditBureauStatus = widget.formData['credit_bureau_status'] ?? 'ปกติ';
      _incomeSource = widget.formData['income_source'] ?? 'เงินเดือน';
    }
  }

  void _saveFormData() {
    widget.formData.clear();
    widget.formData.addAll({
      'borrower_type': _borrowerType,
      'title': _title,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'gender': _gender,
      'id_card': _idCardController.text,
      'id_card_issue_date': _idCardIssueDateController.text,
      'id_card_expiry_date': _idCardExpiryDateController.text,
      'date_of_birth': _dateOfBirthController.text,
      'ethnicity': _ethnicity,
      'nationality': _nationality,
      'religion': _religion,
      'marital_status': _maritalStatus,
      'mobile_phone': _mobilePhoneController.text,
      'company_name': _companyNameController.text,
      'occupation': _occupationController.text,
      'position': _positionController.text,
      'salary': double.tryParse(_salaryController.text.replaceAll(',', '')) ?? 0.0,
      'other_income': double.tryParse(_otherIncomeController.text.replaceAll(',', '')) ?? 0.0,
      'income_source': _incomeSource,
      'credit_bureau_status': _creditBureauStatus,
      
      // Juristic fields
      'trade_registration_id': _tradeRegistrationController.text,
      'registration_date': _registrationDateController.text,
      'tax_id': _taxIdController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📋 Borrower Type Selection
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ประเภทผู้กู้',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('บุคคลธรรมดา'),
                          value: 'individual',
                          groupValue: _borrowerType,
                          onChanged: (value) {
                            setState(() {
                              _borrowerType = value!;
                            });
                          },
                          activeColor: AppTheme.sapphireBlue,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('นิติบุคคล'),
                          value: 'juristic',
                          groupValue: _borrowerType,
                          onChanged: (value) {
                            setState(() {
                              _borrowerType = value!;
                            });
                          },
                          activeColor: AppTheme.sapphireBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 👤 Personal Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลส่วนตัว',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title and Name Row
                  Row(
                    children: [
                      // Title
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'คำนำหน้า',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.deepNavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.mediumBlue.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(12),
                                color: AppTheme.pureWhite,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _title,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'นาย', child: Text('นาย')),
                                    DropdownMenuItem(value: 'นาง', child: Text('นาง')),
                                    DropdownMenuItem(value: 'นางสาว', child: Text('นางสาว')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _title = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // First Name
                      Expanded(
                        flex: 4,
                        child: GlassInputField(
                          label: 'ชื่อ',
                          hint: 'กรอกชื่อจริง',
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Last Name
                  GlassInputField(
                    label: 'นามสกุล',
                    hint: 'กรอกนามสกุลจริง',
                    controller: _lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกนามสกุล';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Gender and Marital Status Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'เพศ',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.deepNavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.mediumBlue.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(12),
                                color: AppTheme.pureWhite,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _gender,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'ชาย', child: Text('ชาย')),
                                    DropdownMenuItem(value: 'หญิง', child: Text('หญิง')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สถานะภาพ',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.deepNavy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.mediumBlue.withOpacity(0.3)),
                                borderRadius: BorderRadius.circular(12),
                                color: AppTheme.pureWhite,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _maritalStatus,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'โสด', child: Text('โสด')),
                                    DropdownMenuItem(value: 'สมรส', child: Text('สมรส')),
                                    DropdownMenuItem(value: 'หย่า', child: Text('หย่า')),
                                    DropdownMenuItem(value: 'ม่าย', child: Text('ม่าย')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _maritalStatus = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🆔 Identification Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลบัตรประชาชน',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  GlassInputField(
                    label: 'เลขบัตรประชาชน',
                    hint: 'กรอกเลขบัตรประชาชน 13 หลัก',
                    controller: _idCardController,
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเลขบัตรประชาชน';
                      }
                      if (value.length != 13) {
                        return 'เลขบัตรประชาชนต้องมี 13 หลัก';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'วันออกบัตร',
                          hint: 'DD/MM/YYYY',
                          controller: _idCardIssueDateController,
                          onTap: () => _selectDate(context, _idCardIssueDateController),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'วันหมดอายุ',
                          hint: 'DD/MM/YYYY',
                          controller: _idCardExpiryDateController,
                          onTap: () => _selectDate(context, _idCardExpiryDateController),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  GlassInputField(
                    label: 'วันเกิด',
                    hint: 'DD/MM/YYYY',
                    controller: _dateOfBirthController,
                    onTap: () => _selectDate(context, _dateOfBirthController),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📱 Contact Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลติดต่อ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  GlassInputField(
                    label: 'เบอร์โทรศัพท์มือถือ',
                    hint: 'กรอกเบอร์โทรศัพท์ 10 หลัก',
                    controller: _mobilePhoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกเบอร์โทรศัพท์';
                      }
                      if (value.length != 10) {
                        return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🏢 Work Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ข้อมูลการทำงาน',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  GlassInputField(
                    label: 'ชื่อบริษัท/หน่วยงาน',
                    hint: 'กรอกชื่อบริษัทหรือหน่วยงาน',
                    controller: _companyNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อบริษัท';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'อาชีพ',
                          hint: 'กรอกอาชีพ',
                          controller: _occupationController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอาชีพ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'ตำแหน่ง',
                          hint: 'กรอกตำแหน่ง',
                          controller: _positionController,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'เงินเดือน (บาท)',
                          hint: '0.00',
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเงินเดือน';
                            }
                            final amount = double.tryParse(value.replaceAll(',', ''));
                            if (amount == null || amount <= 0) {
                              return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            // Format currency
                            final cleanValue = value.replaceAll(',', '');
                            if (cleanValue.isNotEmpty) {
                              final number = double.tryParse(cleanValue);
                              if (number != null) {
                                // Don't update here to avoid cursor issues
                                // Format will be applied on focus change
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'รายได้อื่น (บาท)',
                          hint: '0.00',
                          controller: _otherIncomeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.add_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🏢 Juristic Information (แสดงเฉพาะเมื่อเลือกนิติบุคคล)
            if (_borrowerType == 'juristic')
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ข้อมูลนิติบุคคล',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    GlassInputField(
                      label: 'เลขทะเบียนพาณิชย์',
                      hint: 'กรอกเลขทะเบียนพาณิชย์',
                      controller: _tradeRegistrationController,
                      validator: (value) {
                        if (_borrowerType == 'juristic' && (value == null || value.isEmpty)) {
                          return 'กรุณากรอกเลขทะเบียนพาณิชย์';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    GlassInputField(
                      label: 'วันที่จดทะเบียน',
                      hint: 'DD/MM/YYYY',
                      controller: _registrationDateController,
                      onTap: () => _selectDate(context, _registrationDateController),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    GlassInputField(
                      label: 'เลขประจำตัวผู้เสียภาษี',
                      hint: 'กรอกเลขประจำตัวผู้เสียภาษี',
                      controller: _taxIdController,
                      validator: (value) {
                        if (_borrowerType == 'juristic' && (value == null || value.isEmpty)) {
                          return 'กรุณากรอกเลขประจำตัวผู้เสียภาษี';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 40),
            
            // ✅ Validation Summary
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.sapphireBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'กรุณาตรวจสอบข้อมูลให้ครบถ้วนก่อนดำเนินการต่อ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.sapphireBlue,
              onPrimary: AppTheme.pureWhite,
              surface: AppTheme.snowWhite,
              onSurface: AppTheme.deepNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format as DD/MM/YYYY
      final formattedDate = '${picked.day.toString().padLeft(2, '0')}/'
                           '${picked.month.toString().padLeft(2, '0')}/'
                           '${picked.year}';
      controller.text = formattedDate;
    }
  }
}
