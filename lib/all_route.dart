import 'package:ai_chatapp/all_binding.dart';
import 'package:get/get.dart';
import 'package:ai_chatapp/presentation/home/ui/screen/home_screen.dart';

class AllRoute {
  static const String home = '/home';

  static final List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: AllBinding(),
    ),
  ];
}