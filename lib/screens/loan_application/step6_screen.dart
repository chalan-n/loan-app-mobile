import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 6 Screen - ข้อมูลรถยนต์
/// จัดการข้อมูลรถยนต์ที่ต้องการทำสินเชื่อ
class Step6Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step6Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step6Screen> createState() => _Step6ScreenState();
}

class _Step6ScreenState extends State<Step6Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Car Information
  final _carBrandController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carColorController = TextEditingController();
  final _carLicenseController = TextEditingController();
  final _carEngineController = TextEditingController();
  final _carChassisController = TextEditingController();
  final _carPriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _loanAmountController = TextEditingController();
  
  // Dropdown values
  String _carType = 'รถยนต์ส่วนบุคคล';
  String _carCondition = 'รถใหม่';
  String _carUsage = 'ส่วนบุคคล';
  String _loanPurpose = 'ซื้อรถ';
  String _paymentPeriod = '48 เดือน';
  String _insuranceType = 'ประกันภัยชั้น 1';
  
  // Controllers for Additional Information
  final _showroomController = TextEditingController();
  final _showroomPhoneController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
    _calculateLoanAmount();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _carBrandController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    _carColorController.dispose();
    _carLicenseController.dispose();
    _carEngineController.dispose();
    _carChassisController.dispose();
    _carPriceController.dispose();
    _downPaymentController.dispose();
    _loanAmountController.dispose();
    _showroomController.dispose();
    _showroomPhoneController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _carBrandController.text = widget.formData['car_brand'] ?? '';
      _carModelController.text = widget.formData['car_model'] ?? '';
      _carYearController.text = widget.formData['car_year'] ?? '';
      _carColorController.text = widget.formData['car_color'] ?? '';
      _carLicenseController.text = widget.formData['car_license'] ?? '';
      _carEngineController.text = widget.formData['car_engine'] ?? '';
      _carChassisController.text = widget.formData['car_chassis'] ?? '';
      _carPriceController.text = widget.formData['car_price']?.toString() ?? '';
      _downPaymentController.text = widget.formData['down_payment']?.toString() ?? '';
      _loanAmountController.text = widget.formData['loan_amount']?.toString() ?? '';
      
      _carType = widget.formData['car_type'] ?? 'รถยนต์ส่วนบุคคล';
      _carCondition = widget.formData['car_condition'] ?? 'รถใหม่';
      _carUsage = widget.formData['car_usage'] ?? 'ส่วนบุคคล';
      _loanPurpose = widget.formData['loan_purpose'] ?? 'ซื้อรถ';
      _paymentPeriod = widget.formData['payment_period'] ?? '48 เดือน';
      _insuranceType = widget.formData['insurance_type'] ?? 'ประกันภัยชั้น 1';
      
      _showroomController.text = widget.formData['showroom'] ?? '';
      _showroomPhoneController.text = widget.formData['showroom_phone'] ?? '';
      _sellerNameController.text = widget.formData['seller_name'] ?? '';
      _sellerPhoneController.text = widget.formData['seller_phone'] ?? '';
    }
  }

  void _saveFormData() {
    widget.formData.addAll({
      'car_brand': _carBrandController.text,
      'car_model': _carModelController.text,
      'car_year': _carYearController.text,
      'car_color': _carColorController.text,
      'car_license': _carLicenseController.text,
      'car_engine': _carEngineController.text,
      'car_chassis': _carChassisController.text,
      'car_price': double.tryParse(_carPriceController.text.replaceAll(',', '')) ?? 0.0,
      'down_payment': double.tryParse(_downPaymentController.text.replaceAll(',', '')) ?? 0.0,
      'loan_amount': double.tryParse(_loanAmountController.text.replaceAll(',', '')) ?? 0.0,
      'car_type': _carType,
      'car_condition': _carCondition,
      'car_usage': _carUsage,
      'loan_purpose': _loanPurpose,
      'payment_period': _paymentPeriod,
      'insurance_type': _insuranceType,
      'showroom': _showroomController.text,
      'showroom_phone': _showroomPhoneController.text,
      'seller_name': _sellerNameController.text,
      'seller_phone': _sellerPhoneController.text,
    });
  }

  void _calculateLoanAmount() {
    final carPrice = double.tryParse(_carPriceController.text.replaceAll(',', '')) ?? 0.0;
    final downPayment = double.tryParse(_downPaymentController.text.replaceAll(',', '')) ?? 0.0;
    final loanAmount = carPrice - downPayment;
    _loanAmountController.text = loanAmount.toStringAsFixed(2);
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
            // 🚗 Car Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: AppTheme.sapphireBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ข้อมูลรถยนต์',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Car Type and Condition Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ประเภทรถ',
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
                                  value: _carType,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'รถยนต์ส่วนบุคคล', child: Text('รถยนต์ส่วนบุคคล')),
                                    DropdownMenuItem(value: 'รถยนต์บรรทุก', child: Text('รถยนต์บรรทุก')),
                                    DropdownMenuItem(value: 'รถจักรยานยนต์', child: Text('รถจักรยานยนต์')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _carType = value!;
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
                              'สภาพรถ',
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
                                  value: _carCondition,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'รถใหม่', child: Text('รถใหม่')),
                                    DropdownMenuItem(value: 'รถมือสอง', child: Text('รถมือสอง')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _carCondition = value!;
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
                  
                  const SizedBox(height: 16),
                  
                  // Brand and Model Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ยี่ห้อ',
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
                                  value: _carBrandController.text.isEmpty ? null : _carBrandController.text,
                                  isExpanded: true,
                                  hint: const Text('เลือกยี่ห้อ'),
                                  items: _getCarBrands().map((brand) {
                                    return DropdownMenuItem(
                                      value: brand,
                                      child: Text(brand),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _carBrandController.text = value!;
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
                        child: GlassInputField(
                          label: 'รุ่น',
                          hint: 'กรอกรุ่นรถ',
                          controller: _carModelController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรุ่นรถ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Year and Color Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'ปีที่ผลิต',
                          hint: '2567',
                          controller: _carYearController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกปีที่ผลิต';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'สี',
                          hint: 'กรอกสีรถ',
                          controller: _carColorController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกสีรถ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // License Plate
                  GlassInputField(
                    label: 'ทะเบียนรถ',
                    hint: 'กข-1234 กรุงเทพมหานคร',
                    controller: _carLicenseController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกทะเบียนรถ';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Engine and Chassis Number Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'เลขเครื่องยนต์',
                          hint: 'กรอกเลขเครื่องยนต์',
                          controller: _carEngineController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเลขเครื่องยนต์';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'เลขตัวถัง',
                          hint: 'กรอกเลขตัวถัง',
                          controller: _carChassisController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเลขตัวถัง';
                            }
                            return null;
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
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลการเงิน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Car Price and Down Payment Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'ราคารถ (บาท)',
                          hint: '0.00',
                          controller: _carPriceController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกราคารถ';
                            }
                            final amount = double.tryParse(value.replaceAll(',', ''));
                            if (amount == null || amount <= 0) {
                              return 'กรุณากรอกราคาที่ถูกต้อง';
                            }
                            return null;
                          },
                          onChanged: (value) => _calculateLoanAmount(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'เงินดาวน์ (บาท)',
                          hint: '0.00',
                          controller: _downPaymentController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.savings,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเงินดาวน์';
                            }
                            final amount = double.tryParse(value.replaceAll(',', ''));
                            if (amount == null || amount < 0) {
                              return 'กรุณากรอกจำนวนเงินที่ถูกต้อง';
                            }
                            return null;
                          },
                          onChanged: (value) => _calculateLoanAmount(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Loan Amount (Calculated)
                  GlassInputField(
                    label: 'วงเงินที่ขอกู้ (บาท)',
                    hint: '0.00',
                    controller: _loanAmountController,
                    enabled: false, // Calculated field
                    prefixIcon: Icons.calculate,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Loan Purpose and Payment Period Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'วัตถุประสงค์การกู้',
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
                                  value: _loanPurpose,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'ซื้อรถ', child: Text('ซื้อรถ')),
                                    DropdownMenuItem(value: 'รีไฟแนนซ์', child: Text('รีไฟแนนซ์')),
                                    DropdownMenuItem(value: 'จำนำรถ', child: Text('จำนำรถ')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _loanPurpose = value!;
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
                              'ระยะเวลาผ่อนชำระ',
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
                                  value: _paymentPeriod,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: '12 เดือน', child: Text('12 เดือน')),
                                    DropdownMenuItem(value: '24 เดือน', child: Text('24 เดือน')),
                                    DropdownMenuItem(value: '36 เดือน', child: Text('36 เดือน')),
                                    DropdownMenuItem(value: '48 เดือน', child: Text('48 เดือน')),
                                    DropdownMenuItem(value: '60 เดือน', child: Text('60 เดือน')),
                                    DropdownMenuItem(value: '72 เดือน', child: Text('72 เดือน')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentPeriod = value!;
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
                  
                  const SizedBox(height: 16),
                  
                  // Insurance Type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ประกันภัย',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.deepNavy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.mediumBlue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.pureWhite,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _insuranceType,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'ประกันภัยชั้น 1', child: Text('ประกันภัยชั้น 1')),
                              DropdownMenuItem(value: 'ประกันภัยชั้น 2', child: Text('ประกันภัยชั้น 2')),
                              DropdownMenuItem(value: 'ประกันภัยชั้น 3', child: Text('ประกันภัยชั้น 3')),
                              DropdownMenuItem(value: 'ประกันภัยชั้น 3+', child: Text('ประกันภัยชั้น 3+')),
                              DropdownMenuItem(value: 'พ.ร.บ.', child: Text('พ.ร.บ.เท่านั้น')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _insuranceType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 🏪 Seller Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลผู้ขาย',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Showroom Information
                  GlassInputField(
                    label: 'ชื่อโชว์รูม/ผู้ขาย',
                    hint: 'กรอกชื่อโชว์รูมหรือผู้ขาย',
                    controller: _showroomController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อผู้ขาย';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'เบอร์โทรศัพท์ผู้ขาย',
                          hint: '02-123-4567',
                          controller: _showroomPhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเบอร์โทรศัพท์';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'ชื่อผู้ติดต่อ',
                          hint: 'ชื่อผู้ติดต่อ',
                          controller: _sellerNameController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📊 Loan Summary
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.summarize,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'สรุปข้อมูลการเงิน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.sapphireBlue.withOpacity(0.1),
                          AppTheme.deepNavy.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.sapphireBlue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildFinanceRow('ราคารถ', _carPriceController.text),
                        const SizedBox(height: 8),
                        _buildFinanceRow('เงินดาวน์', _downPaymentController.text),
                        const Divider(height: 16, color: AppTheme.mediumGray),
                        _buildFinanceRow(
                          'วงเงินที่ขอกู้',
                          _loanAmountController.text,
                          isTotal: true,
                        ),
                        const SizedBox(height: 8),
                        _buildFinanceRow('ระยะเวลาผ่อนชำระ', _paymentPeriod),
                        const SizedBox(height: 8),
                        _buildFinanceRow('ประกันภัย', _insuranceType),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceRow(String label, String value, {bool isTotal = false}) {
    String displayValue = value;
    
    // Format currency values
    if (value.contains('.') || value.contains(',')) {
      final amount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
      displayValue = amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
      if (!value.contains('บาท')) {
        displayValue += ' บาท';
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isTotal ? AppTheme.deepNavy : AppTheme.darkGray,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          displayValue,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isTotal ? AppTheme.sapphireBlue : AppTheme.darkGray,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<String> _getCarBrands() {
    return [
      'Toyota',
      'Honda',
      'Isuzu',
      'Mitsubishi',
      'Nissan',
      'Mazda',
      'Ford',
      'Chevrolet',
      'BMW',
      'Mercedes-Benz',
      'Audi',
      'Volkswagen',
      'Hyundai',
      'Kia',
      'Suzuki',
      'MG',
      'Proton',
      'Yamaha',
      'Honda (Motorcycle)',
      'Kawasaki',
    ];
  }
}
