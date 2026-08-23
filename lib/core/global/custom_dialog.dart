import 'package:flutter/material.dart';
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
    this.confirmText,
    this.cancelText,
    this.confirmColor,
    this.cancelColor,
    this.titleColor,
    this.messageColor,
    this.backgroundColor,
    this.onConfirm,
    this.onCancel,
    this.showConfirmButton = true,
    this.showCancelButton = false,
    this.barrierDismissible = true,
    this.imageSize,
    this.borderRadius,
    this.padding,
  });

  Widget? _buildImage() {
    if (imageWidget != null) {
      return imageWidget;
    }

    if (image != null && image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          image!,
          width: imageSize ?? 80.r,
          height: imageSize ?? 80.r,
          fit: BoxFit.cover,
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? topImage = _buildImage();

    return Dialog(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? 20.r,
        ),
      ),
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 24.h,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topImage != null) ...[
              topImage,
              SizedBox(height: 16.h),
            ],
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
            ],
            if (message != null) ...[
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: messageColor ?? Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 20.h),
            ],
            if (content != null) ...[
              content!,
              SizedBox(height: 20.h),
            ],
            if (showConfirmButton || showCancelButton)
              Row(
                children: [
                  if (showCancelButton)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel ?? () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                          cancelColor ?? Colors.grey.shade700,
                          minimumSize: Size(
                            double.infinity,
                            48.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          cancelText ?? 'Cancel',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (showCancelButton && showConfirmButton)
                    SizedBox(width: 12.w),
                  if (showConfirmButton)
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                        onConfirm ?? () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          confirmColor ?? Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                            double.infinity,
                            48.h,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          confirmText ?? 'OK',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
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
    bool showConfirmButton = true,
    bool showCancelButton = false,
    bool barrierDismissible = true,
    double? imageSize,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return CustomDialog(
          image: image,
          imageWidget: imageWidget,
          title: title,
          message: message,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          confirmColor: confirmColor,
          cancelColor: cancelColor,
          titleColor: titleColor,
          messageColor: messageColor,
          backgroundColor: backgroundColor,
          onConfirm: onConfirm,
          onCancel: onCancel,
          showConfirmButton: showConfirmButton,
          showCancelButton: showCancelButton,
          barrierDismissible: barrierDismissible,
          imageSize: imageSize,
          borderRadius: borderRadius,
          padding: padding,
        );
      },
    );
  }
}