import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 7 Screen - สรุปข้อมูล
/// แสดงสรุปข้อมูลทั้งหมดก่อนส่งคำขอสินเชื่อ
class Step7Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const Step7Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  State<Step7Screen> createState() => _Step7ScreenState();
}

class _Step7ScreenState extends State<Step7Screen> {
  bool _termsAccepted = false;
  bool _dataProcessingAccepted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📋 Summary Header
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
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'สรุปข้อมูลคำขอสินเชื่อ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'กรุณาตรวจสอบข้อมูลทั้งหมดให้ถูกต้องก่อนส่งคำขอ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 👤 Personal Information Summary
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppTheme.sapphireBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ข้อมูลส่วนตัว',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildSummaryRow('ประเภทผู้กู้', widget.formData['borrower_type'] ?? '-'),
                _buildSummaryRow('ชื่อ-นามสกุล', '${widget.formData['title'] ?? ''} ${widget.formData['first_name'] ?? ''} ${widget.formData['last_name'] ?? ''}'),
                _buildSummaryRow('เพศ', widget.formData['gender'] ?? '-'),
                _buildSummaryRow('เลขบัตรประชาชน', widget.formData['id_card'] ?? '-'),
                _buildSummaryRow('วันเกิด', widget.formData['date_of_birth'] ?? '-'),
                _buildSummaryRow('เบอร์โทรศัพท์', widget.formData['mobile_phone'] ?? '-'),
                _buildSummaryRow('อาชีพ', widget.formData['occupation'] ?? '-'),
                _buildSummaryRow('ชื่อบริษัท', widget.formData['company_name'] ?? '-'),
                
                if (widget.formData['borrower_type'] == 'juristic') ...[
                  const Divider(height: 24),
                  _buildSummaryRow('เลขทะเบียนพาณิชย์', widget.formData['trade_registration_id'] ?? '-'),
                  _buildSummaryRow('เลขประจำตัวผู้เสียภาษี', widget.formData['tax_id'] ?? '-'),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 🏠 Address Information Summary
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: AppTheme.sapphireBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ข้อมูลที่อยู่',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'ที่อยู่ตามทะเบียนบ้าน',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.deepNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getFormattedRegistrationAddress(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.deepNavy,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'ที่อยู่ปัจจุบัน',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.deepNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getFormattedCurrentAddress(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.deepNavy,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'ที่อยู่ที่ทำงาน',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.deepNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getFormattedWorkAddress(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.deepNavy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 💰 Financial Information Summary
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
                  
                  const SizedBox(height: 16),
                  
                  _buildSummaryRow('เงินเดือน', _formatCurrency(widget.formData['salary'])),
                  _buildSummaryRow('รายได้อื่น', _formatCurrency(widget.formData['other_income'])),
                  _buildSummaryRow('โบนัส', _formatCurrency(widget.formData['bonus'])),
                  _buildSummaryRow('คอมมิชชัน', _formatCurrency(widget.formData['commission'])),
                  _buildSummaryRow('ค่าล่วงเวลา', _formatCurrency(widget.formData['overtime'])),
                  const Divider(height: 16),
                  _buildSummaryRow(
                    'รายได้รวม',
                    _formatCurrency(widget.formData['total_income']),
                    isHighlight: true,
                  ),
                  _buildSummaryRow('แหล่งที่มาของรายได้', widget.formData['income_source'] ?? '-'),
                  _buildSummaryRow('สถานะเครดิตบูโร', widget.formData['credit_bureau_status'] ?? '-'),
                  _buildSummaryRow('ชื่อธนาคาร', widget.formData['bank_name'] ?? '-'),
                  _buildSummaryRow('เลขที่บัญชี', widget.formData['bank_account'] ?? '-'),
                ],
              ),
            ),
          
          const SizedBox(height: 20),
          
          // 🚗 Car Information Summary
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
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ข้อมูลรถยนต์',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildSummaryRow('ประเภทรถ', widget.formData['car_type'] ?? '-'),
                _buildSummaryRow('สภาพรถ', widget.formData['car_condition'] ?? '-'),
                _buildSummaryRow('ยี่ห้อ', widget.formData['car_brand'] ?? '-'),
                _buildSummaryRow('รุ่น', widget.formData['car_model'] ?? '-'),
                _buildSummaryRow('ปีที่ผลิต', widget.formData['car_year'] ?? '-'),
                _buildSummaryRow('สี', widget.formData['car_color'] ?? '-'),
                _buildSummaryRow('ทะเบียนรถ', widget.formData['car_license'] ?? '-'),
                _buildSummaryRow('เลขเครื่องยนต์', widget.formData['car_engine'] ?? '-'),
                _buildSummaryRow('เลขตัวถัง', widget.formData['car_chassis'] ?? '-'),
                const Divider(height: 16),
                _buildSummaryRow('ราคารถ', _formatCurrency(widget.formData['car_price']), isHighlight: true),
                _buildSummaryRow('เงินดาวน์', _formatCurrency(widget.formData['down_payment'])),
                _buildSummaryRow(
                  'วงเงินที่ขอกู้',
                  _formatCurrency(widget.formData['loan_amount']),
                  isHighlight: true,
                ),
                _buildSummaryRow('ระยะเวลาผ่อนชำระ', widget.formData['payment_period'] ?? '-'),
                _buildSummaryRow('ประกันภัย', widget.formData['insurance_type'] ?? '-'),
                _buildSummaryRow('ชื่อผู้ขาย', widget.formData['showroom'] ?? '-'),
                _buildSummaryRow('เบอร์ผู้ขาย', widget.formData['showroom_phone'] ?? '-'),
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
                      'เงื่อนไขและข้อตกลง',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Terms Checkbox
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _termsAccepted 
                      ? AppTheme.lightBlue.withOpacity(0.5)
                      : AppTheme.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _termsAccepted 
                        ? AppTheme.sapphireBlue.withOpacity(0.3)
                        : AppTheme.mediumBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                            },
                            activeColor: AppTheme.sapphireBlue,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ข้าพเจ้ายอมรับเงื่อนไขและข้อตกลงในการสมัครสินเชื่อ',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'โดยข้าพเจ้าขอรับรองว่าข้อมูลทั้งหมดที่ให้ไว้เป็นความจริงและถูกต้อง หากพบว่าข้อมูลไม่เป็นความจริง บริษัทฯ มีสิทธิ์พิจารณาคำขอสินเชื่ออีกครั้ง',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.mediumGray,
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
                
                const SizedBox(height: 16),
                
                // Data Processing Checkbox
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _dataProcessingAccepted 
                      ? AppTheme.lightBlue.withOpacity(0.5)
                      : AppTheme.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _dataProcessingAccepted 
                        ? AppTheme.sapphireBlue.withOpacity(0.3)
                        : AppTheme.mediumBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _dataProcessingAccepted,
                            onChanged: (value) {
                              setState(() {
                                _dataProcessingAccepted = value ?? false;
                              });
                            },
                            activeColor: AppTheme.sapphireBlue,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ยินยอมให้ประมวลผลข้อมูลส่วนบุคคล',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ข้าพเจ้ายินยอมให้บริษัทฯ เก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคลตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.mediumGray,
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
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // ⚠️ Important Notice
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'การส่งคำขอสินเชื่อไม่ได้หมายความว่าจะได้รับการอนุมัติ บริษัทฯ จะพิจารณาคำขอตามหลักเกณฑ์ที่กำหนด',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isHighlight ? AppTheme.sapphireBlue : AppTheme.deepNavy,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '0.00 บาท';
    
    final amount = value is double ? value : double.tryParse(value.toString()) ?? 0.0;
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted บาท';
  }

  String _getFormattedRegistrationAddress() {
    final parts = <String>[];
    
    if (widget.formData['house_reg_no']?.isNotEmpty == true) {
      parts.add('เลขที่ ${widget.formData['house_reg_no']}');
    }
    if (widget.formData['house_reg_building']?.isNotEmpty == true) {
      parts.add('อาคาร ${widget.formData['house_reg_building']}');
    }
    if (widget.formData['house_reg_moo']?.isNotEmpty == true) {
      parts.add('หมู่ที่ ${widget.formData['house_reg_moo']}');
    }
    if (widget.formData['house_reg_soi']?.isNotEmpty == true) {
      parts.add('ซอย${widget.formData['house_reg_soi']}');
    }
    if (widget.formData['house_reg_road']?.isNotEmpty == true) {
      parts.add('ถนน${widget.formData['house_reg_road']}');
    }
    if (widget.formData['house_reg_tambon']?.isNotEmpty == true) {
      parts.add('ตำบล${widget.formData['house_reg_tambon']}');
    }
    if (widget.formData['house_reg_amphoe']?.isNotEmpty == true) {
      parts.add('อำเภอ${widget.formData['house_reg_amphoe']}');
    }
    if (widget.formData['house_reg_province']?.isNotEmpty == true) {
      parts.add('จังหวัด${widget.formData['house_reg_province']}');
    }
    if (widget.formData['house_reg_postcode']?.isNotEmpty == true) {
      parts.add(widget.formData['house_reg_postcode']);
    }
    
    return parts.isEmpty ? 'ไม่มีข้อมูล' : parts.join(' ');
  }

  String _getFormattedCurrentAddress() {
    if (widget.formData['current_same_as_registration'] == true) {
      return 'เหมือนที่อยู่ตามทะเบียนบ้าน';
    }
    
    final parts = <String>[];
    
    if (widget.formData['current_no']?.isNotEmpty == true) {
      parts.add('เลขที่ ${widget.formData['current_no']}');
    }
    if (widget.formData['current_building']?.isNotEmpty == true) {
      parts.add('อาคาร ${widget.formData['current_building']}');
    }
    if (widget.formData['current_moo']?.isNotEmpty == true) {
      parts.add('หมู่ที่ ${widget.formData['current_moo']}');
    }
    if (widget.formData['current_soi']?.isNotEmpty == true) {
      parts.add('ซอย${widget.formData['current_soi']}');
    }
    if (widget.formData['current_road']?.isNotEmpty == true) {
      parts.add('ถนน${widget.formData['current_road']}');
    }
    if (widget.formData['current_tambon']?.isNotEmpty == true) {
      parts.add('ตำบล${widget.formData['current_tambon']}');
    }
    if (widget.formData['current_amphoe']?.isNotEmpty == true) {
      parts.add('อำเภอ${widget.formData['current_amphoe']}');
    }
    if (widget.formData['current_province']?.isNotEmpty == true) {
      parts.add('จังหวัด${widget.formData['current_province']}');
    }
    if (widget.formData['current_postcode']?.isNotEmpty == true) {
      parts.add(widget.formData['current_postcode']);
    }
    
    return parts.isEmpty ? 'ไม่มีข้อมูล' : parts.join(' ');
  }

  String _getFormattedWorkAddress() {
    final parts = <String>[];
    
    if (widget.formData['company_name']?.isNotEmpty == true) {
      parts.add('บริษัท ${widget.formData['company_name']}');
    }
    if (widget.formData['work_no']?.isNotEmpty == true) {
      parts.add('เลขที่ ${widget.formData['work_no']}');
    }
    if (widget.formData['work_building']?.isNotEmpty == true) {
      parts.add('อาคาร ${widget.formData['work_building']}');
    }
    if (widget.formData['work_moo']?.isNotEmpty == true) {
      parts.add('หมู่ที่ ${widget.formData['work_moo']}');
    }
    if (widget.formData['work_soi']?.isNotEmpty == true) {
      parts.add('ซอย${widget.formData['work_soi']}');
    }
    if (widget.formData['work_road']?.isNotEmpty == true) {
      parts.add('ถนน${widget.formData['work_road']}');
    }
    if (widget.formData['work_tambon']?.isNotEmpty == true) {
      parts.add('ตำบล${widget.formData['work_tambon']}');
    }
    if (widget.formData['work_amphoe']?.isNotEmpty == true) {
      parts.add('อำเภอ${widget.formData['work_amphoe']}');
    }
    if (widget.formData['work_province']?.isNotEmpty == true) {
      parts.add('จังหวัด${widget.formData['work_province']}');
    }
    if (widget.formData['work_postcode']?.isNotEmpty == true) {
      parts.add(widget.formData['work_postcode']);
    }
    
    return parts.isEmpty ? 'ไม่มีข้อมูล' : parts.join(' ');
  }
}
