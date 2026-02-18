import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/file_upload_widget.dart';
import '../../services/storage_service.dart';
import '../../config/app_config.dart';
import 'document_upload_screen.dart';

/// 📁 Document List Screen
/// หน้าจอแสดงรายการเอกสารทั้งหมด
class DocumentListScreen extends StatefulWidget {
  final String? referenceId;
  final String? category;
  final bool allowUpload;
  final Function(FileMetadata)? onDocumentSelected;

  const DocumentListScreen({
    super.key,
    this.referenceId,
    this.category,
    this.allowUpload = true,
    this.onDocumentSelected,
  });

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FileMetadata> _documents = [];
  List<FileMetadata> _filteredDocuments = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  StorageStats? _storageStats;

  final List<String> _categories = [
    'all',
    'documents',
    'images',
    'spreadsheets',
    'presentations',
    'archives',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadDocuments();
    _loadStorageStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: const Text(
          'เอกสาร',
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
          isScrollable: true,
          labelColor: AppTheme.sapphireBlue,
          unselectedLabelColor: AppTheme.mediumGray,
          indicatorColor: AppTheme.sapphireBlue,
          tabs: _categories.map((category) => Tab(
            text: StorageService.getCategoryDisplayName(category),
          )).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.deepNavy),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.deepNavy),
            onPressed: _refreshDocuments,
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage Stats
          if (_storageStats != null) _buildStorageStats(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Documents List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildDocumentList(category);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.allowUpload 
        ? FloatingActionButton(
            onPressed: _showUploadOptions,
            backgroundColor: AppTheme.sapphireBlue,
            child: const Icon(Icons.add, color: AppTheme.pureWhite),
          )
        : null,
    );
  }

  Widget _buildStorageStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightBlue.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.storage,
            color: AppTheme.sapphireBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'พื้นที่ใช้งาน: ${_storageStats!.formattedTotalSize}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.sapphireBlue,
                  ),
                ),
                Text(
                  'จำนวนไฟล์: ${_storageStats!.totalFiles}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.info_outline,
            color: AppTheme.mediumGray,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _filterDocuments();
          });
        },
        decoration: InputDecoration(
          hintText: 'ค้นหาเอกสาร...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _filterDocuments();
                  });
                },
              )
            : null,
          border: OutlineInputBorder(
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
      ),
    );
  }

  Widget _buildDocumentList(String category) {
    final documents = category == 'all' 
      ? _filteredDocuments
      : _filteredDocuments.where((doc) => doc.category == category).toList();

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.sapphireBlue,
        ),
      );
    }

    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: AppTheme.mediumGray,
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่มีเอกสารในหมวดนี้',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            if (widget.allowUpload) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showUploadOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sapphireBlue,
                  foregroundColor: AppTheme.pureWhite,
                ),
                child: const Text('อัปโหลดเอกสาร'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshDocuments,
      color: AppTheme.sapphireBlue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final document = documents[index];
          return _buildDocumentCard(document);
        },
      ),
    );
  }

  Widget _buildDocumentCard(FileMetadata document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () => _openDocument(document),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // File Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        document.fileIcon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // File Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.originalName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.sapphireBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                document.categoryDisplayName,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.sapphireBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              document.formattedSize,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Menu Button
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppTheme.mediumGray,
                    ),
                    onSelected: (value) => _handleMenuAction(value, document),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 16),
                            SizedBox(width: 8),
                            Text('ดาวน์โหลด'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share, size: 16),
                            SizedBox(width: 8),
                            Text('แชร์'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: AppTheme.errorRed),
                            SizedBox(width: 8),
                            Text('ลบ', style: TextStyle(color: AppTheme.errorRed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              if (document.description != null && document.description!.isNotEmpty) ...[
                Text(
                  document.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Date Info
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppTheme.mediumGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'อัปโหลดเมื่อ: ${_formatDate(document.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final documents = await StorageService.getFiles(
        referenceId: widget.referenceId,
        category: widget.category,
      );
      
      setState(() {
        _documents = documents;
        _filteredDocuments = documents;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถโหลดเอกสาร: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _loadStorageStats() async {
    try {
      final stats = await StorageService.getStorageStats(
        referenceId: widget.referenceId,
      );
      
      setState(() {
        _storageStats = stats;
      });
    } catch (error) {
      debugPrint('Failed to load storage stats: $error');
    }
  }

  Future<void> _refreshDocuments() async {
    await _loadDocuments();
    await _loadStorageStats();
  }

  void _filterDocuments() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredDocuments = _documents;
      } else {
        _filteredDocuments = _documents.where((doc) {
          return doc.originalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                 (doc.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ค้นหาเอกสาร'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'พิมพ์คำค้นหา...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filterDocuments();
            });
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.snowWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'เลือกประเภทเอกสาร',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...['documents', 'images', 'spreadsheets', 'presentations'].map((category) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    _getCategoryIcon(category),
                    color: AppTheme.sapphireBlue,
                  ),
                  title: Text(StorageService.getCategoryDisplayName(category)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showUploadScreen(category);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showUploadScreen(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentUploadScreen(
          category: category,
          referenceId: widget.referenceId ?? '',
          onUploadComplete: () {
            _refreshDocuments();
          },
        ),
      ),
    );
  }

  void _openDocument(FileMetadata document) {
    widget.onDocumentSelected?.call(document);
  }

  void _handleMenuAction(String action, FileMetadata document) async {
    switch (action) {
      case 'download':
        await _downloadDocument(document);
        break;
      case 'share':
        await _shareDocument(document);
        break;
      case 'delete':
        await _deleteDocument(document);
        break;
    }
  }

  Future<void> _downloadDocument(FileMetadata document) async {
    try {
      final result = await StorageService.downloadFile(document.fileKey);
      
      if (result.success && result.data != null) {
        // TODO: Save file to device
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ดาวน์โหลดสำเร็จแล้ว'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      } else {
        throw Exception(result.error ?? 'Download failed');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถดาวน์โหลดได้: $error'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _shareDocument(FileMetadata document) async {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('คุณลักษณะการแชร์ยังไม่พร้อมใช้งาน'),
        backgroundColor: AppTheme.warningAmber,
      ),
    );
  }

  Future<void> _deleteDocument(FileMetadata document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบเอกสาร "${document.originalName}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await StorageService.deleteFile(document.fileKey);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ลบเอกสารสำเร็จแล้ว'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          _refreshDocuments();
        } else {
          throw Exception('Delete failed');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่สามารถลบได้: $error'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'documents':
        return Icons.description;
      case 'images':
        return Icons.image;
      case 'spreadsheets':
        return Icons.table_chart;
      case 'presentations':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year + 543} '
           '${date.hour.toString().padLeft(2, '0')}:'
           '${date.minute.toString().padLeft(2, '0')}';
  }
}
