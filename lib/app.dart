// import 'package:ai_chatapp/presentation/home/ui/screen/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:get/get.dart';
//
// import 'all_binding.dart';
// import 'all_route.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilPlusInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'AI ChatApp',
//           initialBinding: AllBinding(),
//           initialRoute: AllRoute.home,
//           getPages: AllRoute.routes,
//           theme: ThemeData(
//             useMaterial3: true,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.blue,
//             ),
//           ),
//           home: child,
//         );
//       },
//       child: HomeScreen(),
//     );
//   }
// }
//

/// this one i for the ai chatapp
///


import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';

import 'all_binding.dart';
import 'core/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
   //
          theme: ThemeData(
            useMaterial3: true,

            brightness: Brightness.dark,

            scaffoldBackgroundColor:
            AppColors.background,

            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              onSurface: AppColors.text,
              onPrimary: Colors.white,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.text,
              elevation: 0,
            ),

            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.surface,
            ),
          ),

          // Do NOT use darkTheme.
          // Do NOT use ThemeMode.system.

          initialBinding: AllBinding(),

          home: home,
        );
      },
    );
  }
}
