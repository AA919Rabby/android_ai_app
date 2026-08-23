import 'package:ai_chatapp/presentation/home/controller/home_controller.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(),
    );
  }
}