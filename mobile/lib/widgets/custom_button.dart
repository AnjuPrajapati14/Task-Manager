import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/constants.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final Widget? icon;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 48,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = isEnabled 
            ? const Color(AppColors.primary) 
            : const Color(AppColors.gray300);
        foregroundColor = Colors.white;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.secondary:
        backgroundColor = isEnabled 
            ? const Color(AppColors.gray100) 
            : const Color(AppColors.gray50);
        foregroundColor = isEnabled 
            ? const Color(AppColors.gray900) 
            : const Color(AppColors.gray400);
        borderSide = BorderSide(
          color: isEnabled 
              ? const Color(AppColors.gray300) 
              : const Color(AppColors.gray200),
        );
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isEnabled 
            ? const Color(AppColors.primary) 
            : const Color(AppColors.gray400);
        borderSide = BorderSide(
          color: isEnabled 
              ? const Color(AppColors.primary) 
              : const Color(AppColors.gray300),
        );
        break;
      case ButtonVariant.text:
        backgroundColor = Colors.transparent;
        foregroundColor = isEnabled 
            ? const Color(AppColors.primary) 
            : const Color(AppColors.gray400);
        borderSide = BorderSide.none;
        break;
    }

    Widget child;
    if (isLoading) {
      child = SpinKitThreeBounce(
        color: foregroundColor,
        size: 20,
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ],
      );
    } else {
      child = Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          elevation: variant == ButtonVariant.primary ? 2 : 0,
          shadowColor: variant == ButtonVariant.primary 
              ? const Color(AppColors.primary).withOpacity(0.3) 
              : Colors.transparent,
        ),
        child: child,
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: size,
        color: color ?? const Color(AppColors.gray600),
      ),
      tooltip: tooltip,
      splashRadius: 20,
    );
  }
}