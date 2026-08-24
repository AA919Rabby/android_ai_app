import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late final TextEditingController messageController;
  late final FocusNode messageFocusNode;

  final RxBool isLoading = false.obs;
  final RxString selectedModel = 'Flash'.obs;

  final List<String> models = [
    'Flash',
    'Pro',
  ];

  @override
  void onInit() {
    super.onInit();

    messageController = TextEditingController();
    messageFocusNode = FocusNode();

    messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    update();
  }

  bool get hasMessage {
    return messageController.text.trim().isNotEmpty;
  }

  void selectModel(String model) {
    selectedModel.value = model;
  }

  void sendMessage() {
    final message = messageController.text.trim();

    if (message.isEmpty || isLoading.value) {
      return;
    }

    messageController.clear();
    messageFocusNode.unfocus();
  }

  void attachFile() {
    Get.snackbar(
      'Attachment',
      'Attachment selected',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void startVoiceInput() {
    Get.snackbar(
      'Voice',
      'Voice input selected',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    messageController.removeListener(_onTextChanged);
    messageController.dispose();
    messageFocusNode.dispose();
    super.onClose();
  }
}