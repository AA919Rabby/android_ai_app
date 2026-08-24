// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   final Color backgroundColor;
//   final Color textColor;
//   final VoidCallback onPressed;
//   final double? width;
//   final double? height;
//   final double? borderRadius;
//
//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.backgroundColor,
//     required this.textColor,
//     required this.onPressed,
//     this.width,
//     this.height,
//     this.borderRadius,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       height: height ?? 50.h,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: textColor,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(
//               borderRadius ?? 12.r,
//             ),
//           ),
//           overlayColor: textColor.withValues(alpha: 0.15),
//         ),
//         child: AnimatedDefaultTextStyle(
//           duration: const Duration(milliseconds: 150),
//           style: TextStyle(
//             color: textColor,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//           child: Text(text),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class CustomButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double effectiveRadius = widget.borderRadius ?? 12.r;
    final double effectiveHeight = widget.height ?? 50.h;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width ?? double.infinity,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(effectiveRadius),
          boxShadow: [
            BoxShadow(
              color: widget.backgroundColor.withValues(
                alpha: _isPressed ? 0.2 : 0.4,
              ),
              blurRadius: _isPressed ? 6 : 16,
              offset: Offset(0, _isPressed ? 2 : 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (isHighlighted) {
              setState(() => _isPressed = isHighlighted);
            },
            borderRadius: BorderRadius.circular(effectiveRadius),
            splashColor: widget.textColor.withValues(alpha: 0.15),
            highlightColor: widget.textColor.withValues(alpha: 0.08),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                child: Text(widget.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}