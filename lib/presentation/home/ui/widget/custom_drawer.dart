import 'package:ai_chatapp/core/global/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      backgroundColor: Colors.white,
      child: SafeArea(
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
                    color: Colors.black87,
                  ),
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
                      color: Colors.black87,
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
                  color: Colors.grey,
                ),
              ),
            ),
            const Gap(8),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
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
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
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
                size: 19.r,
                color: Colors.black54,
              ),
              const Gap(10),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 14.sp,
                  color: Colors.black87,
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
                icon,
                size: 20.r,
                color: Colors.red,
              ),
              const Gap(12),
              CustomText(
                text: title,
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}