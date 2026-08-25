import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';
import '../widget/chat_input.dart';
import '../widget/custom_drawer.dart';
import '../widget/home_header.dart';
import '../widget/welcome_content.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFF1E1E2E), // Base Dark background
      body: SafeArea(
        child: Builder(
          builder: (scaffoldContext) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final double horizontalPadding =
                constraints.maxWidth >= 600 ? 32.w : 18.w;

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      const Gap(8),
                      HomeHeader(
                        onMenuTap: () {
                          Scaffold.of(scaffoldContext).openDrawer();
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 650.w,
                            ),
                            child: const WelcomeContent(),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 700.w,
                        ),
                        child: const ChatInput(),
                      ),
                      const Gap(12),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}