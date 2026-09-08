import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomDialog extends StatelessWidget {
  final String? image;
  final Widget? imageWidget;
  final String? title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final Color? cancelColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? backgroundColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showConfirmButton;
  final bool showCancelButton;
  final bool barrierDismissible;
  final double? imageSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomDialog({
    super.key,
    this.image,
    this.imageWidget,
    this.title,
    this.message,
    this.content,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
    this.confirmColor = const Color(0xFF4285F4),
    this.cancelColor = Colors.white,
    this.titleColor = Colors.white,
    this.messageColor = Colors.white70,
    this.backgroundColor = const Color(0xFF2A2B3D),
    this.onConfirm,
    this.onCancel,
    this.showConfirmButton = true,
    this.showCancelButton = true,
    this.barrierDismissible = true,
    this.imageSize,
    this.borderRadius = 24,
    this.padding,
  });

  Widget _buildDefaultIcon() {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B30).withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.logout_rounded,
        color: const Color(0xFFFF3B30),
        size: 30.r,
      ),
    );
  }

  Widget? _buildImage() {
    if (imageWidget != null) {
      return imageWidget;
    }

    if (image != null && image!.isNotEmpty) {
      return Container(
        width: imageSize ?? 64.r,
        height: imageSize ?? 64.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          image!,
          fit: BoxFit.cover,
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 52.r,
        child: OutlinedButton(
          // FIX: Always close dialog first, then run action
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancel != null) onCancel!();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: cancelColor,
            backgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            side: BorderSide(
              color: const Color(0xFF45475A),
              width: 1.r,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            cancelText ?? 'No',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 52.r,
        child: ElevatedButton(
          // FIX: Always close dialog first, then run action
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            confirmText ?? 'Yes',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? topImage = _buildImage();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 24.h,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520.w,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              borderRadius ?? 24.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40.r,
                offset: Offset(0, 16.r),
              ),
            ],
          ),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 26.h,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (topImage != null) ...[
                  topImage,
                  const Gap(18),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: -0.5,
                      color: titleColor,
                    ),
                  ),
                  const Gap(10),
                ],
                if (message != null) ...[
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      letterSpacing: -0.1,
                      color: messageColor,
                    ),
                  ),
                  const Gap(24),
                ],
                if (content != null) ...[
                  content!,
                  const Gap(24),
                ],
                if (showConfirmButton || showCancelButton)
                  Row(
                    children: [
                      if (showCancelButton)
                        _buildCancelButton(context),
                      if (showCancelButton &&
                          showConfirmButton)
                        const Gap(10),
                      if (showConfirmButton)
                        _buildConfirmButton(context),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? image,
    Widget? imageWidget,
    String? title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    Color? cancelColor,
    Color? titleColor,
    Color? messageColor,
    Color? backgroundColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool? showConfirmButton,
    bool? showCancelButton,
    bool barrierDismissible = true,
    double? imageSize,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        return CustomDialog(
          image: image,
          imageWidget: imageWidget,
          title: title,
          message: message,
          content: content,
          confirmText: confirmText ?? 'Yes',
          cancelText: cancelText ?? 'No',
          confirmColor: confirmColor ?? const Color(0xFF4285F4),
          cancelColor: cancelColor ?? Colors.white,
          titleColor: titleColor ?? Colors.white,
          messageColor: messageColor ?? Colors.white70,
          backgroundColor: backgroundColor ?? const Color(0xFF2A2B3D),
          onConfirm: onConfirm,
          onCancel: onCancel,
          showConfirmButton: showConfirmButton ?? true,
          showCancelButton: showCancelButton ?? true,
          barrierDismissible: barrierDismissible,
          imageSize: imageSize,
          borderRadius: borderRadius ?? 24.r,
          padding: padding,
        );
      },
    );
  }
}