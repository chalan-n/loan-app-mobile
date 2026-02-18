import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 2 Screen - ที่อยู่ตามทะเบียนบ้าน
/// จัดการข้อมูลที่อยู่ตามทะเบียนบ้านของผู้กู้
class Step2Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for House Registration Address
  final _houseRegNoController = TextEditingController();
  final _houseRegBuildingController = TextEditingController();
  final _houseRegFloorController = TextEditingController();
  final _houseRegRoomController = TextEditingController();
  final _houseRegMooController = TextEditingController();
  final _houseRegSoiController = TextEditingController();
  final _houseRegRoadController = TextEditingController();
  final _houseRegTambonController = TextEditingController();
  final _houseRegAmphoeController = TextEditingController();
  final _houseRegProvinceController = TextEditingController();
  final _houseRegPostcodeController = TextEditingController();

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
    _houseRegNoController.dispose();
    _houseRegBuildingController.dispose();
    _houseRegFloorController.dispose();
    _houseRegRoomController.dispose();
    _houseRegMooController.dispose();
    _houseRegSoiController.dispose();
    _houseRegRoadController.dispose();
    _houseRegTambonController.dispose();
    _houseRegAmphoeController.dispose();
    _houseRegProvinceController.dispose();
    _houseRegPostcodeController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _houseRegNoController.text = widget.formData['house_reg_no'] ?? '';
      _houseRegBuildingController.text = widget.formData['house_reg_building'] ?? '';
      _houseRegFloorController.text = widget.formData['house_reg_floor'] ?? '';
      _houseRegRoomController.text = widget.formData['house_reg_room'] ?? '';
      _houseRegMooController.text = widget.formData['house_reg_moo'] ?? '';
      _houseRegSoiController.text = widget.formData['house_reg_soi'] ?? '';
      _houseRegRoadController.text = widget.formData['house_reg_road'] ?? '';
      _houseRegTambonController.text = widget.formData['house_reg_tambon'] ?? '';
      _houseRegAmphoeController.text = widget.formData['house_reg_amphoe'] ?? '';
      _houseRegProvinceController.text = widget.formData['house_reg_province'] ?? '';
      _houseRegPostcodeController.text = widget.formData['house_reg_postcode'] ?? '';
    }
  }

  void _saveFormData() {
    widget.formData.addAll({
      'house_reg_no': _houseRegNoController.text,
      'house_reg_building': _houseRegBuildingController.text,
      'house_reg_floor': _houseRegFloorController.text,
      'house_reg_room': _houseRegRoomController.text,
      'house_reg_moo': _houseRegMooController.text,
      'house_reg_soi': _houseRegSoiController.text,
      'house_reg_road': _houseRegRoadController.text,
      'house_reg_tambon': _houseRegTambonController.text,
      'house_reg_amphoe': _houseRegAmphoeController.text,
      'house_reg_province': _houseRegProvinceController.text,
      'house_reg_postcode': _houseRegPostcodeController.text,
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
            // 🏠 House Registration Address
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
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ที่อยู่ตามทะเบียนบ้าน',
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
                          hint: 'เลขที่บ้าน',
                          controller: _houseRegNoController,
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
                          controller: _houseRegBuildingController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Floor
                      Expanded(
                        flex: 1,
                        child: GlassInputField(
                          label: 'ชั้น',
                          hint: 'ชั้น',
                          controller: _houseRegFloorController,
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
                          controller: _houseRegRoomController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Moo
                      Expanded(
                        flex: 1,
                        child: GlassInputField(
                          label: 'หมู่ที่',
                          hint: 'หมู่',
                          controller: _houseRegMooController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Soi
                      Expanded(
                        flex: 2,
                        child: GlassInputField(
                          label: 'ซอย',
                          hint: 'ซอย',
                          controller: _houseRegSoiController,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Road
                  GlassInputField(
                    label: 'ถนน',
                    hint: 'ชื่อถนน',
                    controller: _houseRegRoadController,
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
                          controller: _houseRegTambonController,
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
                          controller: _houseRegAmphoeController,
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
                                  value: _houseRegProvinceController.text.isEmpty ? null : _houseRegProvinceController.text,
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
                                      _houseRegProvinceController.text = value!;
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
                          controller: _houseRegPostcodeController,
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
                        'ตัวอย่างที่อยู่',
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
                    child: Text(
                      _getFormattedAddress(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.deepNavy,
                        height: 1.5,
                      ),
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
                      'ที่อยู่ตามทะเบียนบ้านจะถูกใช้สำหรับการติดต่อและการยืนยันตัวตน กรุณากรอกข้อมูลให้ถูกต้อง',
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

  String _getFormattedAddress() {
    final parts = <String>[];
    
    // House number and details
    if (_houseRegNoController.text.isNotEmpty) {
      parts.add('เลขที่ ${_houseRegNoController.text}');
    }
    
    if (_houseRegBuildingController.text.isNotEmpty) {
      parts.add('อาคาร ${_houseRegBuildingController.text}');
    }
    
    if (_houseRegFloorController.text.isNotEmpty) {
      parts.add('ชั้น ${_houseRegFloorController.text}');
    }
    
    if (_houseRegRoomController.text.isNotEmpty) {
      parts.add('ห้อง ${_houseRegRoomController.text}');
    }
    
    if (_houseRegMooController.text.isNotEmpty) {
      parts.add('หมู่ที่ ${_houseRegMooController.text}');
    }
    
    if (_houseRegSoiController.text.isNotEmpty) {
      parts.add('ซอย${_houseRegSoiController.text}');
    }
    
    if (_houseRegRoadController.text.isNotEmpty) {
      parts.add('ถนน${_houseRegRoadController.text}');
    }
    
    if (_houseRegTambonController.text.isNotEmpty) {
      parts.add('ตำบล${_houseRegTambonController.text}');
    }
    
    if (_houseRegAmphoeController.text.isNotEmpty) {
      parts.add('อำเภอ${_houseRegAmphoeController.text}');
    }
    
    if (_houseRegProvinceController.text.isNotEmpty) {
      parts.add('จังหวัด${_houseRegProvinceController.text}');
    }
    
    if (_houseRegPostcodeController.text.isNotEmpty) {
      parts.add(_houseRegPostcodeController.text);
    }
    
    return parts.isEmpty ? 'ยังไม่มีข้อมูลที่อยู่' : parts.join(' ');
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
