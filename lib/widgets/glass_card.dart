import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

/// 🎨 Glass Card Component สำหรับ Ultra-Luxury UI
/// ใช้สร้างเอฟเฟกต์กระจกแบบ Glassmorphism
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isDark;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        // 🌊 Glassmorphism Effect
        color: isDark ? GlassColors.glassDark : GlassColors.glassWhite,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        
        // ✨ Border Gradient
        border: Border.all(
          color: isDark 
            ? AppTheme.sapphireBlue.withOpacity(0.2)
            : AppTheme.sapphireBlue.withOpacity(0.1),
          width: 0.5,
        ),
        
        // 🌊 Premium Shadow
        boxShadow: PremiumShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: card,
      );
    }

    return card;
  }
}

/// 🎨 Glass Button Component
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;
  final BorderSide? side;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    this.isLoading = false,
    this.side,
  });

  bool get isOutlined => side != null;
  Color get foregroundColor => textColor ?? AppTheme.deepNavy;

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: foregroundColor ?? 
                   (isOutlined ? AppTheme.deepNavy : AppTheme.pureWhite),
          ),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? 
                (isOutlined ? AppTheme.deepNavy : AppTheme.pureWhite),
              ),
            ),
          )
        else
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: foregroundColor ?? 
                     (isOutlined ? AppTheme.deepNavy : AppTheme.pureWhite),
              fontFamily: 'Inter',
            ),
          ),
      ],
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: side ?? const BorderSide(color: AppTheme.deepNavy, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: buttonContent,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.deepNavy,
        foregroundColor: textColor ?? AppTheme.pureWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: buttonContent,
    );
  }
}

/// 🎨 Glass Input Field Component
class GlassInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool readOnly;

  const GlassInputField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.deepNavy,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          onTap: onTap,
          maxLength: maxLength,
          readOnly: readOnly,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.deepNavy,
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppTheme.mediumGray,
                    size: 20,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixIconTap,
                    icon: Icon(
                      suffixIcon,
                      color: AppTheme.mediumGray,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// 🎨 Floating Glass Card (สำหรับ Animation)
class FloatingGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isDark;
  final Duration animationDuration;
  final double floatingHeight;

  const FloatingGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.isDark = false,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.floatingHeight = 8.0,
  });

  @override
  State<FloatingGlassCard> createState() => _FloatingGlassCardState();
}

class _FloatingGlassCardState extends State<FloatingGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: 0,
      end: widget.floatingHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_floatAnimation.value),
          child: GlassCard(
            padding: widget.padding,
            margin: widget.margin,
            width: widget.width,
            height: widget.height,
            borderRadius: widget.borderRadius,
            onTap: widget.onTap,
            isDark: widget.isDark,
            child: widget.child,
          ),
        );
      },
    );
  }
}
