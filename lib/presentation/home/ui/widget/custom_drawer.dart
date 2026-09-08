import 'package:ai_chatapp/core/global/custom_dialog.dart';
import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class AnimatedDrawerBackground extends StatefulWidget {
  const AnimatedDrawerBackground({super.key});
  @override
  State<AnimatedDrawerBackground> createState() => _AnimatedDrawerBackgroundState();
}
class _AnimatedDrawerBackgroundState extends State<AnimatedDrawerBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat(reverse: true);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(const Color(0xFF1E1E2E), const Color(0xFF2A2B3D), _controller.value)!,
              Color.lerp(const Color(0xFF2A2B3D), const Color(0xFF161622), _controller.value)!,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends GetView<HomeController> {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          const AnimatedDrawerBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 38.r, height: 38.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
                            ),
                            child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21.r),
                          ),
                          const Gap(10),
                          CustomText(text: 'Gemini X', fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
                          Obx(() {
                            final authController = Get.find<AuthController>();
                            final user = authController.currentUser.value;
                            return user != null
                                ? CustomText(
                              text: user.email ?? 'Unknown User',
                              fontSize: 11.sp,
                              color: Colors.white54,
                            )
                                : const SizedBox.shrink();
                          }),
                        ],
                      ),
                      const Spacer(),
                      IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear, color: Colors.white))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: InkWell(
                    onTap: () {
                      controller.createNewChat();
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(color: const Color(0xFF4285F4), borderRadius: BorderRadius.circular(14.r)),
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded, color: Colors.white, size: 21.r),
                          const Gap(10),
                          CustomText(text: 'New chat', fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: 'Recent', fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white70),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Obx(() {
                    if (controller.recentSessions.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        child: CustomText(text: 'No recent chat', color: Colors.white54, fontSize: 14.sp),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: controller.recentSessions.length,
                      itemBuilder: (context, index) {
                        final session = controller.recentSessions[index];
                        return _DrawerChatItem(
                          title: session.title,
                          onTap: () {
                            controller.loadSession(session.id);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }),
                ),
                const Divider(height: 1, color: Color(0xFF45475A)),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      _DrawerItem(
                        icon: Icons.login_outlined,
                        title: 'Logout',
                        onTap: () => _handleLogout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    Navigator.of(context).pop(); // Close Drawer
    CustomDialog.show(
        imageWidget: Container(
          width: 80.r, height: 80.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF9B72CB)]),
          ),
          child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 21.r),
        ),
        context: context,
        title: "Logout",
        message: 'Do you want to Logout?',
        cancelText: 'No',
        confirmText: 'Yes',
        confirmColor: Colors.redAccent,
        onConfirm: () {
          // No need to manually pop the dialog here anymore, the CustomDialog does it!
          Get.find<AuthController>().signOut();
        }
    );
  }
}

class _DrawerChatItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerChatItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 19.r, color: Colors.white70),
            const Gap(10),
            Expanded(
              child: CustomText(text: title, fontSize: 14.sp, color: Colors.white, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: Colors.redAccent),
            const Gap(12),
            CustomText(text: title, fontSize: 14.sp, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}