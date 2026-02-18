import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../config/app_config.dart';

/// 📁 Storage Service สำหรับจัดการไฟล์กับ R2 Storage
/// รองรับการอัปโหลด, ดาวน์โหลด, และจัดการไฟล์
class StorageService {
  static const String _baseUrl = 'https://api.luxuryloan.com';
  static const String _bucketName = 'luxury-loan-documents';
  static const Duration _timeout = Duration(minutes: 5);
  
  // File type categories
  static const Map<String, List<String>> _fileCategories = {
    'documents': ['pdf', 'doc', 'docx', 'txt'],
    'images': ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
    'spreadsheets': ['xls', 'xlsx', 'csv'],
    'presentations': ['ppt', 'pptx'],
    'archives': ['zip', 'rar', '7z'],
  };

  /// 📤 Upload File to R2 Storage
  static Future<UploadResult> uploadFile({
    required File file,
    required String category,
    required String referenceId, // loan_id, guarantor_id, etc.
    String? description,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Validate file
      final validation = _validateFile(file);
      if (!validation.isValid) {
        return UploadResult.error(validation.error!);
      }

      // Generate unique file key
      final fileKey = _generateFileKey(file, category, referenceId);
      
      // Get presigned URL
      final presignedData = await getPresignedUploadUrl(fileKey, file);
      
      // Upload file with progress tracking
      final uploadResult = await _uploadWithProgress(
        file: file,
        url: presignedData['url'],
        fields: presignedData['fields'],
        onProgress: onProgress,
      );

      if (uploadResult.success) {
        // Save file metadata to database
        final metadata = await _saveFileMetadata(
          fileKey: fileKey,
          originalName: path.basename(file.path),
          category: category,
          referenceId: referenceId,
          description: description,
          fileSize: file.lengthSync(),
          mimeType: _getMimeType(file.path),
        );

        return UploadResult.success(
          fileUrl: presignedData['public_url'],
          fileKey: fileKey,
          metadata: metadata,
        );
      } else {
        return UploadResult.error(uploadResult.error!);
      }
    } catch (error) {
      debugPrint('Upload error: $error');
      return UploadResult.error('เกิดข้อผิดพลาดในการอัปโหลดไฟล์: $error');
    }
  }

  /// 📥 Download File from R2 Storage
  static Future<DownloadResult> downloadFile(String fileKey) async {
    try {
      // Get presigned download URL
      final downloadUrl = await getPresignedDownloadUrl(fileKey);
      
      // Download file
      final response = await http.get(Uri.parse(downloadUrl))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return DownloadResult.success(
          data: response.bodyBytes,
          contentType: response.headers['content-type'],
          contentLength: response.contentLength ?? 0,
        );
      } else {
        return DownloadResult.error('ไม่สามารถดาวน์โหลดไฟล์ได้ (HTTP ${response.statusCode})');
      }
    } catch (error) {
      debugPrint('Download error: $error');
      return DownloadResult.error('เกิดข้อผิดพลาดในการดาวน์โหลดไฟล์: $error');
    }
  }

  /// 🗑️ Delete File from R2 Storage
  static Future<bool> deleteFile(String fileKey) async {
    try {
      // Delete from storage
      final deleteUrl = '$_baseUrl/api/storage/delete/$fileKey';
      final response = await http.delete(Uri.parse(deleteUrl))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        // Delete metadata from database
        await _deleteFileMetadata(fileKey);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint('Delete error: $error');
      return false;
    }
  }

  /// 📋 Get File List
  static Future<List<FileMetadata>> getFiles({
    String? referenceId,
    String? category,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      
      if (referenceId != null) queryParams['reference_id'] = referenceId;
      if (category != null) queryParams['category'] = category;

      final uri = Uri.parse('$_baseUrl/api/storage/files')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = (data['files'] as List)
            .map((file) => FileMetadata.fromJson(file))
            .toList();
        return files;
      } else {
        throw Exception('Failed to load files: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Get files error: $error');
      return [];
    }
  }

  /// 🔍 Search Files
  static Future<List<FileMetadata>> searchFiles({
    required String query,
    String? referenceId,
    String? category,
  }) async {
    try {
      final queryParams = <String, String>{
        'q': query,
      };
      
      if (referenceId != null) queryParams['reference_id'] = referenceId;
      if (category != null) queryParams['category'] = category;

      final uri = Uri.parse('$_baseUrl/api/storage/search')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = (data['files'] as List)
            .map((file) => FileMetadata.fromJson(file))
            .toList();
        return files;
      } else {
        throw Exception('Failed to search files: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Search files error: $error');
      return [];
    }
  }

  /// 📊 Get Storage Statistics
  static Future<StorageStats> getStorageStats({String? referenceId}) async {
    try {
      final queryParams = referenceId != null 
        ? {'reference_id': referenceId}
        : <String, String>{};

      final uri = Uri.parse('$_baseUrl/api/storage/stats')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StorageStats.fromJson(data);
      } else {
        throw Exception('Failed to get storage stats: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Storage stats error: $error');
      return StorageStats.empty();
    }
  }

  /// 🔧 Private Methods

  static FileValidation _validateFile(File file) {
    // Check if file exists
    if (!file.existsSync()) {
      return FileValidation.error('ไม่พบไฟล์');
    }

    // Check file size
    final fileSize = file.lengthSync();
    if (fileSize > AppConfig.maxFileSize * 1024 * 1024) {
      return FileValidation.error('ขนาดไฟล์เกิน ${AppConfig.maxFileSize} MB');
    }

    // Check file type
    final fileName = path.basename(file.path);
    final extension = path.extension(fileName).substring(1).toLowerCase();
    
    if (!AppConfig.isFileTypeAllowed(fileName)) {
      return FileValidation.error('ไม่รองรับไฟล์ประเภท .$extension');
    }

    return FileValidation.valid();
  }

  static String _generateFileKey(File file, String category, String referenceId) {
    final fileName = path.basename(file.path);
    final extension = path.extension(fileName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid = const Uuid().v4().substring(0, 8);
    
    return '$category/$referenceId/${timestamp}_$uuid$extension';
  }

  static String _getMimeType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    return mimeType ?? 'application/octet-stream';
  }

    static Future<Map<String, dynamic>> getPresignedUploadUrl(String fileKey, File file) async {
    final mimeType = _getMimeType(file.path);
    final fileSize = file.lengthSync();
    
    final response = await http.post(
      Uri.parse('$_baseUrl/api/storage/upload-url'),
      headers: AppConfig.getApiHeaders(),
      body: jsonEncode({
        'file_key': fileKey,
        'content_type': mimeType,
        'file_size': fileSize,
      }),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to get presigned upload URL: ${response.statusCode}');
    }
  }

  static Future<String> getPresignedDownloadUrl(String fileKey) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/storage/download-url'),
      headers: AppConfig.getApiHeaders(),
      body: jsonEncode({'file_key': fileKey}),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to get presigned download URL: ${response.statusCode}');
    }
  }

  static Future<UploadProgress> _uploadWithProgress({
    required File file,
    required String url,
    required Map<String, String> fields,
    ProgressCallback? onProgress,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Add form fields
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add file
      final fileBytes = await file.readAsBytes();
      final fileSize = fileBytes.length;
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: path.basename(file.path),
      ));

      // Send request with progress tracking
      final streamedResponse = await request.send().timeout(_timeout);
      
      if (streamedResponse.statusCode == 204 || streamedResponse.statusCode == 200) {
        return UploadProgress.success();
      } else {
        final response = await http.Response.fromStream(streamedResponse);
        return UploadProgress.error('Upload failed: ${response.statusCode}');
      }
    } catch (error) {
      return UploadProgress.error('Upload error: $error');
    }
  }

  static Future<FileMetadata> _saveFileMetadata({
    required String fileKey,
    required String originalName,
    required String category,
    required String referenceId,
    String? description,
    required int fileSize,
    required String mimeType,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/storage/metadata'),
      headers: AppConfig.getApiHeaders(),
      body: jsonEncode({
        'file_key': fileKey,
        'original_name': originalName,
        'category': category,
        'reference_id': referenceId,
        'description': description,
        'file_size': fileSize,
        'mime_type': mimeType,
        'created_at': DateTime.now().toIso8601String(),
      }),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return FileMetadata.fromJson(data);
    } else {
      throw Exception('Failed to save file metadata: ${response.statusCode}');
    }
  }

  static Future<void> _deleteFileMetadata(String fileKey) async {
    await http.delete(
      Uri.parse('$_baseUrl/api/storage/metadata/$fileKey'),
      headers: AppConfig.getApiHeaders(),
    ).timeout(_timeout);
  }

  /// 🎯 Utility Methods

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String getFileIcon(String mimeType) {
    if (mimeType.startsWith('image/')) return '🖼️';
    if (mimeType.startsWith('video/')) return '🎥';
    if (mimeType.startsWith('audio/')) return '🎵';
    if (mimeType.contains('pdf')) return '📄';
    if (mimeType.contains('word') || mimeType.contains('document')) return '📝';
    if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) return '📊';
    if (mimeType.contains('powerpoint') || mimeType.contains('presentation')) return '📽️';
    if (mimeType.contains('zip') || mimeType.contains('archive')) return '📦';
    return '📄';
  }

  static List<String> getAllowedFileTypes(String category) {
    return _fileCategories[category] ?? [];
  }

  static bool isCategoryAllowed(String category) {
    return _fileCategories.containsKey(category);
  }

  static String getCategoryDisplayName(String category) {
    switch (category) {
      case 'documents':
        return 'เอกสาร';
      case 'images':
        return 'รูปภาพ';
      case 'spreadsheets':
        return 'ตารางคำนวณ';
      case 'presentations':
        return 'งานนำเสนอ';
      case 'archives':
        return 'ไฟล์บีบอัด';
      default:
        return category;
    }
  }
}

/// 📊 Data Models

class UploadResult {
  final bool success;
  final String? fileUrl;
  final String? fileKey;
  final FileMetadata? metadata;
  final String? error;

  UploadResult({
    required this.success,
    this.fileUrl,
    this.fileKey,
    this.metadata,
    this.error,
  });

  factory UploadResult.success({
    required String fileUrl,
    required String fileKey,
    required FileMetadata metadata,
  }) {
    return UploadResult(
      success: true,
      fileUrl: fileUrl,
      fileKey: fileKey,
      metadata: metadata,
    );
  }

  factory UploadResult.error(String error) {
    return UploadResult(
      success: false,
      error: error,
    );
  }
}

class DownloadResult {
  final bool success;
  final Uint8List? data;
  final String? contentType;
  final int? contentLength;
  final String? error;

  DownloadResult({
    required this.success,
    this.data,
    this.contentType,
    this.contentLength,
    this.error,
  });

  factory DownloadResult.success({
    required Uint8List data,
    String? contentType,
    int? contentLength,
  }) {
    return DownloadResult(
      success: true,
      data: data,
      contentType: contentType,
      contentLength: contentLength,
    );
  }

  factory DownloadResult.error(String error) {
    return DownloadResult(
      success: false,
      error: error,
    );
  }
}

class FileMetadata {
  final String id;
  final String fileKey;
  final String originalName;
  final String category;
  final String referenceId;
  final String? description;
  final int fileSize;
  final String mimeType;
  final String fileUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FileMetadata({
    required this.id,
    required this.fileKey,
    required this.originalName,
    required this.category,
    required this.referenceId,
    this.description,
    required this.fileSize,
    required this.mimeType,
    required this.fileUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory FileMetadata.fromJson(Map<String, dynamic> json) {
    return FileMetadata(
      id: json['id'] ?? '',
      fileKey: json['file_key'] ?? '',
      originalName: json['original_name'] ?? '',
      category: json['category'] ?? '',
      referenceId: json['reference_id'] ?? '',
      description: json['description'],
      fileSize: json['file_size'] ?? 0,
      mimeType: json['mime_type'] ?? '',
      fileUrl: json['file_url'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'])
        : null,
    );
  }

  String get formattedSize => StorageService.formatFileSize(fileSize);
  String get fileIcon => StorageService.getFileIcon(mimeType);
  String get categoryDisplayName => StorageService.getCategoryDisplayName(category);
}

class StorageStats {
  final int totalFiles;
  final int totalSize;
  final Map<String, int> filesByCategory;
  final Map<String, int> sizeByCategory;

  StorageStats({
    required this.totalFiles,
    required this.totalSize,
    required this.filesByCategory,
    required this.sizeByCategory,
  });

  factory StorageStats.fromJson(Map<String, dynamic> json) {
    return StorageStats(
      totalFiles: json['total_files'] ?? 0,
      totalSize: json['total_size'] ?? 0,
      filesByCategory: Map<String, int>.from(json['files_by_category'] ?? {}),
      sizeByCategory: Map<String, int>.from(json['size_by_category'] ?? {}),
    );
  }

  factory StorageStats.empty() {
    return StorageStats(
      totalFiles: 0,
      totalSize: 0,
      filesByCategory: {},
      sizeByCategory: {},
    );
  }

  String get formattedTotalSize => StorageService.formatFileSize(totalSize);
}

class PresignedUrl {
  final String url;
  final Map<String, String> fields;
  final String publicUrl;

  PresignedUrl({
    required this.url,
    required this.fields,
    required this.publicUrl,
  });

  factory PresignedUrl.fromJson(Map<String, dynamic> json) {
    return PresignedUrl(
      url: json['url'] ?? '',
      fields: Map<String, String>.from(json['fields'] ?? {}),
      publicUrl: json['public_url'] ?? '',
    );
  }
}

class FileValidation {
  final bool isValid;
  final String? error;

  FileValidation({required this.isValid, this.error});

  factory FileValidation.valid() {
    return FileValidation(isValid: true);
  }

  factory FileValidation.error(String error) {
    return FileValidation(isValid: false, error: error);
  }
}

class UploadProgress {
  final bool success;
  final String? error;

  UploadProgress({required this.success, this.error});

  factory UploadProgress.success() {
    return UploadProgress(success: true);
  }

  factory UploadProgress.error(String error) {
    return UploadProgress(success: false, error: error);
  }
}

// Type alias for progress callback
typedef ProgressCallback = void Function(double progress);
