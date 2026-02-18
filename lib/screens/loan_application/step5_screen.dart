import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 5 Screen - ข้อมูลผู้กู้และรายได้
/// จัดการข้อมูลรายได้และข้อมูลทางการเงินอื่นๆ ของผู้กู้
class Step5Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step5Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step5Screen> createState() => _Step5ScreenState();
}

class _Step5ScreenState extends State<Step5Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Financial Information
  final _salaryController = TextEditingController();
  final _otherIncomeController = TextEditingController();
  final _bonusController = TextEditingController();
  final _commissionController = TextEditingController();
  final _overtimeController = TextEditingController();
  final _totalIncomeController = TextEditingController();
  
  // Dropdown values
  String _incomeSource = 'เงินเดือน';
  String _paymentMethod = 'โอนเงิน';
  String _paymentFrequency = 'รายเดือน';
  String _creditBureauStatus = 'ปกติ';
  String _bankruptcyStatus = 'ไม่เคย';
  String _legalStatus = 'ไม่มีคดี';
  
  // Controllers for Additional Information
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankBranchController = TextEditingController();
  final _workDurationController = TextEditingController();
  final _previousWorkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
    _calculateTotalIncome();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _salaryController.dispose();
    _otherIncomeController.dispose();
    _bonusController.dispose();
    _commissionController.dispose();
    _overtimeController.dispose();
    _totalIncomeController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _bankBranchController.dispose();
    _workDurationController.dispose();
    _previousWorkController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _salaryController.text = widget.formData['salary']?.toString() ?? '';
      _otherIncomeController.text = widget.formData['other_income']?.toString() ?? '';
      _bonusController.text = widget.formData['bonus']?.toString() ?? '';
      _commissionController.text = widget.formData['commission']?.toString() ?? '';
      _overtimeController.text = widget.formData['overtime']?.toString() ?? '';
      
      _incomeSource = widget.formData['income_source'] ?? 'เงินเดือน';
      _paymentMethod = widget.formData['payment_method'] ?? 'โอนเงิน';
      _paymentFrequency = widget.formData['payment_frequency'] ?? 'รายเดือน';
      _creditBureauStatus = widget.formData['credit_bureau_status'] ?? 'ปกติ';
      _bankruptcyStatus = widget.formData['bankruptcy_status'] ?? 'ไม่เคย';
      _legalStatus = widget.formData['legal_status'] ?? 'ไม่มีคดี';
      
      _bankNameController.text = widget.formData['bank_name'] ?? '';
      _bankAccountController.text = widget.formData['bank_account'] ?? '';
      _bankBranchController.text = widget.formData['bank_branch'] ?? '';
      _workDurationController.text = widget.formData['work_duration'] ?? '';
      _previousWorkController.text = widget.formData['previous_work'] ?? '';
    }
  }

  void _saveFormData() {
    widget.formData.addAll({
      'salary': double.tryParse(_salaryController.text.replaceAll(',', '')) ?? 0.0,
      'other_income': double.tryParse(_otherIncomeController.text.replaceAll(',', '')) ?? 0.0,
      'bonus': double.tryParse(_bonusController.text.replaceAll(',', '')) ?? 0.0,
      'commission': double.tryParse(_commissionController.text.replaceAll(',', '')) ?? 0.0,
      'overtime': double.tryParse(_overtimeController.text.replaceAll(',', '')) ?? 0.0,
      'total_income': double.tryParse(_totalIncomeController.text.replaceAll(',', '')) ?? 0.0,
      'income_source': _incomeSource,
      'payment_method': _paymentMethod,
      'payment_frequency': _paymentFrequency,
      'credit_bureau_status': _creditBureauStatus,
      'bankruptcy_status': _bankruptcyStatus,
      'legal_status': _legalStatus,
      'bank_name': _bankNameController.text,
      'bank_account': _bankAccountController.text,
      'bank_branch': _bankBranchController.text,
      'work_duration': _workDurationController.text,
      'previous_work': _previousWorkController.text,
    });
  }

  void _calculateTotalIncome() {
    final salary = double.tryParse(_salaryController.text.replaceAll(',', '')) ?? 0.0;
    final otherIncome = double.tryParse(_otherIncomeController.text.replaceAll(',', '')) ?? 0.0;
    final bonus = double.tryParse(_bonusController.text.replaceAll(',', '')) ?? 0.0;
    final commission = double.tryParse(_commissionController.text.replaceAll(',', '')) ?? 0.0;
    final overtime = double.tryParse(_overtimeController.text.replaceAll(',', '')) ?? 0.0;
    
    final total = salary + otherIncome + bonus + commission + overtime;
    _totalIncomeController.text = total.toStringAsFixed(2);
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
            // 💰 Income Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: AppTheme.sapphireBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ข้อมูลรายได้',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Main Income Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'เงินเดือน (บาท)',
                          hint: '0.00',
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.account_balance_wallet,
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
                          onChanged: (value) => _calculateTotalIncome(),
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
                          onChanged: (value) => _calculateTotalIncome(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Additional Income Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'โบนัส (บาท)',
                          hint: '0.00',
                          controller: _bonusController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.card_giftcard,
                          onChanged: (value) => _calculateTotalIncome(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'คอมมิชชัน (บาท)',
                          hint: '0.00',
                          controller: _commissionController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.percent,
                          onChanged: (value) => _calculateTotalIncome(),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Overtime Income
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GlassInputField(
                          label: 'ค่าล่วงเวลา (บาท)',
                          hint: '0.00',
                          controller: _overtimeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.access_time,
                          onChanged: (value) => _calculateTotalIncome(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassInputField(
                          label: 'รายได้รวม (บาท)',
                          hint: '0.00',
                          controller: _totalIncomeController,
                          enabled: false, // Calculated field
                          prefixIcon: Icons.calculate,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Income Source and Frequency Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'แหล่งที่มาของรายได้',
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
                                  value: _incomeSource,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'เงินเดือน', child: Text('เงินเดือน')),
                                    DropdownMenuItem(value: 'ธุรกิจส่วนตัว', child: Text('ธุรกิจส่วนตัว')),
                                    DropdownMenuItem(value: 'ลงทุน', child: Text('ลงทุน')),
                                    DropdownMenuItem(value: 'เช่า', child: Text('ค่าเช่า')),
                                    DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _incomeSource = value!;
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
                              'ความถี่ในการรับ',
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
                                  value: _paymentFrequency,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'รายเดือน', child: Text('รายเดือน')),
                                    DropdownMenuItem(value: 'รายสัปดาห์', child: Text('รายสัปดาห์')),
                                    DropdownMenuItem(value: 'รายวัน', child: Text('รายวัน')),
                                    DropdownMenuItem(value: 'ไม่แน่นอน', child: Text('ไม่แน่นอน')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentFrequency = value!;
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
            
            // 🏦 Bank Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลบัญชีธนาคาร',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Bank Name and Account Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ชื่อธนาคาร',
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
                                  value: _bankNameController.text.isEmpty ? null : _bankNameController.text,
                                  isExpanded: true,
                                  hint: const Text('เลือกธนาคาร'),
                                  items: _getBanks().map((bank) {
                                    return DropdownMenuItem(
                                      value: bank,
                                      child: Text(bank),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _bankNameController.text = value!;
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
                          label: 'เลขที่บัญชี',
                          hint: '123-4-56789-0',
                          controller: _bankAccountController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเลขที่บัญชี';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Branch and Payment Method Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassInputField(
                          label: 'สาขา',
                          hint: 'ชื่อสาขา',
                          controller: _bankBranchController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'วิธีการรับเงิน',
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
                                  value: _paymentMethod,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'โอนเงิน', child: Text('โอนเงิน')),
                                    DropdownMenuItem(value: 'เช็ค', child: Text('เช็ค')),
                                    DropdownMenuItem(value: 'เงินสด', child: Text('เงินสด')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentMethod = value!;
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
            
            // 📊 Credit Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.credit_score,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลเครดิต',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Credit Bureau Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถานะเครดิตบูโร',
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
                            value: _creditBureauStatus,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'ปกติ', child: Text('ปกติ')),
                              DropdownMenuItem(value: 'ชำระล่าช้า', child: Text('ชำระล่าช้า')),
                              DropdownMenuItem(value: 'มีประวัติเสีย', child: Text('มีประวัติเสีย')),
                              DropdownMenuItem(value: 'ไม่มีประวัติ', child: Text('ไม่มีประวัติ')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _creditBureauStatus = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bankruptcy and Legal Status Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สถานะล้มละลาย',
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
                                  value: _bankruptcyStatus,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'ไม่เคย', child: Text('ไม่เคย')),
                                    DropdownMenuItem(value: 'เคย', child: Text('เคย')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _bankruptcyStatus = value!;
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
                              'สถานะคดีความ',
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
                                  value: _legalStatus,
                                  isExpanded: true,
                                  items: const [
                                    DropdownMenuItem(value: 'ไม่มีคดี', child: Text('ไม่มีคดี')),
                                    DropdownMenuItem(value: 'มีคดี', child: Text('มีคดี')),
                                    DropdownMenuItem(value: 'คดีอยู่ระหว่างพิจารณา', child: Text('คดีอยู่ระหว่างพิจารณา')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _legalStatus = value!;
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
            
            // 💼 Work History
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.work_history,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ประวัติการทำงาน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  GlassInputField(
                    label: 'ระยะเวลาทำงานปัจจุบัน',
                    hint: 'เช่น 2 ปี 3 เดือน',
                    controller: _workDurationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกระยะเวลาทำงาน';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  GlassInputField(
                    label: 'อดีตที่ทำงาน (ถ้ามี)',
                    hint: 'ชื่อบริษัทและตำแหน่ง',
                    controller: _previousWorkController,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📈 Income Summary
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
                        'สรุปรายได้',
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
                        _buildIncomeRow('เงินเดือน', _salaryController.text),
                        const SizedBox(height: 8),
                        _buildIncomeRow('รายได้อื่น', _otherIncomeController.text),
                        const SizedBox(height: 8),
                        _buildIncomeRow('โบนัส', _bonusController.text),
                        const SizedBox(height: 8),
                        _buildIncomeRow('คอมมิชชัน', _commissionController.text),
                        const SizedBox(height: 8),
                        _buildIncomeRow('ค่าล่วงเวลา', _overtimeController.text),
                        const Divider(height: 16, color: AppTheme.mediumGray),
                        _buildIncomeRow(
                          'รายได้รวม',
                          _totalIncomeController.text,
                          isTotal: true,
                        ),
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

  Widget _buildIncomeRow(String label, String value, {bool isTotal = false}) {
    final amount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
    final formattedAmount = amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

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
          '$formattedAmount บาท',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isTotal ? AppTheme.sapphireBlue : AppTheme.darkGray,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<String> _getBanks() {
    return [
      'ธนาคารกรุงเทพ',
      'ธนาคารกสิกรไทย',
      'ธนาคารไทยพาณิชย์',
      'ธนาคารกรุงศรีอยุธยา',
      'ธนาคารกรุงไทย',
      'ธนาคารทหารไทยธนชาติ',
      'ธนาคารออมสิน',
      'ธนาคารซีไอเอ็มบีไทย',
      'ธนาคารยูโอบี',
      'ธนาคารเกียรตินาคิน',
      'ธนาคารทิสโก้',
      'ธนาคารอาคารสงเคราะห์',
      'ธนาคารอิสลามแห่งประเทศไทย',
      'ธนาคารพัฒนาวิสาหกิจขนาดกลางและขนาดย่อมแห่งประเทศไทย',
    ];
  }
}
