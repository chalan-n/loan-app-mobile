import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 🖼️ ImagePreprocessor — ปรับภาพให้ OCR อ่านได้ดีขึ้น
/// ทำงานใน Isolate เพื่อไม่บล็อค UI thread
class ImagePreprocessor {
  /// Preprocess ภาพบัตรประชาชนก่อนส่ง OCR
  /// - Contrast Enhancement (factor 1.35 เหมือน backend)
  /// - Sharpening kernel (Laplacian 3x3)
  /// คืน File ชั่วคราว JPEG ที่ preprocess แล้ว
  /// หาก preprocess ล้มเหลวจะคืน original file
  static Future<File> preprocessIDCard(File sourceFile) async {
    final bytes = await sourceFile.readAsBytes();

    // ทำงานใน Isolate แยก thread เพื่อไม่บล็อค UI
    final result = await Isolate.run<Uint8List?>(() => _processBytes(bytes));

    if (result == null) {
      return sourceFile;
    }

    // บันทึกไฟล์ชั่วคราวเป็น JPEG
    final tmpDir = await getTemporaryDirectory();
    final outPath = p.join(
      tmpDir.path,
      'preprocess_idcard_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final outFile = File(outPath);
    await outFile.writeAsBytes(result);
    return outFile;
  }

  /// ทำงานจริงใน Isolate — ห้ามใช้ Flutter API หรือ async
  static Uint8List? _processBytes(Uint8List bytes) {
    try {
      final src = img.decodeImage(bytes);
      if (src == null) return null;

      // ── 1. Contrast Enhancement ────────────────────────────────
      // ใช้ adjustColor ของ image package (รองรับ v4.x)
      final contrasted = img.adjustColor(
        src,
        contrast: 1.35,
      );

      // ── 2. Sharpen (Laplacian kernel) ─────────────────────────
      // [  0, -1,  0 ]
      // [ -1,  5, -1 ]
      // [  0, -1,  0 ]
      final sharpened = img.convolution(
        contrasted,
        filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
        div: 1,
        offset: 0,
      );

      // ── 3. Encode เป็น JPEG quality 92 ──────────────────────
      return Uint8List.fromList(img.encodeJpg(sharpened, quality: 92));
    } catch (_) {
      return null;
    }
  }
}
