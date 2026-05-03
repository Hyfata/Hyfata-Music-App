import 'dart:ui';
import 'package:flutter/material.dart';

/// A container with a frosted-glass blur effect.
/// Used consistently across the app instead of Liquid Glass.
class BlurContainer extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final double? height;
  final double? width;

  const BlurContainer({
    super.key,
    required this.child,
    this.blurSigma = 20,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark
            ? Colors.black.withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.65));
    final radius = borderRadius ?? BorderRadius.circular(16);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          height: height,
          width: width,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}
