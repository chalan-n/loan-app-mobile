import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';

/// 📁 File Upload Widget
/// วิดเจ็ตสำหรับอัปโหลดไฟล์พร้อม Progress Tracking
class FileUploadWidget extends StatefulWidget {
  final String category;
  final String referenceId;
  final Function(FileMetadata)? onFileUploaded;
  final Function(String)? onError;
  final bool allowMultiple;
  final int maxFiles;
  final List<String> allowedCategories;

  const FileUploadWidget({
    super.key,
    required this.category,
    required this.referenceId,
    this.onFileUploaded,
    this.onError,
    this.allowMultiple = false,
    this.maxFiles = 5,
    this.allowedCategories = const ['documents', 'images'],
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  final List<FileUploadItem> _uploadItems = [];
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: AppTheme.sapphireBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'อัปโหลดไฟล์',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (_uploadItems.isNotEmpty)
                Text(
                  '${_uploadItems.length}/${widget.maxFiles}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Category Info
          _buildCategoryInfo(),
          
          const SizedBox(height: 16),
          
          // Upload Actions
          _buildUploadActions(),
          
          const SizedBox(height: 20),
          
          // Upload List
          if (_uploadItems.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 16),
            _buildUploadList(),
          ],
          
          // Progress Indicator
          if (_isUploading) ...[
            const SizedBox(height: 20),
            _buildGlobalProgress(),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                size: 16,
                color: AppTheme.sapphireBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'ประเภท: ${StorageService.getCategoryDisplayName(widget.category)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.sapphireBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ไฟล์ที่รองรับ: ${_getAllowedFileTypes().join(', ')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          Text(
            'ขนาดสูงสุด: ${AppConfig.maxFileSize} MB',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadActions() {
    return Row(
      children: [
        // Camera Upload
        if (widget.category == 'images') ...[
          Expanded(
            child: _buildActionButton(
              'ถ่ายรูป',
              Icons.camera_alt,
              AppTheme.sapphireBlue,
              () => _pickImageFromCamera(),
            ),
          ),
          const SizedBox(width: 12),
        ],
        
        // Gallery Upload
        if (widget.category == 'images') ...[
          Expanded(
            child: _buildActionButton(
              'เลือกรูป',
              Icons.photo_library,
              AppTheme.deepNavy,
              () => _pickImageFromGallery(),
            ),
          ),
          const SizedBox(width: 12),
        ],
        
        // File Upload
        Expanded(
          child: _buildActionButton(
            'เลือกไฟล์',
            Icons.file_upload,
            AppTheme.successGreen,
            () => _pickFiles(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return GlassButton(
      text: label,
      onPressed: _uploadItems.length >= widget.maxFiles ? null : onPressed,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      icon: icon,
    );
  }

  Widget _buildUploadList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ไฟล์ที่เลือก',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._uploadItems.map((item) => _buildUploadItem(item)),
      ],
    );
  }

  Widget _buildUploadItem(FileUploadItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.snowWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getItemBorderColor(item.status),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // File Info Row
          Row(
            children: [
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
                    item.fileIcon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // File Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.formattedSize,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Icon
              _buildStatusIcon(item.status),
              
              const SizedBox(width: 8),
              
              // Remove Button
              if (item.status != UploadStatus.uploading)
                IconButton(
                  onPressed: () => _removeUploadItem(item),
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.errorRed,
                    size: 20,
                  ),
                ),
            ],
          ),
          
          // Progress Bar
          if (item.status == UploadStatus.uploading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: item.progress,
              backgroundColor: AppTheme.lightBlue.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.sapphireBlue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'กำลังอัปโหลด...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.sapphireBlue,
                  ),
                ),
                Text(
                  '${(item.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.sapphireBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          
          // Error Message
          if (item.status == UploadStatus.error && item.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Success Message
          if (item.status == UploadStatus.completed) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: AppTheme.successGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'อัปโหลดสำเร็จแล้ว',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(UploadStatus status) {
    switch (status) {
      case UploadStatus.pending:
        return Icon(
          Icons.schedule,
          color: AppTheme.mediumGray,
          size: 20,
        );
      case UploadStatus.uploading:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.sapphireBlue),
          ),
        );
      case UploadStatus.completed:
        return Icon(
          Icons.check_circle,
          color: AppTheme.successGreen,
          size: 20,
        );
      case UploadStatus.error:
        return Icon(
          Icons.error,
          color: AppTheme.errorRed,
          size: 20,
        );
    }
  }

  Widget _buildGlobalProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.sapphireBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: AppTheme.sapphireBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'กำลังอัปโหลดไฟล์...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sapphireBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            backgroundColor: AppTheme.lightBlue.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.sapphireBlue),
          ),
        ],
      ),
    );
  }

  Color _getItemBorderColor(UploadStatus status) {
    switch (status) {
      case UploadStatus.pending:
        return AppTheme.mediumGray.withOpacity(0.3);
      case UploadStatus.uploading:
        return AppTheme.sapphireBlue.withOpacity(0.5);
      case UploadStatus.completed:
        return AppTheme.successGreen.withOpacity(0.5);
      case UploadStatus.error:
        return AppTheme.errorRed.withOpacity(0.5);
    }
  }

  List<String> _getAllowedFileTypes() {
    return StorageService.getAllowedFileTypes(widget.category);
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final file = File(image.path);
        _addUploadItem(file);
      }
    } catch (error) {
      _showError('ไม่สามารถถ่ายรูปได้: $error');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final file = File(image.path);
        _addUploadItem(file);
      }
    } catch (error) {
      _showError('ไม่สามารถเลือกรูปได้: $error');
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _getAllowedFileTypes(),
        allowMultiple: widget.allowMultiple,
      );

      if (result != null) {
        final files = result.paths.map((path) => File(path!)).toList();
        
        for (final file in files) {
          if (_uploadItems.length < widget.maxFiles) {
            _addUploadItem(file);
          } else {
            _showError('เลือกไฟล์ได้สูงสุด ${widget.maxFiles} ไฟล์');
            break;
          }
        }
      }
    } catch (error) {
      _showError('ไม่สามารถเลือกไฟล์ได้: $error');
    }
  }

  void _addUploadItem(File file) {
    if (_uploadItems.length >= widget.maxFiles) {
      _showError('เลือกไฟล์ได้สูงสุด ${widget.maxFiles} ไฟล์');
      return;
    }

    final uploadItem = FileUploadItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      file: file,
      fileName: file.path.split('/').last,
      fileSize: file.lengthSync(),
      mimeType: _getMimeType(file.path),
    );

    setState(() {
      _uploadItems.add(uploadItem);
    });

    // Start upload immediately
    _uploadFile(uploadItem);
  }

  void _removeUploadItem(FileUploadItem item) {
    setState(() {
      _uploadItems.remove(item);
    });
  }

  Future<void> _uploadFile(FileUploadItem item) async {
    setState(() {
      item.status = UploadStatus.uploading;
      item.progress = 0.0;
    });

    try {
      final result = await StorageService.uploadFile(
        file: item.file,
        category: widget.category,
        referenceId: widget.referenceId,
        onProgress: (progress) {
          setState(() {
            item.progress = progress;
          });
        },
      );

      if (result.success && result.metadata != null) {
        setState(() {
          item.status = UploadStatus.completed;
          item.progress = 1.0;
          item.metadata = result.metadata;
        });

        widget.onFileUploaded?.call(result.metadata!);
      } else {
        setState(() {
          item.status = UploadStatus.error;
          item.errorMessage = result.error ?? 'เกิดข้อผิดพลาด';
        });

        widget.onError?.call(result.error ?? 'เกิดข้อผิดพลาด');
      }
    } catch (error) {
      setState(() {
        item.status = UploadStatus.error;
        item.errorMessage = error.toString();
      });

      widget.onError?.call(error.toString());
    } finally {
      _updateGlobalUploadingStatus();
    }
  }

  void _updateGlobalUploadingStatus() {
    final hasUploadingItems = _uploadItems
        .any((item) => item.status == UploadStatus.uploading);
    
    setState(() {
      _isUploading = hasUploadingItems;
    });
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'csv':
        return 'text/csv';
      default:
        return 'application/octet-stream';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
    widget.onError?.call(message);
  }
}

/// 📁 File Upload Item Model
class FileUploadItem {
  final String id;
  final File file;
  final String fileName;
  final int fileSize;
  final String mimeType;
  UploadStatus status = UploadStatus.pending;
  double progress = 0.0;
  String? errorMessage;
  FileMetadata? metadata;

  FileUploadItem({
    required this.id,
    required this.file,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });

  String get formattedSize => StorageService.formatFileSize(fileSize);
  String get fileIcon => StorageService.getFileIcon(mimeType);
}

/// 📊 Upload Status Enum
enum UploadStatus {
  pending,
  uploading,
  completed,
  error,
}
