import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'app_theme.dart';

/// 🎨 Glassmorphism Components สำหรับ Ultra-Luxury Loan App
/// ออกแบบตามหลักการ "Less is More" แต่แฝงด้วยความหรูหรา

/// 🌊 Glass Container พื้นฐาน
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Color? glassColor;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.glassColor,
    this.blur = 20.0,
    this.opacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        // 🌊 Glassmorphism Effect
        color: (glassColor ?? GlassColors.glassWhite).withOpacity(opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border ?? _defaultBorder(),
        boxShadow: boxShadow ?? PremiumShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );
  }

  Border _defaultBorder() {
    return Border.all(
      color: AppTheme.mediumBlue.withOpacity(0.3),
      width: 0.5,
    );
  }
}

/// 💎 Premium Glass Card สำหรับแสดงข้อมูลสำคัญ
class PremiumGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isInteractive;

  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, isInteractive ? -2.0 : 0.0)
          ..scale(isInteractive ? 1.02 : 1.0),
        child: GlassContainer(
          padding: padding ?? const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(24),
          blur: 25.0,
          opacity: 0.12,
          boxShadow: PremiumShadows.softShadow,
          child: child,
        ),
      ),
    );
  }
}

/// 🌟 Floating Glass Button สุดหรู
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;
  final double? width;
  final double? height;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      width: width,
      height: height ?? 56,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        borderRadius: BorderRadius.circular(16),
        blur: 5.0, // ลด blur ให้สีชัดเจน
        opacity: isPrimary ? 0.95 : 0.15, // เพิ่มความเข้นเกือบเต็มที่
        glassColor: isPrimary ? const Color(0xFF1565C0) : AppTheme.snowWhite, // Blue สวยงาม
        border: Border.all(
          color: isPrimary 
              ? const Color(0xFF0D47A1).withOpacity(0.8) // ขอบสีน้ำเงินเข้ม
              : AppTheme.mediumBlue.withOpacity(0.4),
          width: 2.0, // เพิ่มความหนาขอบให้ชัดเจน
        ),
        boxShadow: isPrimary ? PremiumShadows.buttonShadow : null, // เพิ่มเงาเฉพาะปุ่มหลัก
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5, // เพิ่มความหนา
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? AppTheme.snowWhite : AppTheme.deepNavy,
                  ),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 22, // เพิ่มขนาดไอคอน
                  color: isPrimary ? AppTheme.snowWhite : AppTheme.deepNavy,
                ),
                const SizedBox(width: 12),
              ],
              Flexible( // ใช้ Flexible แทน Row ป้องกันข้อความตก
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600, // ความหนา
                    color: isPrimary ? AppTheme.snowWhite : AppTheme.deepNavy,
                    fontFamily: 'Kanit', // เปลี่ยนเป็นฟอนต์ Kanit
                    height: 1.3, // เพิ่มระยะห่างบรรทัด
                  ),
                  overflow: TextOverflow.visible, // ให้แสดงข้อความครบ
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 🎯 Glass Input Field สำหรับกรอกข้อมูล
class GlassInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const GlassInputField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Container(
            width: double.infinity, // ให้เต็มความกว้าง
            padding: const EdgeInsets.symmetric(horizontal: 4), // เพิ่ม padding ข้างข้าง
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 15, // เพิ่มขนาดฟอนต์
                fontWeight: FontWeight.w500,
                color: AppTheme.deepNavy,
                fontFamily: 'Kanit', // ใช้ฟอนต์ Kanit รองรับไทยสมบูรณ์
                height: 1.4, // เพิ่มระยะห่างบรรทัด
              ),
              overflow: TextOverflow.visible, // ให้แสดงข้อความครบ
              maxLines: 2, // จำกัด 2 บรรทัด
            ),
          ),
          const SizedBox(height: 8), // เพิ่มระยะห่าง
        ],
        GlassContainer(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16), // เพิ่ม padding ด้านซ้าย
          borderRadius: BorderRadius.circular(12),
          blur: 10.0,
          opacity: 0.08,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.deepNavy,
              fontFamily: 'Kanit', // เปลี่ยนเป็นฟอนต์ Kanit
              height: 1.4, // เพิ่มระยะห่างบรรทัด
            ),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10), // เพิ่ม padding ด้านซ้าย
              hintStyle: const TextStyle(
                color: AppTheme.mediumGray,
                fontFamily: 'Kanit', // เปลี่ยนเป็นฟอนต์ Kanit
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 📊 Glass Status Card สำหรับแสดงสถานะ
class GlassStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color statusColor;
  final IconData? icon;

  const GlassStatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.statusColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.mediumGray,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: statusColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 Glass Navigation Bar สำหรับ Bottom Navigation
class GlassNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<GlassNavItem> items;

  const GlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      borderRadius: BorderRadius.circular(24),
      blur: 25.0,
      opacity: 0.9,
      boxShadow: PremiumShadows.softShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.sapphireBlue.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isSelected 
                        ? AppTheme.sapphireBlue 
                        : AppTheme.mediumGray,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected 
                          ? AppTheme.sapphireBlue 
                          : AppTheme.mediumGray,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final String label;

  const GlassNavItem({
    required this.icon,
    required this.label,
  });
}
