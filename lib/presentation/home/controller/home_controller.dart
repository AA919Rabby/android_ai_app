import 'dart:convert';
import 'dart:io';
import 'package:ai_chatapp/core/global/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/global/custom_text.dart';
import '../data/model/chat_model.dart';
import '../data/repositories/chat_repository.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final ChatRepository chatRepository;
  final AuthController authController;

  HomeController({required this.chatRepository, required this.authController});

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  GenerativeModel? _geminiModel;
  bool _cancelAiGeneration = false;

  // Plan Selection State
  RxString selectedPlan = 'General'.obs; // 'General' or 'Pro'
  RxBool isProPurchased = false.obs;
  RxBool isProcessingPayment = false.obs;

  // Model Selection Data
  final List<String> models = ['gemini-2.5-flash', 'gemini-2.5-pro'];
  RxString selectedModel = 'gemini-2.5-flash'.obs;

  // State
  RxBool hasMessage = false.obs;
  RxBool isAiThinking = false.obs;
  RxBool isListening = false.obs;
  RxBool isInputFocused = false.obs;

  RxString currentSessionId = ''.obs;
  RxList<ChatMessage> currentMessages = <ChatMessage>[].obs;
  RxList<AppChatSession> recentSessions = <AppChatSession>[].obs;

  Rx<File?> selectedImage = Rx<File?>(null);

  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initGemini();
    _initSpeech();

    ever(authController.currentUser, (user) {
      if (user != null) {
        _listenToRecentSessions(user.uid);
      } else {
        createNewChat();
        recentSessions.clear();
        isProPurchased.value = false;
        selectedPlan.value = 'General';
      }
    });

    messageController.addListener(() {
      hasMessage.value = messageController.text.trim().isNotEmpty;
    });

    messageFocusNode.addListener(() {
      isInputFocused.value = messageFocusNode.hasFocus;
    });
  }

  void onSelectPlan(String plan) {
    if (plan == 'General') {
      selectedPlan.value = 'General';
      selectedModel.value = 'gemini-1.5-flash';
      _initGemini();
    } else if (plan == 'Pro') {
      if (isProPurchased.value) {
        selectedPlan.value = 'Pro';
        selectedModel.value = 'gemini-1.5-pro';
        _initGemini();
      } else {
        _showProSubscriptionDialog();
      }
    }
  }

  void _showProSubscriptionDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF2A2B3D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C7BF5), Color(0xFF9475D8)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Upgrade to Pro',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: r'$10.00 / Month',
                          fontSize: 14.sp,
                          color: const Color(0xFF6C7BF5),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Gap(16),
              const Divider(color: Color(0xFF45475A)),
              const Gap(12),
              _buildFeatureItem(Icons.psychology_rounded, 'More powerful reasoning & logic'),
              _buildFeatureItem(Icons.token_rounded, 'Extended token context limit'),
              _buildFeatureItem(Icons.flash_on_rounded, 'Priority queue & ultra-fast speeds'),
              _buildFeatureItem(Icons.image_rounded, 'High resolution multi-modal support'),
              const Gap(20),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: isProcessingPayment.value ? null : buyProWithStripe,
                  child: isProcessingPayment.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CustomLoader(),
                  )
                      : CustomText(
                    text: r'Buy Now — $10 / monthly',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9475D8), size: 18.r),
          const Gap(10),
          Expanded(
            child: CustomText(text: title, fontSize: 13.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Future<void> buyProWithStripe() async {
    final stripeSecret = dotenv.env['STRIPE_SECRET_KEY'];
    if (stripeSecret == null || stripeSecret.isEmpty) {
      Get.snackbar(
        'Configuration Error',
        'Stripe secret key not found in .env',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isProcessingPayment.value = true;

      // 1. Create PaymentIntent on Stripe (10 USD = 1000 cents)
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecret',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': '1000',
          'currency': 'usd',
          'payment_method_types[]': 'card',
          'description': 'Gemini X Pro Subscription',
        },
      );

      final paymentIntentData = jsonDecode(response.body);
      if (paymentIntentData['client_secret'] == null) {
        throw Exception(paymentIntentData['error']?['message'] ?? 'Failed to init payment');
      }

      // 2. Initialize Stripe Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Gemini X',
          style: ThemeMode.dark,
        ),
      );

      // 3. Present Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Success handling
      isProPurchased.value = true;
      selectedPlan.value = 'Pro';
      selectedModel.value = 'gemini-1.5-pro';
      _initGemini();

      Get.back(); // close upgrade modal

      Get.snackbar(
        'Success',
        'Welcome to Pro! Plan unlocked.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } on StripeException catch (e) {
      if (e.error.code != FailureCode.Canceled) {
        Get.snackbar(
          'Payment Error',
          e.error.localizedMessage ?? 'Payment failed',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Payment Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void selectModel(String model) {
    selectedModel.value = model;
    _initGemini();
  }

  void _initGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      String aiModel = selectedPlan.value == 'Pro' ? 'gemini-1.5-pro' : 'gemini-1.5-flash';
      _geminiModel = GenerativeModel(model: aiModel, apiKey: apiKey);
    }
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize();
  }

  void createNewChat() {
    currentSessionId.value = '';
    currentMessages.clear();
    selectedImage.value = null;
    messageController.clear();
    isAiThinking.value = false;
  }

  void loadSession(String sessionId) {
    final user = authController.currentUser.value;
    if (user == null) return;

    currentSessionId.value = sessionId;
    selectedImage.value = null;

    chatRepository.getSessionMessages(user.uid, sessionId).listen((messages) {
      currentMessages.value = messages;
    });
  }

  void _listenToRecentSessions(String userId) {
    chatRepository.getRecentSessions(userId).listen((sessions) {
      recentSessions.value = sessions;
    });
  }

  Future<void> attachFile() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) selectedImage.value = File(image.path);
  }

  void removeSelectedImage() => selectedImage.value = null;

  Future<void> startVoiceInput() async {
    if (!_speechToText.isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        isListening.value = true;
        _speechToText.listen(onResult: (result) {
          messageController.text = result.recognizedWords;
        });
      }
    } else {
      isListening.value = false;
      _speechToText.stop();
    }
  }

  void stopAiGeneration() {
    _cancelAiGeneration = true;
    isAiThinking.value = false;
    currentMessages.add(ChatMessage(
      id: const Uuid().v4(),
      text: "Generation stopped by user.",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final imageFile = selectedImage.value;
    final user = authController.currentUser.value;

    if ((text.isEmpty && imageFile == null) || user == null) return;

    if (currentSessionId.value.isEmpty) {
      currentSessionId.value = const Uuid().v4();
      loadSession(currentSessionId.value);
    }

    messageController.clear();
    FocusScope.of(Get.context!).unfocus();
    isAiThinking.value = true;
    _cancelAiGeneration = false;

    String? base64String;
    List<Part> promptParts = [];

    if (text.isNotEmpty) promptParts.add(TextPart(text));

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      base64String = base64Encode(bytes);
      promptParts.add(DataPart('image/jpeg', bytes));
    }

    selectedImage.value = null;

    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      base64Image: base64String,
      timestamp: DateTime.now(),
    );
    currentMessages.add(userMsg);

    try {
      await chatRepository.saveMessage(user.uid, currentSessionId.value, userMsg, text.isNotEmpty ? text : 'Image Chat');

      if (_geminiModel == null) {
        throw Exception('MISSING_API_KEY');
      }

      final response = await _geminiModel!.generateContent([Content.multi(promptParts)]);

      if (_cancelAiGeneration) return;

      final aiText = response.text ?? 'I could not process that.';

      final aiMsg = ChatMessage(
        id: const Uuid().v4(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      await chatRepository.saveMessage(user.uid, currentSessionId.value, aiMsg, text.isNotEmpty ? text : 'Image Chat');
    } catch (e) {
      if (_cancelAiGeneration) return;

      String errorText = 'An error occurred. Please try again.';
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('429') || errorString.contains('quota') || errorString.contains('limit')) {
        errorText = "⚠️ You have reached your API limit/quota. Please try again later or upgrade your plan.";
      } else if (errorString.contains('missing_api_key')) {
        errorText = "⚠️ No API Key found. Please add your Gemini API key in the .env file.";
      }

      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        text: errorText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      currentMessages.add(errorMsg);
    } finally {
      isAiThinking.value = false;
    }
  }
}