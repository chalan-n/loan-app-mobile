import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/file_upload_widget.dart';
import '../../services/storage_service.dart';
import '../../config/app_config.dart';

/// 📤 Document Upload Screen
/// หน้าจอสำหรับอัปโหลดเอกสารเฉพาะประเภท
class DocumentUploadScreen extends StatefulWidget {
  final String category;
  final String referenceId;
  final Function()? onUploadComplete;

  const DocumentUploadScreen({
    super.key,
    required this.category,
    required this.referenceId,
    this.onUploadComplete,
  });

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final List<FileMetadata> _uploadedFiles = [];
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        title: Text(
          'อัปโหลด${StorageService.getCategoryDisplayName(widget.category)}',
          style: const TextStyle(
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
        actions: [
          if (_uploadedFiles.isNotEmpty)
            TextButton(
              onPressed: _completeUpload,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.sapphireBlue,
              ),
              child: const Text('เสร็จสิ้น'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            _buildHeaderInfo(),
            
            const SizedBox(height: 20),
            
            // Upload Widget
            FileUploadWidget(
              category: widget.category,
              referenceId: widget.referenceId,
              onFileUploaded: (metadata) {
                setState(() {
                  _uploadedFiles.add(metadata);
                });
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppTheme.errorRed,
                  ),
                );
              },
              allowMultiple: true,
              maxFiles: AppConfig.maxFilesPerUpload,
            ),
            
            const SizedBox(height: 20),
            
            // Uploaded Files List
            if (_uploadedFiles.isNotEmpty) ...[
              _buildUploadedFilesList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.sapphireBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'ข้อมูลการอัปโหลด',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'ประเภท',
                  StorageService.getCategoryDisplayName(widget.category),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'รหัสอ้างอิง',
                  widget.referenceId,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'ไฟล์ที่อัปโหลด',
                  '${_uploadedFiles.length}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  'ขนาดสูงสุด',
                  '${AppConfig.maxFileSize} MB',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.deepNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadedFilesList() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppTheme.successGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'ไฟล์ที่อัปโหลดแล้ว',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successGreen,
                ),
              ),
              const Spacer(),
              Text(
                '${_uploadedFiles.length} ไฟล์',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          ..._uploadedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return _buildUploadedFileItem(index + 1, file);
          }),
        ],
      ),
    );
  }

  Widget _buildUploadedFileItem(int index, FileMetadata file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Index
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // File Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                file.fileIcon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.originalName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      file.formattedSize,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(file.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Success Icon
          Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _completeUpload() {
    if (_uploadedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาอัปโหลดอย่างน้อย 1 ไฟล์'),
          backgroundColor: AppTheme.warningAmber,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('อัปโหลดสำเร็จ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppTheme.successGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'อัปโหลดเอกสารสำเร็จแล้ว',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'อัปโหลด ${_uploadedFiles.length} ไฟล์เรียบร้อยแล้ว',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
              widget.onUploadComplete?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.sapphireBlue,
            ),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year + 543}';
  }
}
