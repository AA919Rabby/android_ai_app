import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';
import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';

import 'model_selector.dart';

class ChatInput extends GetView<HomeController> {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            14.w,
            12.h,
            10.w,
            10.h,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: controller.messageController,
                focusNode: controller.messageFocusNode,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask anything',
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 6.h,
                  ),
                ),
              ),
              Gap(8),
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.add_rounded,
                    onTap: controller.attachFile,
                  ),
                  Gap(6),

                  const Spacer(),
                  _ActionButton(
                    icon: Icons.mic_none_rounded,
                    onTap: controller.startVoiceInput,
                  ),
                  Gap(4),
                  _SendButton(
                    enabled: controller.hasMessage,
                    onTap: controller.sendMessage,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Icon(
            icon,
            size: 21.r,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ModelButton extends StatelessWidget {
  final String model;
  final VoidCallback onTap;

  const _ModelButton({
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: model,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              Gap(2),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _SendButton({
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? Colors.black87 : Colors.grey.shade300,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(22.r),
          child: Icon(
            Icons.arrow_upward_rounded,
            size: 21.r,
            color: enabled ? Colors.white : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}