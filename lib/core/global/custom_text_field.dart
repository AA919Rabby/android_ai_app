import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool filled;
  final String? errorText;
  final bool autocorrect;
  final bool enableSuggestions;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.fontSize,
    this.fontWeight,
    this.filled = true,
    this.errorText,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  Widget? _buildIcon(Object? icon) {
    if (icon == null) {
      return null;
    }

    if (icon is Widget) {
      return icon;
    }

    if (icon is String) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Center(
          child: Text(
            icon,
            style: TextStyle(
              fontSize: 16.sp,
              color: hintColor ?? Colors.grey,
            ),
          ),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: textColor ?? Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        filled: filled,
        fillColor: fillColor ?? Colors.grey.shade100,
        hintStyle: TextStyle(
          fontSize: fontSize ?? 16.sp,
          color: hintColor ?? Colors.grey,
        ),
        labelStyle: TextStyle(
          fontSize: fontSize ?? 16.sp,
          color: hintColor ?? Colors.grey,
        ),
        prefixIcon: _buildIcon(prefixIcon),
        suffixIcon: _buildIcon(suffixIcon),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15.h,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12.r,
          ),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12.r,
          ),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12.r,
          ),
          borderSide: BorderSide(
            color: focusedBorderColor ?? Colors.blue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12.r,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12.r,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}