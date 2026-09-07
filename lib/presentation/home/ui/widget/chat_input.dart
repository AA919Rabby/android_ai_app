import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';


class ChatInput extends GetView<HomeController> {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 10.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B3D),
        borderRadius: BorderRadius.circular(26.r),
        // Fades border color unless user clicks on it
        border: Border.all(
          color: controller.isInputFocused.value
              ? const Color(0xFF4285F4)
              : const Color(0xFF45475A).withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview
          if (controller.selectedImage.value != null)
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.h, left: 4.w),
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: FileImage(controller.selectedImage.value!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                    onPressed: controller.removeSelectedImage,
                  ),
                ),
              ],
            ),

          TextField(
            controller: controller.messageController,
            focusNode: controller.messageFocusNode,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            style: TextStyle(fontSize: 15.sp, fontFamily: 'Poppins', color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ask anything...',
              hintStyle: TextStyle(fontSize: 15.sp, color: Colors.white54, fontFamily: 'Poppins'),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            ),
          ),
          const Gap(8),
          Row(
            children: [
              _ActionButton(icon: Icons.add_photo_alternate_rounded, onTap: controller.attachFile),
              const Spacer(),
              _ActionButton(
                icon: controller.isListening.value ? Icons.mic : Icons.mic_none_rounded,
                color: controller.isListening.value ? Colors.redAccent : null,
                onTap: controller.startVoiceInput,
              ),
              const Gap(8),

              // Changes to a STOP button when AI is thinking
              if (controller.isAiThinking.value)
                _StopButton(onTap: controller.stopAiGeneration)
              else
                _SendButton(
                  enabled: controller.hasMessage.value || controller.selectedImage.value != null,
                  onTap: controller.sendMessage,
                ),
            ],
          ),
        ],
      ),
    ));
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: 38.r, height: 38.r,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF45475A))),
          child: Icon(icon, size: 21.r, color: color ?? Colors.white),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _SendButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 38.r, height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? const Color(0xFF4285F4) : const Color(0xFF45475A),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(22.r),
          child: Icon(Icons.arrow_upward_rounded, size: 21.r, color: enabled ? Colors.white : Colors.white54),
        ),
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 38.r, height: 38.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.redAccent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22.r),
          child: Icon(Icons.stop_rounded, size: 24.r, color: Colors.redAccent),
        ),
      ),
    );
  }
}