import 'package:ai_chatapp/presentation/home/controller/auth_controller.dart';
import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';
import 'package:ai_chatapp/presentation/home/data/repositories/auth_repository.dart';
import 'package:ai_chatapp/presentation/home/data/repositories/chat_repository.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<HomeController>(() => HomeController(),
    // 1. Repositories (Data Layer)
    Get.lazyPut(() => AuthRepository(), fenix: true);
    Get.lazyPut(() => ChatRepository(), fenix: true);

    // 2. Controllers (Logic Layer)
    Get.lazyPut(() => AuthController(authRepository: Get.find()), fenix: true);
    Get.lazyPut(() => HomeController(chatRepository: Get.find(), authController: Get.find()), fenix: true);
  }
}