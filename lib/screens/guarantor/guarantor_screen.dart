import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../bloc/guarantor_bloc.dart';
import '../../bloc/auth_bloc.dart';

/// 👥 Guarantor Management Screen
/// หน้าจอหลักสำหรับจัดการผู้ค้ำประกัน
class GuarantorScreen extends StatefulWidget {
  final String? loanId;
  
  const GuarantorScreen({super.key, this.loanId});

  @override
  State<GuarantorScreen> createState() => _GuarantorScreenState();
}

class _GuarantorScreenState extends State<GuarantorScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load guarantors if loanId is provided
    if (widget.loanId != null) {
      context.read<GuarantorBloc>().add(LoadGuarantors(widget.loanId!));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: const Text(
          'จัดการผู้ค้ำประกัน',
          style: TextStyle(
            color: AppTheme.deepNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppTheme.snowWhite,
        foregroundColor: AppTheme.deepNavy,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.sapphireBlue,
          unselectedLabelColor: AppTheme.mediumGray,
          indicatorColor: AppTheme.sapphireBlue,
          tabs: const [
            Tab(text: 'รายการผู้ค้ำ'),
            Tab(text: 'เพิ่มผู้ค้ำ'),
            Tab(text: 'ค้นหา'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGuarantorListTab(),
          _buildAddGuarantorTab(),
          _buildSearchTab(),
        ],
      ),
    );
  }

  /// 📋 Tab 1: รายการผู้ค้ำประกัน
  Widget _buildGuarantorListTab() {
    return BlocBuilder<GuarantorBloc, GuarantorState>(
      builder: (context, state) {
        if (state is GuarantorLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.sapphireBlue,
            ),
          );
        }
        
        if (state is GuarantorError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorRed,
                ),
                const SizedBox(height: 16),
                Text(
                  state.error,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.errorRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GlassButton(
                  text: 'ลองอีกครั้ง',
                  onPressed: () {
                    if (widget.loanId != null) {
                      context.read<GuarantorBloc>().add(LoadGuarantors(widget.loanId!));
                    }
                  },
                ),
              ],
            ),
          );
        }
        
        if (state is GuarantorLoaded) {
          if (state.guarantors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 64,
                    color: AppTheme.mediumGray,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีข้อมูลผู้ค้ำประกัน',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassButton(
                    text: 'เพิ่มผู้ค้ำประกัน',
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              if (widget.loanId != null) {
                context.read<GuarantorBloc>().add(LoadGuarantors(widget.loanId!));
              }
            },
            color: AppTheme.sapphireBlue,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.guarantors.length,
              itemBuilder: (context, index) {
                final guarantor = state.guarantors[index];
                return _buildGuarantorCard(guarantor);
              },
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  /// ➕ Tab 2: เพิ่มผู้ค้ำประกัน
  Widget _buildAddGuarantorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                      'เพิ่มผู้ค้ำประกันใหม่',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'กรุณากรอกข้อมูลผู้ค้ำประกันให้ครบถ้วน',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Add Options
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      context.go('/guarantor/add/individual');
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppTheme.sapphireBlue,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'บุคคลธรรมดา',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เพิ่มผู้ค้ำประกันบุคคลธรรมดา',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      context.go('/guarantor/add/juristic');
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.business,
                          color: AppTheme.sapphireBlue,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'นิติบุคคล',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เพิ่มผู้ค้ำประกันนิติบุคคล',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Recent Guarantors
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: AppTheme.sapphireBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ผู้ค้ำประกันล่าสุด',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Mock recent guarantors
                _buildRecentGuarantorItem(
                  'นาย สมชาย ใจดี',
                  'บุคคลธรรมดา',
                  'เพิ่มเมื่อ 2 วันที่แล้ว',
                ),
                
                const SizedBox(height: 12),
                
                _buildRecentGuarantorItem(
                  'บริษัท XYZ คอร์ปอเรชั่น',
                  'นิติบุคคล',
                  'เพิ่มเมื่อ 5 วันที่แล้ว',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔍 Tab 3: ค้นหาผู้ค้ำประกัน
  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Header
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppTheme.sapphireBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ค้นหาผู้ค้ำประกัน',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Search Input
                GlassInputField(
                  controller: _searchController,
                  label: 'ค้นหาด้วยชื่อ, เลขบัตรประชาชน หรือเบอร์โทรศัพท์',
                  prefixIcon: Icons.search,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      context.read<GuarantorBloc>().add(SearchGuarantors(value));
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Search Filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'ประเภทผู้ค้ำ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.mediumBlue.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.mediumBlue.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.sapphireBlue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppTheme.lightBlue.withOpacity(0.1),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('ทั้งหมด')),
                          DropdownMenuItem(value: 'individual', child: Text('บุคคลธรรมดา')),
                          DropdownMenuItem(value: 'juristic', child: Text('นิติบุคคล')),
                        ],
                        onChanged: (value) {
                          // TODO: Apply filter
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'สถานะ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.mediumBlue.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.mediumBlue.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.sapphireBlue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppTheme.lightBlue.withOpacity(0.1),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('ทั้งหมด')),
                          DropdownMenuItem(value: 'synced', child: Text('Synced')),
                          DropdownMenuItem(value: 'pending', child: Text('Pending')),
                          DropdownMenuItem(value: 'error', child: Text('Error')),
                        ],
                        onChanged: (value) {
                          // TODO: Apply filter
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Search Results
          BlocBuilder<GuarantorBloc, GuarantorState>(
            builder: (context, state) {
              if (state is GuarantorLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.sapphireBlue,
                  ),
                );
              }
              
              if (state is GuarantorLoaded) {
                if (state.guarantors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ไม่พบผลการค้นหา',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.guarantors.length,
                  itemBuilder: (context, index) {
                    final guarantor = state.guarantors[index];
                    return _buildGuarantorCard(guarantor);
                  },
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  /// 🎴 Guarantor Card
  Widget _buildGuarantorCard(Map<String, dynamic> guarantor) {
    final guarantorType = guarantor['guarantor_type'] ?? 'individual';
    final title = guarantor['title'] ?? '';
    final firstName = guarantor['first_name'] ?? '';
    final lastName = guarantor['last_name'] ?? '';
    final fullName = '$title $firstName $lastName';
    final idCard = guarantor['id_card'] ?? '';
    final mobilePhone = guarantor['mobile_phone'] ?? '';
    final companyName = guarantor['company_name'] ?? '';
    final syncStatus = guarantor['sync_status'] ?? 'unknown';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Type Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: guarantorType == 'individual' 
                      ? AppTheme.lightBlue.withOpacity(0.3)
                      : AppTheme.mediumBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    guarantorType == 'individual' ? Icons.person : Icons.business,
                    color: AppTheme.sapphireBlue,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Name and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guarantorType == 'individual' ? 'บุคคลธรรมดา' : 'นิติบุคคล',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Sync Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSyncStatusColor(syncStatus).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    syncStatus.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getSyncStatusColor(syncStatus),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Details
            if (idCard.isNotEmpty) ...[
              _buildDetailRow(Icons.credit_card, 'เลขบัตร', idCard),
            ],
            
            if (mobilePhone.isNotEmpty) ...[
              _buildDetailRow(Icons.phone, 'เบอร์โทร', mobilePhone),
            ],
            
            if (companyName.isNotEmpty) ...[
              _buildDetailRow(Icons.business, 'บริษัท', companyName),
            ],
            
            const SizedBox(height: 12),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Edit guarantor
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.sapphireBlue),
                      foregroundColor: AppTheme.sapphireBlue,
                    ),
                    child: const Text('แก้ไข'),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: View details
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.deepNavy),
                      foregroundColor: AppTheme.deepNavy,
                    ),
                    child: const Text('ดูรายละเอียด'),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmation(guarantor);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.errorRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.mediumGray,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGuarantorItem(String name, String type, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            size: 16,
            color: AppTheme.mediumGray,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$type • $time',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.mediumGray,
          ),
        ],
      ),
    );
  }

  Color _getSyncStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'synced':
        return AppTheme.successGreen;
      case 'pending':
        return AppTheme.warningAmber;
      case 'error':
        return AppTheme.errorRed;
      default:
        return AppTheme.mediumGray;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> guarantor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบผู้ค้ำประกันนี้ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<GuarantorBloc>().add(DeleteGuarantor(guarantor['id']));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }
}
