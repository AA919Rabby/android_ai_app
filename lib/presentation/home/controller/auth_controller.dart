import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  AuthController({required this.authRepository});

  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(authRepository.authStateChanges);
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await authRepository.signInWithGoogle();
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}