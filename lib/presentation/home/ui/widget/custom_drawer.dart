import 'package:ai_chatapp/core/global/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';
import 'package:get/get.dart';

// Live animated background widget for the drawer
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
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
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
      builder: (context, child) {
        return Container(
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
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      backgroundColor: Colors.transparent, // Transparent so the animation shows through
      child: Stack(
        children: [
          const AnimatedDrawerBackground(), // The live animation layer
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Row(
                    children: [
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF4285F4),
                              Color(0xFF9B72CB),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 21.r,
                        ),
                      ),
                      const Gap(10),
                      CustomText(
                        text: 'Gemini X',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4285F4), // Popping blue color
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 21.r,
                            ),
                            const Gap(10),
                            CustomText(
                              text: 'New chat',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Recent',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    children: const [
                      _DrawerChatItem(
                        title: 'Welcome to Gemini X',
                      ),
                      _DrawerChatItem(
                        title: 'Flutter development',
                      ),
                      _DrawerChatItem(
                        title: 'AI project ideas',
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: const Color(0xFF45475A), // Dark divider
                ),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: const Column(
                    children: [
                      _DrawerItem(
                        icon: Icons.login_outlined,
                        title: 'Logout',
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
}

class _DrawerChatItem extends StatelessWidget {
  final String title;

  const _DrawerChatItem({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pop();

          await Future.delayed(
            const Duration(milliseconds: 200),
          );

          if (!context.mounted) {
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return const CustomDialog();
            },
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 20.r,
                color: Colors.white70,
              ),
              const Gap(10),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 14.sp,
                  color: Colors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DrawerItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          Navigator.of(context).pop();

          await Future.delayed(
            const Duration(milliseconds: 200),
          );

          if (!context.mounted) {
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return CustomDialog(
                imageWidget: Icon(Icons.login_outlined, color: Colors.redAccent, size: 70.r,),
                message: 'Do you want to Logout?',
                cancelText: 'No',
                confirmText: 'Yes',
                showCancelButton: true,
                showConfirmButton: true,
                cancelColor: Colors.white,
                confirmColor: Colors.redAccent,
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 25.r,
                color: Colors.redAccent,
              ),
              const Gap(12),
              CustomText(
                text: title,
                fontSize: 14.sp,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}