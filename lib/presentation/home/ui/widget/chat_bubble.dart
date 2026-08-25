import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/global/custom_text.dart';
import '../../data/model/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      // Right side for user, Left side for AI
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        padding: EdgeInsets.all(12.r),
        constraints: BoxConstraints(maxWidth: 280.w),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF4285F4) : const Color(0xFF2A2B3D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isUser ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight: message.isUser ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If the message contains an image, decode and show it
            if (message.base64Image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.memory(
                  base64Decode(message.base64Image!),
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(8),
            ],
            // Show the text prompt/response
            if (message.text.isNotEmpty)
              CustomText(
                text: message.text,
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
          ],
        ),
      ),
    );
  }
}