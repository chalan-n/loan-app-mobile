import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// 📷 IDCardCameraScreen — หน้าจอกล้องพร้อมกรอบบัตรประชาชน
/// อัตราส่วนบัตร ISO/IEC 7810 ID-1: 85.60 × 53.98 mm ≈ 1.586:1
class IDCardCameraScreen extends StatefulWidget {
  const IDCardCameraScreen({super.key});

  /// เปิดหน้าจอกล้องและคืน File ที่ถ่ายได้ หรือ null ถ้ายกเลิก
  static Future<File?> open(BuildContext context) {
    return Navigator.of(context).push<File?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const IDCardCameraScreen(),
      ),
    );
  }

  @override
  State<IDCardCameraScreen> createState() => _IDCardCameraScreenState();
}

class _IDCardCameraScreenState extends State<IDCardCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isReady = false;
  bool _isTakingPicture = false;
  String? _error;

  // ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ล็อค orientation เป็น portrait เพื่อถ่ายบัตร
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    // คืน orientation
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = 'ไม่พบกล้องในอุปกรณ์');
        return;
      }
      // ใช้กล้องหลัง (index 0) เป็นค่าเริ่มต้น
      final back = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
      final ctrl = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await ctrl.initialize();
      if (!mounted) return;
      setState(() {
        _controller = ctrl;
        _isReady = true;
      });
    } catch (e) {
      setState(() => _error = 'ไม่สามารถเปิดกล้องได้: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isTakingPicture) return;

    setState(() => _isTakingPicture = true);
    try {
      final xFile = await _controller!.takePicture();
      if (mounted) {
        Navigator.of(context).pop(File(xFile.path));
      }
    } catch (e) {
      setState(() => _isTakingPicture = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('ถ่ายภาพไม่สำเร็จ: $e',
              style: GoogleFonts.kanit(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return _buildErrorView(_error!);
    }
    if (!_isReady || _controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Camera Preview ──────────────────────────────────────
        _buildCameraPreview(),

        // ── Dark overlay (ส่วนนอกกรอบ) ─────────────────────────
        _IDCardOverlayPainter(),

        // ── Corner brackets + label ─────────────────────────────
        _buildFrameContent(),

        // ── Top bar (ปุ่มปิด + flash) ───────────────────────────
        _buildTopBar(),

        // ── Bottom bar (ปุ่มถ่าย) ───────────────────────────────
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize!.height,
            height: _controller!.value.previewSize!.width,
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }

  Widget _buildFrameContent() {
    return LayoutBuilder(builder: (context, constraints) {
      final frameRect = _calcFrameRect(constraints.biggest);
      return Stack(
        children: [
          // ── Corner brackets ────────────────────────────────────
          _CornerBrackets(rect: frameRect),

          // ── Label บน ──────────────────────────────────────────
          Positioned(
            left: frameRect.left,
            top: frameRect.top - 36.h,
            width: frameRect.width,
            child: Center(
              child: Text(
                'วางบัตรประชาชนให้อยู่ในกรอบ',
                style: GoogleFonts.kanit(
                  fontSize: 13.sp,
                  color: Colors.white,
                  shadows: [
                    const Shadow(color: Colors.black54, blurRadius: 4)
                  ],
                ),
              ),
            ),
          ),

          // ── Scanning line animation ────────────────────────────
          _ScanLine(rect: frameRect),
        ],
      );
    });
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ปุ่มปิด
              _circleButton(
                icon: Icons.close,
                onTap: () => Navigator.of(context).pop(null),
              ),
              // ปุ่ม Flash toggle
              _FlashButton(controller: _controller!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: GestureDetector(
            onTap: _isTakingPicture ? null : _takePicture,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isTakingPicture
                    ? Colors.white54
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _isTakingPicture
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 54.w,
                        height: 54.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12, width: 2),
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildErrorView(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48.sp),
          SizedBox(height: 16.h),
          Text(msg,
              style: GoogleFonts.kanit(color: Colors.white70, fontSize: 15.sp),
              textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('ปิด',
                style: GoogleFonts.kanit(color: Colors.white, fontSize: 15.sp)),
          ),
        ],
      ),
    );
  }

  /// คำนวณ Rect ของกรอบบัตร (aspect ratio 1.586) ที่กึ่งกลางหน้าจอ
  /// หน้าจอแนวตั้ง — กรอบวางในแนวนอน (บัตรหมุน 90°) ให้เต็มความกว้าง
  static Rect _calcFrameRect(Size screen) {
    const cardRatio = 1.586; // 85.6mm / 53.98mm
    const horizontalPad = 0.06; // 6% จากขอบซ้าย-ขวา

    final frameW = screen.width * (1 - horizontalPad * 2);
    final frameH = frameW / cardRatio;
    final left = screen.width * horizontalPad;
    // วางกรอบที่ 35% จากบน (เหนือกึ่งกลางเล็กน้อย เพื่อเว้นที่ปุ่มถ่าย)
    final top = screen.height * 0.35 - frameH / 2;

    return Rect.fromLTWH(left, top, frameW, frameH);
  }
}

// ══════════════════════════════════════════════════════════════════
// Dark Overlay (ส่วนนอกกรอบบัตร)
// ══════════════════════════════════════════════════════════════════
class _IDCardOverlayPainter extends StatelessWidget {
  const _IDCardOverlayPainter();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final frameRect =
          _IDCardCameraScreenState._calcFrameRect(constraints.biggest);
      return CustomPaint(
        size: constraints.biggest,
        painter: _OverlayPaint(frameRect),
      );
    });
  }
}

class _OverlayPaint extends CustomPainter {
  final Rect frameRect;
  const _OverlayPaint(this.frameRect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final outer = Rect.fromLTWH(0, 0, size.width, size.height);
    final inner = RRect.fromRectAndRadius(frameRect, const Radius.circular(12));

    // วาด overlay รอบกรอบ (hole punch)
    final path = Path()
      ..addRect(outer)
      ..addRRect(inner)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // เส้นขอบกรอบหลัก (บางๆ ขาว)
    canvas.drawRRect(
      inner,
      Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _OverlayPaint old) => old.frameRect != frameRect;
}

// ══════════════════════════════════════════════════════════════════
// Corner Brackets — มุมทั้ง 4 ของกรอบบัตร
// ══════════════════════════════════════════════════════════════════
class _CornerBrackets extends StatelessWidget {
  final Rect rect;
  const _CornerBrackets({required this.rect});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF38BDF8); // Sky blue สว่าง
    const lineLen = 24.0;
    const strokeW = 3.0;
    const r = 10.0; // corner radius

    return CustomPaint(
      size: Size.infinite,
      painter: _BracketPainter(
        rect: rect,
        color: color,
        lineLength: lineLen,
        strokeWidth: strokeW,
        radius: r,
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final double lineLength;
  final double strokeWidth;
  final double radius;

  const _BracketPainter({
    required this.rect,
    required this.color,
    required this.lineLength,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final l = rect.left;
    final t = rect.top;
    final r = rect.right;
    final b = rect.bottom;
    final ll = lineLength;
    final rd = radius;

    // ── Top-Left ──────────────────────────────
    final tlPath = Path()
      ..moveTo(l, t + ll)
      ..lineTo(l, t + rd)
      ..arcToPoint(Offset(l + rd, t), radius: Radius.circular(rd))
      ..lineTo(l + ll, t);
    canvas.drawPath(tlPath, paint);

    // ── Top-Right ─────────────────────────────
    final trPath = Path()
      ..moveTo(r - ll, t)
      ..lineTo(r - rd, t)
      ..arcToPoint(Offset(r, t + rd), radius: Radius.circular(rd))
      ..lineTo(r, t + ll);
    canvas.drawPath(trPath, paint);

    // ── Bottom-Left ───────────────────────────
    final blPath = Path()
      ..moveTo(l, b - ll)
      ..lineTo(l, b - rd)
      ..arcToPoint(Offset(l + rd, b), radius: Radius.circular(rd))
      ..lineTo(l + ll, b);
    canvas.drawPath(blPath, paint);

    // ── Bottom-Right ──────────────────────────
    final brPath = Path()
      ..moveTo(r - ll, b)
      ..lineTo(r - rd, b)
      ..arcToPoint(Offset(r, b - rd), radius: Radius.circular(rd))
      ..lineTo(r, b - ll);
    canvas.drawPath(brPath, paint);
  }

  @override
  bool shouldRepaint(covariant _BracketPainter old) =>
      old.rect != rect || old.color != color;
}

// ══════════════════════════════════════════════════════════════════
// Scanning Line Animation
// ══════════════════════════════════════════════════════════════════
class _ScanLine extends StatefulWidget {
  final Rect rect;
  const _ScanLine({required this.rect});

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _pos;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pos = CurvedAnimation(parent: _anim, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pos,
      builder: (_, __) {
        final y = widget.rect.top + widget.rect.height * _pos.value;
        return Positioned(
          left: widget.rect.left + 8,
          top: y,
          width: widget.rect.width - 16,
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF38BDF8).withOpacity(0.9),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// Flash Toggle Button
// ══════════════════════════════════════════════════════════════════
class _FlashButton extends StatefulWidget {
  final CameraController controller;
  const _FlashButton({required this.controller});

  @override
  State<_FlashButton> createState() => _FlashButtonState();
}

class _FlashButtonState extends State<_FlashButton> {
  FlashMode _mode = FlashMode.off;

  Future<void> _toggle() async {
    final next = _mode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await widget.controller.setFlashMode(next);
    setState(() => _mode = next);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: _mode == FlashMode.torch
              ? Colors.amber.withOpacity(0.85)
              : Colors.black45,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _mode == FlashMode.torch ? Icons.flash_on : Icons.flash_off,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}
