import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
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
              size: 32.r,
              color: Colors.white,
            ),
          ),
          const Gap(20),
          CustomText(
            text: 'Hello, there',
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white, // White text
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          CustomText(
            text: 'How can I help you today?',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white70, // Slightly dim text
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}