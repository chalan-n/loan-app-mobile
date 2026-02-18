import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 4 Screen - ที่อยู่ที่ทำงาน
/// จัดการข้อมูลที่อยู่ที่ทำงานของผู้กู้
class Step4Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step4Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Work Address
  final _workNoController = TextEditingController();
  final _workBuildingController = TextEditingController();
  final _workFloorController = TextEditingController();
  final _workRoomController = TextEditingController();
  final _workMooController = TextEditingController();
  final _workSoiController = TextEditingController();
  final _workRoadController = TextEditingController();
  final _workTambonController = TextEditingController();
  final _workAmphoeController = TextEditingController();
  final _workProvinceController = TextEditingController();
  final _workPostcodeController = TextEditingController();
  final _workPhoneController = TextEditingController();
  final _workExtensionController = TextEditingController();

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
    _workNoController.dispose();
    _workBuildingController.dispose();
    _workFloorController.dispose();
    _workRoomController.dispose();
    _workMooController.dispose();
    _workSoiController.dispose();
    _workRoadController.dispose();
    _workTambonController.dispose();
    _workAmphoeController.dispose();
    _workProvinceController.dispose();
    _workPostcodeController.dispose();
    _workPhoneController.dispose();
    _workExtensionController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _workNoController.text = widget.formData['work_no'] ?? '';
      _workBuildingController.text = widget.formData['work_building'] ?? '';
      _workFloorController.text = widget.formData['work_floor'] ?? '';
      _workRoomController.text = widget.formData['work_room'] ?? '';
      _workMooController.text = widget.formData['work_moo'] ?? '';
      _workSoiController.text = widget.formData['work_soi'] ?? '';
      _workRoadController.text = widget.formData['work_road'] ?? '';
      _workTambonController.text = widget.formData['work_tambon'] ?? '';
      _workAmphoeController.text = widget.formData['work_amphoe'] ?? '';
      _workProvinceController.text = widget.formData['work_province'] ?? '';
      _workPostcodeController.text = widget.formData['work_postcode'] ?? '';
      _workPhoneController.text = widget.formData['work_phone'] ?? '';
      _workExtensionController.text = widget.formData['work_extension'] ?? '';
    }
  }

  void _saveFormData() {
    widget.formData.addAll({
      'work_no': _workNoController.text,
      'work_building': _workBuildingController.text,
      'work_floor': _workFloorController.text,
      'work_room': _workRoomController.text,
      'work_moo': _workMooController.text,
      'work_soi': _workSoiController.text,
      'work_road': _workRoadController.text,
      'work_tambon': _workTambonController.text,
      'work_amphoe': _workAmphoeController.text,
      'work_province': _workProvinceController.text,
      'work_postcode': _workPostcodeController.text,
      'work_phone': _workPhoneController.text,
      'work_extension': _workExtensionController.text,
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
            // 🏢 Work Address
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business_outlined,
                        color: AppTheme.sapphireBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ที่อยู่ที่ทำงาน',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Address Details Row 1
                  Row(
                    children: [
                      // House Number
                      Expanded(
                        flex: 2,
                        child: GlassInputField(
                          label: 'เลขที่',
                          hint: 'เลขที่อาคาร',
                          controller: _workNoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเลขที่';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Building
                      Expanded(
                        flex: 2,
                        child: GlassInputField(
                          label: 'อาคาร',
                          hint: 'ชื่ออาคาร',
                          controller: _workBuildingController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Floor
                      Expanded(
                        flex: 1,
                        child: GlassInputField(
                          label: 'ชั้น',
                          hint: 'ชั้น',
                          controller: _workFloorController,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Address Details Row 2
                  Row(
                    children: [
                      // Room
                      Expanded(
                        flex: 1,
                        child: GlassInputField(
                          label: 'ห้อง',
                          hint: 'ห้อง',
                          controller: _workRoomController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Moo
                      Expanded(
                        flex: 1,
                        child: GlassInputField(
                          label: 'หมู่ที่',
                          hint: 'หมู่',
                          controller: _workMooController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Soi
                      Expanded(
                        flex: 2,
                        child: GlassInputField(
                          label: 'ซอย',
                          hint: 'ซอย',
                          controller: _workSoiController,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Road
                  GlassInputField(
                    label: 'ถนน',
                    hint: 'ชื่อถนน',
                    controller: _workRoadController,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Administrative Division Row
                  Row(
                    children: [
                      // Tambon
                      Expanded(
                        child: GlassInputField(
                          label: 'ตำบล/แขวง',
                          hint: 'ตำบลหรือแขวง',
                          controller: _workTambonController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกตำบล';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Amphoe
                      Expanded(
                        child: GlassInputField(
                          label: 'อำเภอ/เขต',
                          hint: 'อำเภอหรือเขต',
                          controller: _workAmphoeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอำเภอ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Province and Postcode Row
                  Row(
                    children: [
                      // Province
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'จังหวัด',
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
                                  value: _workProvinceController.text.isEmpty ? null : _workProvinceController.text,
                                  isExpanded: true,
                                  hint: const Text('เลือกจังหวัด'),
                                  items: _getProvinces().map((province) {
                                    return DropdownMenuItem(
                                      value: province,
                                      child: Text(province),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _workProvinceController.text = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Postcode
                      Expanded(
                        child: GlassInputField(
                          label: 'รหัสไปรษณีย์',
                          hint: '10500',
                          controller: _workPostcodeController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสไปรษณีย์';
                            }
                            if (value.length != 5) {
                              return 'รหัสไปรษณีย์ต้องมี 5 หลัก';
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
            
            // 📞 Work Contact Information
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone_in_talk_outlined,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ข้อมูลติดต่อที่ทำงาน',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      // Work Phone
                      Expanded(
                        flex: 3,
                        child: GlassInputField(
                          label: 'เบอร์โทรศัพท์ที่ทำงาน',
                          hint: '02-123-4567',
                          controller: _workPhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเบอร์โทรศัพท์ที่ทำงาน';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Extension
                      Expanded(
                        child: GlassInputField(
                          label: 'ต่อ',
                          hint: '123',
                          controller: _workExtensionController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.dialpad,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📍 Address Preview
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.preview_outlined,
                        color: AppTheme.sapphireBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ตัวอย่างที่อยู่ที่ทำงาน',
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
                      color: AppTheme.lightBlue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.mediumBlue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getFormattedWorkAddress(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.deepNavy,
                            height: 1.5,
                          ),
                        ),
                        if (_workPhoneController.text.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: AppTheme.sapphireBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'เบอร์ที่ทำงาน: ${_workPhoneController.text}${_workExtensionController.text.isNotEmpty ? ' ต่อ ${_workExtensionController.text}' : ''}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.deepNavy,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // ℹ️ Information Card
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
                      'ที่อยู่ที่ทำงานจะถูกใช้สำหรับการติดต่อเพื่อยืนยันข้อมูลการจ้างงานและรายได้',
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
      ),
    );
  }

  String _getFormattedWorkAddress() {
    final parts = <String>[];
    
    // Company name from step 1
    if (widget.formData['company_name']?.isNotEmpty == true) {
      parts.add('บริษัท ${widget.formData['company_name']}');
    }
    
    // Address details
    if (_workNoController.text.isNotEmpty) {
      parts.add('เลขที่ ${_workNoController.text}');
    }
    
    if (_workBuildingController.text.isNotEmpty) {
      parts.add('อาคาร ${_workBuildingController.text}');
    }
    
    if (_workFloorController.text.isNotEmpty) {
      parts.add('ชั้น ${_workFloorController.text}');
    }
    
    if (_workRoomController.text.isNotEmpty) {
      parts.add('ห้อง ${_workRoomController.text}');
    }
    
    if (_workMooController.text.isNotEmpty) {
      parts.add('หมู่ที่ ${_workMooController.text}');
    }
    
    if (_workSoiController.text.isNotEmpty) {
      parts.add('ซอย${_workSoiController.text}');
    }
    
    if (_workRoadController.text.isNotEmpty) {
      parts.add('ถนน${_workRoadController.text}');
    }
    
    if (_workTambonController.text.isNotEmpty) {
      parts.add('ตำบล${_workTambonController.text}');
    }
    
    if (_workAmphoeController.text.isNotEmpty) {
      parts.add('อำเภอ${_workAmphoeController.text}');
    }
    
    if (_workProvinceController.text.isNotEmpty) {
      parts.add('จังหวัด${_workProvinceController.text}');
    }
    
    if (_workPostcodeController.text.isNotEmpty) {
      parts.add(_workPostcodeController.text);
    }
    
    return parts.isEmpty ? 'ยังไม่มีข้อมูลที่อยู่ที่ทำงาน' : parts.join(' ');
  }

  List<String> _getProvinces() {
    return [
      'กรุงเทพมหานคร',
      'สมุทรปราการ',
      'นนทบุรี',
      'ปทุมธานี',
      'พระนครศรีอยุธยา',
      'อ่างทอง',
      'ลพบุรี',
      'สิงห์บุรี',
      'ชัยนาท',
      'ราชบุรี',
      'กาญจนบุรี',
      'เพชรบุรี',
      'ประจวบคีรีขันธ์',
      'นครปฐม',
      'สุพรรณบุรี',
      'นครนายก',
      'สมุทรสาคร',
      'สมุทรสงคราม',
      'เพชรบูรณ์',
      'อุตรดิตถ์',
      'อุดรธานี',
      'เลย',
      'หนองคาย',
      'มหาสารคาม',
      'ร้อยเอ็ด',
      'กาฬสินธุ์',
      'สกลนคร',
      'นครพนม',
      'บึงกาฬ',
      'ชัยภูมิ',
      'ขอนแก่น',
      'มุกดาหาร',
      'นครราชสีมา',
      'บุรีรัมย์',
      'สุรินทร์',
      'ศรีสะเกษ',
      'อุบลราชธานี',
      'ยโสธร',
      'อำนาจเจริญ',
      'หนองบัวลำภู',
      'กำแพงเพชร',
      'ตาก',
      'สุโขทัย',
      'พิษณุโลก',
      'พิจิตร',
      'เพชรบูรณ์',
      'ราชบุรี',
      'กาญจนบุรี',
      'เพชรบุรี',
      'ประจวบคีรีขันธ์',
      'นครศรีธรรมราช',
      'กระบี่',
      'พังงา',
      'ภูเก็ต',
      'สุราษฎร์ธานี',
      'ระนอง',
      'ชุมพร',
      'สงขลา',
      'พัทลุง',
      'ตรัง',
      'พัทลุง',
      'ปัตตานี',
      'ยะลา',
      'นราธิวาส',
    ];
  }
}
