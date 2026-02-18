import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 📱 Tablet Configuration สำหรับ Samsung SM-P615
class TabletConfig {
  static const double tabletWidth = 1600.0;  // SM-P615 width
  static const double tabletHeight = 2560.0; // SM-P615 height
  
  static BuildContext? _context;
  
  /// 🎯 Initialize ScreenUtil สำหรับ Tablet
  static void initTablet(BuildContext context) {
    _context = context;
    ScreenUtil.init(
      context,
      // ใช้ design size จากต้นฉบับ (1000px width)
      designSize: const Size(1000, 1200),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
  
  /// 📐 Get Responsive Value สำหรับ Tablet
  static double responsive({
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    final screenWidth = ScreenUtil().screenWidth;
    if (screenWidth >= 1200) {
      return desktop ?? tablet;
    } else if (screenWidth >= 768) {
      return tablet;
    } else {
      return mobile;
    }
  }
  
  /// 🎨 Get Responsive Font Size
  static double responsiveFont({
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    return responsive(mobile: mobile, tablet: tablet, desktop: desktop).sp;
  }
  
  /// 📱 Check if Tablet
  static bool get isTablet => ScreenUtil().screenWidth >= 768;
  
  /// 🖥️ Check if Desktop
  static bool get isDesktop => ScreenUtil().screenWidth >= 1200;
  
  /// 📱 Check if Mobile
  static bool get isMobile => ScreenUtil().screenWidth < 768;
  
  /// 🎯 Get Container Width ตามขนาดหน้าจอ
  static double get containerWidth {
    final screenWidth = ScreenUtil().screenWidth;
    if (isDesktop) {
      return 1000.w; // Desktop: 1000px max
    } else if (isTablet) {
      return 900.w;  // Tablet: 900px max
    } else {
      return screenWidth - 32.w; // Mobile: full width - padding
    }
  }
  
  /// 📋 Get Card Layout จำนวนต่อแถว
  static int get cardsPerRow {
    if (isDesktop) {
      return 3; // Desktop: 3 cards per row
    } else if (isTablet) {
      return 2; // Tablet: 2 cards per row
    } else {
      return 1; // Mobile: 1 card per row
    }
  }
  
  /// 🎨 Get Padding ตามขนาดหน้าจอ
  static EdgeInsets get screenPadding {
    if (isDesktop) {
      return EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h);
    } else if (isTablet) {
      return EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h);
    } else {
      return EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    }
  }
  
  /// 📱 Get Button Height ตามขนาดหน้าจอ
  static double get buttonHeight {
    if (isTablet) {
      return 56.h; // Tablet: 56px
    } else {
      return 48.h; // Mobile: 48px
    }
  }
  
  /// 🎯 Get Icon Size ตามขนาดหน้าจอ
  static double get iconSize {
    if (isTablet) {
      return 24.r; // Tablet: 24px
    } else {
      return 20.r; // Mobile: 20px
    }
  }
  
  /// 📐 Get Card Border Radius ตามขนาดหน้าจอ
  static double get cardBorderRadius {
    if (isTablet) {
      return 20.r; // Tablet: 20px
    } else {
      return 16.r; // Mobile: 16px
    }
  }
  
  /// 🎨 Get Glass Blur Amount
  static double get glassBlur {
    if (isTablet) {
      return 25.0; // Tablet: More blur for premium look
    } else {
      return 20.0; // Mobile: Standard blur
    }
  }
  
  /// 🌊 Get Shadow Intensity
  static List<BoxShadow> get premiumShadows {
    if (isTablet) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20.r,
          offset: Offset(0, 8.r),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10.r,
          offset: Offset(0, 4.r),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16.r,
          offset: Offset(0, 6.r),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8.r,
          offset: Offset(0, 3.r),
        ),
      ];
    }
  }
}

/// 🎨 Responsive Widget Helper
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    if (TabletConfig.isDesktop && desktop != null) {
      return desktop!;
    } else if (TabletConfig.isTablet && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
