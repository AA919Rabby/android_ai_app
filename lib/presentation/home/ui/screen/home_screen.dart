import 'package:ai_chatapp/core/global/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../controller/home_controller.dart';
import '../widget/chat_bubble.dart';
import '../widget/chat_input.dart';
import '../widget/custom_drawer.dart';
import '../widget/home_header.dart';
import '../widget/welcome_content.dart';
import '../../../../core/global/custom_text.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFF1E1E2E),
      body: Stack(
        children: [
          // MAIN CHAT INTERFACE
          SafeArea(
            child: Builder(
              builder: (scaffoldContext) {
                return Column(
                  children: [
                    const Gap(8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: HomeHeader(
                        onMenuTap: () => Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        if (controller.currentMessages.isEmpty && !controller.isAiThinking.value) {
                          return const Center(child: WelcomeContent());
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                          itemCount: controller.currentMessages.length + (controller.isAiThinking.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.currentMessages.length) {
                              return _buildThinkingIndicator();
                            }
                            return ChatBubble(message: controller.currentMessages[index]);
                          },
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: const ChatInput(),
                    ),
                    const Gap(12),
                  ],
                );
              },
            ),
          ),

          // MANDATORY GOOGLE SIGN-IN OVERLAY
          Obx(() {
            if (authController.currentUser.value == null) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.85), // Dark overlay locking the screen
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2B3D),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFF45475A)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 50.r, color: const Color(0xFF4285F4)),
                        const Gap(16),
                        CustomText(
                          text: 'Welcome to Gemini X',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        const Gap(8),
                        CustomText(
                          text: 'Please sign in to continue your AI journey.',
                          fontSize: 14.sp,
                          color: Colors.white70,
                          textAlign: TextAlign.center,
                        ),
                        const Gap(24),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            icon: authController.isLoading.value
                                ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                : Icon(Icons.g_mobiledata_rounded, size: 30.r, color: Colors.blue),
                            label: CustomText(text: 'Sign in with Google', fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
                            onPressed: authController.isLoading.value ? null : () => authController.signInWithGoogle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink(); // Hide overlay if logged in
          }),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2B3D),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14.r,
              width: 14.r,
              child: CustomLoader(),
            ),
            const Gap(10),
            CustomText(text: 'AI is thinking...', color: Colors.white70, fontSize: 14.sp),
          ],
        ),
      ),
    );
  }
}