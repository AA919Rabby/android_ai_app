import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../data/model/chat_model.dart';
import '../data/repositories/chat_repository.dart';
import 'auth_controller.dart';


class HomeController extends GetxController {
  final ChatRepository chatRepository;
  final AuthController authController;

  HomeController({required this.chatRepository, required this.authController});

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  late GenerativeModel _geminiModel;

  // Model Selection Data
  final List<String> models = ['Gemini 1.5 Flash', 'Gemini 1.5 Pro'];
  RxString selectedModel = 'Gemini 1.5 Flash'.obs;

  // State
  RxBool hasMessage = false.obs;
  RxBool isAiThinking = false.obs;
  RxBool isListening = false.obs;

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

    // React to Auth Changes
    ever(authController.currentUser, (user) {
      if (user != null) {
        _listenToRecentSessions(user.uid);
      } else {
        createNewChat();
        recentSessions.clear();
      }
    });

    messageController.addListener(() {
      hasMessage.value = messageController.text.trim().isNotEmpty;
    });
  }

  void selectModel(String model) {
    selectedModel.value = model;
    _initGemini(); // Re-initialize with new selected model
  }

  void _initGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      String aiModel = selectedModel.value == 'Gemini 1.5 Pro' ? 'gemini-1.5-pro' : 'gemini-2.5-flash';
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

  // Interactions
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

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final imageFile = selectedImage.value;
    final user = authController.currentUser.value;

    if ((text.isEmpty && imageFile == null) || user == null) return;

    messageController.clear();
    selectedImage.value = null;
    FocusScope.of(Get.context!).unfocus();
    isAiThinking.value = true;

    if (currentSessionId.value.isEmpty) {
      currentSessionId.value = const Uuid().v4();
      loadSession(currentSessionId.value);
    }

    String? base64String;
    List<Part> promptParts = [];

    if (text.isNotEmpty) promptParts.add(TextPart(text));

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      base64String = base64Encode(bytes);
      promptParts.add(DataPart('image/jpeg', bytes));
    }

    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      base64Image: base64String,
      timestamp: DateTime.now(),
    );
    await chatRepository.saveMessage(user.uid, currentSessionId.value, userMsg, text.isNotEmpty ? text : 'Image Chat');

    try {
      final response = await _geminiModel.generateContent([Content.multi(promptParts)]);
      final aiText = response.text ?? 'I could not process that.';

      final aiMsg = ChatMessage(
        id: const Uuid().v4(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      await chatRepository.saveMessage(user.uid, currentSessionId.value, aiMsg, text.isNotEmpty ? text : 'Image Chat');
    } catch (e) {
      Get.snackbar('Error', 'AI error: $e');
    } finally {
      isAiThinking.value = false;
    }
  }
}