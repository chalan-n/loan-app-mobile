import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../bloc/guarantor_bloc.dart';

/// 🏢 Add Juristic Guarantor Screen
/// หน้าจอสำหรับเพิ่มผู้ค้ำประกันนิติบุคคล
class AddJuristicGuarantorScreen extends StatefulWidget {
  final String? loanId;
  
  const AddJuristicGuarantorScreen({super.key, this.loanId});

  @override
  State<AddJuristicGuarantorScreen> createState() => _AddJuristicGuarantorScreenState();
}

class _AddJuristicGuarantorScreenState extends State<AddJuristicGuarantorScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  
  // Company Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _tradeRegistrationIdController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _registrationDateController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _companyMobileController = TextEditingController();
  
  // Representative Controllers
  final TextEditingController _repTitleController = TextEditingController();
  final TextEditingController _repFirstNameController = TextEditingController();
  final TextEditingController _repLastNameController = TextEditingController();
  final TextEditingController _repIdCardController = TextEditingController();
  final TextEditingController _repPositionController = TextEditingController();
  final TextEditingController _repMobileController = TextEditingController();
  
  // Address Controllers
  final TextEditingController _companyNoController = TextEditingController();
  final TextEditingController _companyMooController = TextEditingController();
  final TextEditingController _companySoiController = TextEditingController();
  final TextEditingController _companyRoadController = TextEditingController();
  final TextEditingController _companyTambonController = TextEditingController();
  final TextEditingController _companyAmphoeController = TextEditingController();
  final TextEditingController _companyProvinceController = TextEditingController();
  final TextEditingController _companyPostcodeController = TextEditingController();
  
  // Financial Controllers
  final TextEditingController _registeredCapitalController = TextEditingController();
  final TextEditingController _annualRevenueController = TextEditingController();
  final TextEditingController _netProfitController = TextEditingController();
  final TextEditingController _totalAssetsController = TextEditingController();
  
  // Dropdown Values
  String? _selectedCompanyType;
  String? _selectedRepTitle;
  String? _selectedIndustry;
  String? _selectedIncomeSource;

  @override
  void initState() {
    super.initState();
    _selectedCompanyType = 'บริษัทจำกัด';
    _selectedRepTitle = 'นาย';
    _selectedIndustry = 'การค้า';
    _selectedIncomeSource = 'รายได้จากธุรกิจ';
  }

  @override
  void dispose() {
    // Dispose all controllers
    _companyNameController.dispose();
    _tradeRegistrationIdController.dispose();
    _taxIdController.dispose();
    _registrationDateController.dispose();
    _companyPhoneController.dispose();
    _companyMobileController.dispose();
    _repTitleController.dispose();
    _repFirstNameController.dispose();
    _repLastNameController.dispose();
    _repIdCardController.dispose();
    _repPositionController.dispose();
    _repMobileController.dispose();
    _companyNoController.dispose();
    _companyMooController.dispose();
    _companySoiController.dispose();
    _companyRoadController.dispose();
    _companyTambonController.dispose();
    _companyAmphoeController.dispose();
    _companyProvinceController.dispose();
    _companyPostcodeController.dispose();
    _registeredCapitalController.dispose();
    _annualRevenueController.dispose();
    _netProfitController.dispose();
    _totalAssetsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: const Text(
          'เพิ่มผู้ค้ำประกัน (นิติบุคคล)',
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
                            Icons.business,
                            color: AppTheme.sapphireBlue,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ข้อมูลนิติบุคคล',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'กรุณากรอกข้อมูลบริษัทและผู้มีอำนาจลงนามให้ครบถ้วน',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 🏢 Company Information
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลบริษัท',
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
                      
                      // Company Type and Registration Date
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCompanyType,
                              decoration: const InputDecoration(
                                labelText: 'ประเภทบริษัท',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'บริษัทจำกัด', child: Text('บริษัทจำกัด')),
                                DropdownMenuItem(value: 'ห้างหุ้นส่วนจำกัด', child: Text('ห้างหุ้นส่วนจำกัด')),
                                DropdownMenuItem(value: 'บริษัทมหาชนจำกัด', child: Text('บริษัทมหาชนจำกัด')),
                                DropdownMenuItem(value: 'ห้างหุ้นส่วนสามัญ', child: Text('ห้างหุ้นส่วนสามัญ')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedCompanyType = value;
                                  _formData['company_type'] = value;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _registrationDateController,
                              label: 'วันที่จดทะเบียน (DD/MM/YYYY)',
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  _registrationDateController.text = 
                                    '${date.day.toString().padLeft(2, '0')}/'
                                    '${date.month.toString().padLeft(2, '0')}/'
                                    '${date.year + 543}';
                                  _formData['registration_date'] = _registrationDateController.text;
                                }
                              },
                              onChanged: (value) {
                                _formData['registration_date'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Trade Registration ID and Tax ID
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _tradeRegistrationIdController,
                              label: 'เลขทะเบียนพาณิชย์',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกเลขทะเบียนพาณิชย์';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['trade_registration_id'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _taxIdController,
                              label: 'เลขประจำตัวผู้เสียภาษี',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกเลขประจำตัวผู้เสียภาษี';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['tax_id'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Contact Numbers
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _companyPhoneController,
                              label: 'เบอร์โทรศัพท์บริษัท',
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                _formData['company_phone'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _companyMobileController,
                              label: 'เบอร์โทรศัพท์มือถือ',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกเบอร์โทรศัพท์มือถือ';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['company_mobile'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 👤 Authorized Representative
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ผู้มีอำนาจลงนาม',
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
                              value: _selectedRepTitle,
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
                                  _selectedRepTitle = value;
                                  _formData['rep_title'] = value;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _repFirstNameController,
                              label: 'ชื่อ',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['rep_first_name'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Last Name and Position
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _repLastNameController,
                              label: 'นามสกุล',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกนามสกุล';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['rep_last_name'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _repPositionController,
                              label: 'ตำแหน่ง',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกตำแหน่ง';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['rep_position'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // ID Card and Mobile
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _repIdCardController,
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
                                _formData['rep_id_card'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _repMobileController,
                              label: 'เบอร์โทรศัพท์มือถือ',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกเบอร์โทรศัพท์';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['rep_mobile'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 🏠 Company Address
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ที่อยู่บริษัท',
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
                              controller: _companyNoController,
                              label: 'เลขที่',
                              onChanged: (value) {
                                _formData['company_no'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _companyMooController,
                              label: 'หมู่ที่',
                              onChanged: (value) {
                                _formData['company_moo'] = value;
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
                              controller: _companySoiController,
                              label: 'ซอย',
                              onChanged: (value) {
                                _formData['company_soi'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _companyRoadController,
                              label: 'ถนน',
                              onChanged: (value) {
                                _formData['company_road'] = value;
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
                              controller: _companyTambonController,
                              label: 'ตำบล',
                              onChanged: (value) {
                                _formData['company_tambon'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _companyAmphoeController,
                              label: 'อำเภอ',
                              onChanged: (value) {
                                _formData['company_amphoe'] = value;
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
                                _formData['company_province'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _companyPostcodeController,
                              label: 'รหัสไปรษณีย์',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _formData['company_postcode'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 💰 Financial Information
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลการเงิน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.sapphireBlue,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Registered Capital and Annual Revenue
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _registeredCapitalController,
                              label: 'ทุนจดทะเบียน (บาท)',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกทุนจดทะเบียน';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['registered_capital'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _annualRevenueController,
                              label: 'รายได้ต่อปี (บาท)',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกรายได้ต่อปี';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _formData['annual_revenue'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Net Profit and Total Assets
                      Row(
                        children: [
                          Expanded(
                            child: GlassInputField(
                              controller: _netProfitController,
                              label: 'กำไรสุทธิ (บาท)',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _formData['net_profit'] = value;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: GlassInputField(
                              controller: _totalAssetsController,
                              label: 'สินทรัพย์รวม (บาท)',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _formData['total_assets'] = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Industry and Income Source
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedIndustry,
                              decoration: const InputDecoration(
                                labelText: 'ประเภทธุรกิจ',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'การค้า', child: Text('การค้า')),
                                DropdownMenuItem(value: 'อุตสาหกรรม', child: Text('อุตสาหกรรม')),
                                DropdownMenuItem(value: 'บริการ', child: Text('บริการ')),
                                DropdownMenuItem(value: 'การเงิน', child: Text('การเงิน')),
                                DropdownMenuItem(value: 'อสังหาริมทรัพย์', child: Text('อสังหาริมทรัพย์')),
                                DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedIndustry = value;
                                  _formData['industry'] = value;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedIncomeSource,
                              decoration: const InputDecoration(
                                labelText: 'แหล่งที่มาของรายได้',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'รายได้จากธุรกิจ', child: Text('รายได้จากธุรกิจ')),
                                DropdownMenuItem(value: 'ลงทุน', child: Text('ลงทุน')),
                                DropdownMenuItem(value: 'เงินปันผล', child: Text('เงินปันผล')),
                                DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedIncomeSource = value;
                                  _formData['income_source'] = value;
                                });
                              },
                            ),
                          ),
                        ],
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
        'guarantor_type': 'juristic',
        'company_name': _companyNameController.text,
        'trade_registration_id': _tradeRegistrationIdController.text,
        'tax_id': _taxIdController.text,
        'registration_date': _registrationDateController.text,
        'company_phone': _companyPhoneController.text,
        'company_mobile': _companyMobileController.text,
        'rep_title': _selectedRepTitle,
        'rep_first_name': _repFirstNameController.text,
        'rep_last_name': _repLastNameController.text,
        'rep_position': _repPositionController.text,
        'rep_id_card': _repIdCardController.text,
        'rep_mobile': _repMobileController.text,
        'company_no': _companyNoController.text,
        'company_moo': _companyMooController.text,
        'company_soi': _companySoiController.text,
        'company_road': _companyRoadController.text,
        'company_tambon': _companyTambonController.text,
        'company_amphoe': _companyAmphoeController.text,
        'company_province': _companyProvinceController.text,
        'company_postcode': _companyPostcodeController.text,
        'registered_capital': double.tryParse(_registeredCapitalController.text) ?? 0.0,
        'annual_revenue': double.tryParse(_annualRevenueController.text) ?? 0.0,
        'net_profit': double.tryParse(_netProfitController.text) ?? 0.0,
        'total_assets': double.tryParse(_totalAssetsController.text) ?? 0.0,
        'industry': _selectedIndustry,
        'income_source': _selectedIncomeSource,
        'sync_status': 'pending',
      };
      
      // Add guarantor
      context.read<GuarantorBloc>().add(AddGuarantor(guarantorData));
    }
  }
}
