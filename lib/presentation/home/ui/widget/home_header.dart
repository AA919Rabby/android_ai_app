import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const HomeHeader({
    super.key,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onMenuTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.menu_rounded,
                size: 25.r,
                color: Colors.white, // White icon
              ),
            ),
          ),
        ),
        const Gap(10),
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4285F4),
                Color(0xFF9B72CB),
              ],
            ),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            size: 18.r,
            color: Colors.white,
          ),
        ),
        const Gap(8),
        CustomText(
          text: 'Gemini X',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white, // White text
        ),
        const Spacer(),
      ],
    );
  }
}