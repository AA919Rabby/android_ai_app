import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  final Duration? duration;
  final BoxShape? shape;

  const CustomLoader({
    super.key,
    this.color,
    this.size,
    this.duration,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      color: color ?? Colors.blue,
      size: size ?? 40.r,
      duration: duration ?? const Duration(milliseconds: 1500),
    //  shape: shape ?? BoxShape.circle,
    );
  }
}