import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../bloc/guarantor_bloc.dart';

/// 👤 Add Individual Guarantor Screen
/// หน้าจอสำหรับเพิ่มผู้ค้ำประกันบุคคลธรรมดา
class AddIndividualGuarantorScreen extends StatefulWidget {
  final String? loanId;
  
  const AddIndividualGuarantorScreen({super.key, this.loanId});

  @override
  State<AddIndividualGuarantorScreen> createState() => _AddIndividualGuarantorScreenState();
}

class _AddIndividualGuarantorScreenState extends State<AddIndividualGuarantorScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  
  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _idCardIssueDateController = TextEditingController();
  final TextEditingController _idCardExpiryDateController = TextEditingController();
  
  // Address Controllers
  final TextEditingController _houseRegNoController = TextEditingController();
  final TextEditingController _houseRegMooController = TextEditingController();
  final TextEditingController _houseRegSoiController = TextEditingController();
  final TextEditingController _houseRegRoadController = TextEditingController();
  final TextEditingController _houseRegTambonController = TextEditingController();
  final TextEditingController _houseRegAmphoeController = TextEditingController();
  final TextEditingController _houseRegProvinceController = TextEditingController();
  final TextEditingController _houseRegPostcodeController = TextEditingController();
  
  // Work Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _otherIncomeController = TextEditingController();
  final TextEditingController _workPhoneController = TextEditingController();
  final TextEditingController _workNoController = TextEditingController();
  final TextEditingController _workMooController = TextEditingController();
  final TextEditingController _workSoiController = TextEditingController();
  final TextEditingController _workRoadController = TextEditingController();
  final TextEditingController _workTambonController = TextEditingController();
  final TextEditingController _workAmphoeController = TextEditingController();
  final TextEditingController _workProvinceController = TextEditingController();
  final TextEditingController _workPostcodeController = TextEditingController();
  
  // Dropdown Values
  String? _selectedTitle;
  String? _selectedGender;
  String? _selectedEthnicity;
  String? _selectedNationality;
  String? _selectedReligion;
  String? _selectedMaritalStatus;
  String? _selectedIncomeSource;
  bool _sameAsHouseReg = false;

  @override
  void initState() {
    super.initState();
    _selectedTitle = 'นาย';
    _selectedGender = 'ชาย';
    _selectedEthnicity = 'ไทย';
    _selectedNationality = 'ไทย';
    _selectedReligion = 'พุทธ';
    _selectedMaritalStatus = 'โสด';
    _selectedIncomeSource = 'เงินเดือน';
  }

  @override
  void dispose() {
    // Dispose all controllers
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idCardController.dispose();
    _mobilePhoneController.dispose();
    _dateOfBirthController.dispose();
    _idCardIssueDateController.dispose();
    _idCardExpiryDateController.dispose();
    _houseRegNoController.dispose();
    _houseRegMooController.dispose();
    _houseRegSoiController.dispose();
    _houseRegRoadController.dispose();
    _houseRegTambonController.dispose();
    _houseRegAmphoeController.dispose();
    _houseRegProvinceController.dispose();
    _houseRegPostcodeController.dispose();
    _companyNameController.dispose();
    _occupationController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _otherIncomeController.dispose();
    _workPhoneController.dispose();
    _workNoController.dispose();
    _workMooController.dispose();
    _workSoiController.dispose();
    _workRoadController.dispose();
    _workTambonController.dispose();
    _workAmphoeController.dispose();
    _workProvinceController.dispose();
    _workPostcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: const Text(
          'เพิ่มผู้ค้ำประกัน (บุคคลธรรมดา)',
          style: TextStyle(
            color: AppTheme.deepNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.snowWhite,
        foregroundColor: AppTheme.deepNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.deepNavy),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<GuarantorBloc, GuarantorState>(
        listener: (context, state) {
          if (state is GuarantorOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successGreen,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is GuarantorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📋 Header
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: AppTheme.sapphireBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ข้อมูลส่วนตัวผู้ค้ำประกัน',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'กรุณากรอกข้อมูลให้ครบถ้วนและถูกต้อง',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
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
                          fontWeight: FontWeight.w600,
                          color: AppTheme.sapphireBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Title and Name Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedTitle,
                              decoration: const InputDecoration(
                                labelText: 'คำนำหน้า',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'นาย', child: Text('นาย')),
                                DropdownMenuItem(value: 'นาง', child: Text('นาง')),
                                DropdownMenuItem(value: 'นางสาว', child: Text('นางสาว')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedTitle = value;
                                  _formData['title'] = value;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            flex: 2,
                            child: GlassInputField(
                              controller: _firstNameController,
                              label: 'ชื่อ',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['first_name'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Last Name
                      GlassInputField(
                        controller: _lastNameController,
                        label: 'นามสกุล',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกนามสกุล';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formData['last_name'] = value;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Gender and DOB Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'เพศ',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'ชาย', child: Text('ชาย')),
                                DropdownMenuItem(value: 'หญิง', child: Text('หญิง')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  _formData['gender'] = value;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _dateOfBirthController,
                              label: 'วันเกิด (DD/MM/YYYY)',
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  _dateOfBirthController.text = 
                                    '${date.day.toString().padLeft(2, '0')}/'
                                    '${date.month.toString().padLeft(2, '0')}/'
                                    '${date.year + 543}';
                                  _formData['date_of_birth'] = _dateOfBirthController.text;
                                }
                              },
                              onChanged: (value) {
                                _formData['date_of_birth'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // ID Card
                      GlassInputField(
                        controller: _idCardController,
                        label: 'เลขบัตรประชาชน',
                        maxLength: 13,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกเลขบัตรประชาชน';
                          }
                          if (value.length != 13) {
                            return 'เลขบัตรประชาชนต้องมี 13 หลัก';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formData['id_card'] = value;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Mobile Phone
                      GlassInputField(
                        controller: _mobilePhoneController,
                        label: 'เบอร์โทรศัพท์มือถือ',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกเบอร์โทรศัพท์';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formData['mobile_phone'] = value;
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 🏠 Address Information
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ที่อยู่ตามทะเบียนบ้าน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.sapphireBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Address Fields
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegNoController,
                              label: 'เลขที่',
                              onChanged: (value) {
                                _formData['house_reg_no'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegMooController,
                              label: 'หมู่ที่',
                              onChanged: (value) {
                                _formData['house_reg_moo'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegSoiController,
                              label: 'ซอย',
                              onChanged: (value) {
                                _formData['house_reg_soi'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegRoadController,
                              label: 'ถนน',
                              onChanged: (value) {
                                _formData['house_reg_road'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegTambonController,
                              label: 'ตำบล',
                              onChanged: (value) {
                                _formData['house_reg_tambon'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegAmphoeController,
                              label: 'อำเภอ',
                              onChanged: (value) {
                                _formData['house_reg_amphoe'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'จังหวัด',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'กรุงเทพมหานคร', child: Text('กรุงเทพมหานคร')),
                                DropdownMenuItem(value: 'นนทบุรี', child: Text('นนทบุรี')),
                                DropdownMenuItem(value: 'ปทุมธานี', child: Text('ปทุมธานี')),
                                DropdownMenuItem(value: 'สมุทรปราการ', child: Text('สมุทรปราการ')),
                              ],
                              onChanged: (value) {
                                _formData['house_reg_province'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _houseRegPostcodeController,
                              label: 'รหัสไปรษณีย์',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _formData['house_reg_postcode'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 💼 Work Information
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลการทำงาน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.sapphireBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Company Name
                      GlassInputField(
                        controller: _companyNameController,
                        label: 'ชื่อบริษัท',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อบริษัท';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formData['company_name'] = value;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _occupationController,
                              label: 'อาชีพ',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกอาชีพ';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['occupation'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _positionController,
                              label: 'ตำแหน่ง',
                              onChanged: (value) {
                                _formData['position'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _salaryController,
                              label: 'เงินเดือน (บาท)',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกเงินเดือน';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['salary'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _otherIncomeController,
                              label: 'รายได้อื่น (บาท)',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _formData['other_income'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Income Source
                      DropdownButtonFormField<String>(
                        value: _selectedIncomeSource,
                        decoration: const InputDecoration(
                          labelText: 'แหล่งที่มาของรายได้',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'เงินเดือน', child: Text('เงินเดือน')),
                          DropdownMenuItem(value: 'ธุรกิจส่วนตัว', child: Text('ธุรกิจส่วนตัว')),
                          DropdownMenuItem(value: 'ลงทุน', child: Text('ลงทุน')),
                          DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedIncomeSource = value;
                            _formData['income_source'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 📄 Terms and Conditions
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.gavel,
                            color: AppTheme.sapphireBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ข้อตกลงและเงื่อนไข',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.sapphireBlue,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      CheckboxListTile(
                        value: _formData['terms_accepted'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _formData['terms_accepted'] = value;
                          });
                        },
                        title: const Text('ข้าพเจ้ายอมรับเงื่อนไขและข้อตกลง'),
                        subtitle: const Text('โดยข้าพเจ้าขอรับรองว่าข้อมูลทั้งหมดเป็นความจริง'),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppTheme.sapphireBlue,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // 🎯 Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.deepNavy),
                          foregroundColor: AppTheme.deepNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('ยกเลิก'),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: GlassButton(
                        text: 'บันทึกข้อมูล',
                        onPressed: _submitForm,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_formData['terms_accepted'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณายอมรับเงื่อนไขและข้อตกลง'),
            backgroundColor: AppTheme.warningAmber,
          ),
        );
        return;
      }
      
      // Prepare guarantor data
      final guarantorData = {
        'loan_id': widget.loanId ?? '1',
        'guarantor_type': 'individual',
        'title': _selectedTitle,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'gender': _selectedGender,
        'id_card': _idCardController.text,
        'date_of_birth': _dateOfBirthController.text,
        'mobile_phone': _mobilePhoneController.text,
        'house_reg_no': _houseRegNoController.text,
        'house_reg_moo': _houseRegMooController.text,
        'house_reg_soi': _houseRegSoiController.text,
        'house_reg_road': _houseRegRoadController.text,
        'house_reg_tambon': _houseRegTambonController.text,
        'house_reg_amphoe': _houseRegAmphoeController.text,
        'house_reg_province': _houseRegProvinceController.text,
        'house_reg_postcode': _houseRegPostcodeController.text,
        'company_name': _companyNameController.text,
        'occupation': _occupationController.text,
        'position': _positionController.text,
        'salary': double.tryParse(_salaryController.text) ?? 0.0,
        'other_income': double.tryParse(_otherIncomeController.text) ?? 0.0,
        'income_source': _selectedIncomeSource,
        'sync_status': 'pending',
      };
      
      // Add guarantor
      context.read<GuarantorBloc>().add(AddGuarantor(guarantorData));
    }
  }
}
