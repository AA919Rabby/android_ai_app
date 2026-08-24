import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:ai_chatapp/core/global/custom_text.dart';
import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';

class ModelSelector extends GetView<HomeController> {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        24.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Choose model',
                fontSize: 19.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Gap(12),
            ...controller.models.map(
                  (model) => Obx(
                    () => _ModelItem(
                  model: model,
                  selected:
                  controller.selectedModel.value == model,
                  onTap: () {
                    controller.selectModel(model);
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelItem extends StatelessWidget {
  final String model;
  final bool selected;
  final VoidCallback onTap;

  const _ModelItem({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          margin: EdgeInsets.only(
            bottom: 8.h,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.blue.withValues(alpha: 0.08)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: selected
                  ? Colors.blue
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? Colors.blue
                      : Colors.grey.shade200,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 19.r,
                  color: selected
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
              const Gap(12),
              CustomText(
                text: model,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              const Spacer(),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 22.r,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}