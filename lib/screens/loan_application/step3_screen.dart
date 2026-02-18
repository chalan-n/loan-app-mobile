import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// 📝 Step 3 Screen - ที่อยู่ปัจจุบัน
/// จัดการข้อมูลที่อยู่ปัจจุบันของผู้กู้ พร้อมตัวเลือกให้คงที่อยู่เดิม
class Step3Screen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step3Screen({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Checkbox for same address
  bool _sameAsRegistration = false;
  
  // Controllers for Current Address
  final _currentNoController = TextEditingController();
  final _currentBuildingController = TextEditingController();
  final _currentFloorController = TextEditingController();
  final _currentRoomController = TextEditingController();
  final _currentMooController = TextEditingController();
  final _currentSoiController = TextEditingController();
  final _currentRoadController = TextEditingController();
  final _currentTambonController = TextEditingController();
  final _currentAmphoeController = TextEditingController();
  final _currentProvinceController = TextEditingController();
  final _currentPostcodeController = TextEditingController();

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
    _currentNoController.dispose();
    _currentBuildingController.dispose();
    _currentFloorController.dispose();
    _currentRoomController.dispose();
    _currentMooController.dispose();
    _currentSoiController.dispose();
    _currentRoadController.dispose();
    _currentTambonController.dispose();
    _currentAmphoeController.dispose();
    _currentProvinceController.dispose();
    _currentPostcodeController.dispose();
  }

  void _loadFormData() {
    // Load existing data if available
    if (widget.formData.isNotEmpty) {
      _sameAsRegistration = widget.formData['current_same_as_registration'] ?? false;
      
      if (!_sameAsRegistration) {
        _currentNoController.text = widget.formData['current_no'] ?? '';
        _currentBuildingController.text = widget.formData['current_building'] ?? '';
        _currentFloorController.text = widget.formData['current_floor'] ?? '';
        _currentRoomController.text = widget.formData['current_room'] ?? '';
        _currentMooController.text = widget.formData['current_moo'] ?? '';
        _currentSoiController.text = widget.formData['current_soi'] ?? '';
        _currentRoadController.text = widget.formData['current_road'] ?? '';
        _currentTambonController.text = widget.formData['current_tambon'] ?? '';
        _currentAmphoeController.text = widget.formData['current_amphoe'] ?? '';
        _currentProvinceController.text = widget.formData['current_province'] ?? '';
        _currentPostcodeController.text = widget.formData['current_postcode'] ?? '';
      }
    }
  }

  void _saveFormData() {
    widget.formData.addAll({
      'current_same_as_registration': _sameAsRegistration,
    });
    
    if (!_sameAsRegistration) {
      widget.formData.addAll({
        'current_no': _currentNoController.text,
        'current_building': _currentBuildingController.text,
        'current_floor': _currentFloorController.text,
        'current_room': _currentRoomController.text,
        'current_moo': _currentMooController.text,
        'current_soi': _currentSoiController.text,
        'current_road': _currentRoadController.text,
        'current_tambon': _currentTambonController.text,
        'current_amphoe': _currentAmphoeController.text,
        'current_province': _currentProvinceController.text,
        'current_postcode': _currentPostcodeController.text,
      });
    } else {
      // Copy from registration address
      widget.formData.addAll({
        'current_no': widget.formData['house_reg_no'] ?? '',
        'current_building': widget.formData['house_reg_building'] ?? '',
        'current_floor': widget.formData['house_reg_floor'] ?? '',
        'current_room': widget.formData['house_reg_room'] ?? '',
        'current_moo': widget.formData['house_reg_moo'] ?? '',
        'current_soi': widget.formData['house_reg_soi'] ?? '',
        'current_road': widget.formData['house_reg_road'] ?? '',
        'current_tambon': widget.formData['house_reg_tambon'] ?? '',
        'current_amphoe': widget.formData['house_reg_amphoe'] ?? '',
        'current_province': widget.formData['house_reg_province'] ?? '',
        'current_postcode': widget.formData['house_reg_postcode'] ?? '',
      });
    }
  }

  void _onSameAddressChanged(bool value) {
    setState(() {
      _sameAsRegistration = value;
      if (value) {
        // Clear current address fields
        _currentNoController.clear();
        _currentBuildingController.clear();
        _currentFloorController.clear();
        _currentRoomController.clear();
        _currentMooController.clear();
        _currentSoiController.clear();
        _currentRoadController.clear();
        _currentTambonController.clear();
        _currentAmphoeController.clear();
        _currentProvinceController.clear();
        _currentPostcodeController.clear();
      }
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
            // 🏠 Same Address Option
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        color: AppTheme.sapphireBlue,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ที่อยู่ปัจจุบัน',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Checkbox for same address
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _sameAsRegistration 
                        ? AppTheme.lightBlue.withOpacity(0.5)
                        : AppTheme.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _sameAsRegistration 
                          ? AppTheme.sapphireBlue.withOpacity(0.3)
                          : AppTheme.mediumBlue.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _sameAsRegistration,
                          onChanged: (value) {
                            _onSameAddressChanged(value ?? false);
                          },
                          activeColor: AppTheme.sapphireBlue,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่อยู่ปัจจุบันเหมือนทะเบียนบ้าน',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.deepNavy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'เลือกตัวเลือกนี้หากที่อยู่ปัจจุบันเหมือนกับที่อยู่ตามทะเบียนบ้าน',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.mediumGray,
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 📍 Current Address Fields (แสดงเฉพาะเมื่อไม่ได้เลือกเหมือนทะเบียนบ้าน)
            if (!_sameAsRegistration)
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ข้อมูลที่อยู่ปัจจุบัน',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Address Details Row 1
                    Row(
                      children: [
                        // House Number
                        Expanded(
                          flex: 2,
                          child: GlassInputField(
                            label: 'เลขที่',
                            hint: 'เลขที่บ้าน',
                            controller: _currentNoController,
                            validator: (value) {
                              if (!_sameAsRegistration && (value == null || value.isEmpty)) {
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
                            controller: _currentBuildingController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Floor
                        Expanded(
                          flex: 1,
                          child: GlassInputField(
                            label: 'ชั้น',
                            hint: 'ชั้น',
                            controller: _currentFloorController,
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
                            controller: _currentRoomController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Moo
                        Expanded(
                          flex: 1,
                          child: GlassInputField(
                            label: 'หมู่ที่',
                            hint: 'หมู่',
                            controller: _currentMooController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Soi
                        Expanded(
                          flex: 2,
                          child: GlassInputField(
                            label: 'ซอย',
                            hint: 'ซอย',
                            controller: _currentSoiController,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Road
                    GlassInputField(
                      label: 'ถนน',
                      hint: 'ชื่อถนน',
                      controller: _currentRoadController,
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
                            controller: _currentTambonController,
                            validator: (value) {
                              if (!_sameAsRegistration && (value == null || value.isEmpty)) {
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
                            controller: _currentAmphoeController,
                            validator: (value) {
                              if (!_sameAsRegistration && (value == null || value.isEmpty)) {
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
                                    value: _currentProvinceController.text.isEmpty ? null : _currentProvinceController.text,
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
                                        _currentProvinceController.text = value!;
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
                            controller: _currentPostcodeController,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            validator: (value) {
                              if (!_sameAsRegistration && (value == null || value.isEmpty)) {
                                return 'กรุณากรอกรหัสไปรษณีย์';
                              }
                              if (value != null && value.isNotEmpty && value.length != 5) {
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
                        'ตัวอย่างที่อยู่ปัจจุบัน',
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
                      _getFormattedCurrentAddress(),
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
                      _sameAsRegistration 
                        ? 'ที่อยู่ปัจจุบันจะเหมือนกับที่อยู่ตามทะเบียนบ้าน'
                        : 'ที่อยู่ปัจจุบันจะถูกใช้สำหรับการจัดส่งเอกสารและการติดต่อ',
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

  String _getFormattedCurrentAddress() {
    if (_sameAsRegistration) {
      // Return registration address
      final parts = <String>[];
      
      if (widget.formData['house_reg_no']?.isNotEmpty == true) {
        parts.add('เลขที่ ${widget.formData['house_reg_no']}');
      }
      
      if (widget.formData['house_reg_building']?.isNotEmpty == true) {
        parts.add('อาคาร ${widget.formData['house_reg_building']}');
      }
      
      if (widget.formData['house_reg_floor']?.isNotEmpty == true) {
        parts.add('ชั้น ${widget.formData['house_reg_floor']}');
      }
      
      if (widget.formData['house_reg_room']?.isNotEmpty == true) {
        parts.add('ห้อง ${widget.formData['house_reg_room']}');
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
      
      return parts.isEmpty ? 'ไม่มีข้อมูลที่อยู่' : parts.join(' ');
    } else {
      // Return current address
      final parts = <String>[];
      
      if (_currentNoController.text.isNotEmpty) {
        parts.add('เลขที่ ${_currentNoController.text}');
      }
      
      if (_currentBuildingController.text.isNotEmpty) {
        parts.add('อาคาร ${_currentBuildingController.text}');
      }
      
      if (_currentFloorController.text.isNotEmpty) {
        parts.add('ชั้น ${_currentFloorController.text}');
      }
      
      if (_currentRoomController.text.isNotEmpty) {
        parts.add('ห้อง ${_currentRoomController.text}');
      }
      
      if (_currentMooController.text.isNotEmpty) {
        parts.add('หมู่ที่ ${_currentMooController.text}');
      }
      
      if (_currentSoiController.text.isNotEmpty) {
        parts.add('ซอย${_currentSoiController.text}');
      }
      
      if (_currentRoadController.text.isNotEmpty) {
        parts.add('ถนน${_currentRoadController.text}');
      }
      
      if (_currentTambonController.text.isNotEmpty) {
        parts.add('ตำบล${_currentTambonController.text}');
      }
      
      if (_currentAmphoeController.text.isNotEmpty) {
        parts.add('อำเภอ${_currentAmphoeController.text}');
      }
      
      if (_currentProvinceController.text.isNotEmpty) {
        parts.add('จังหวัด${_currentProvinceController.text}');
      }
      
      if (_currentPostcodeController.text.isNotEmpty) {
        parts.add(_currentPostcodeController.text);
      }
      
      return parts.isEmpty ? 'ยังไม่มีข้อมูลที่อยู่' : parts.join(' ');
    }
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
