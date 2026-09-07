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

  GenerativeModel? _geminiModel;
  bool _cancelAiGeneration = false; // Flag to stop AI

  // Model Selection Data
  final List<String> models = ['gemini-2.5-flash', 'gemini-2.5-flash'];
  RxString selectedModel = 'gemini-2.5-flash'.obs;

  // State
  RxBool hasMessage = false.obs;
  RxBool isAiThinking = false.obs;
  RxBool isListening = false.obs;
  RxBool isInputFocused = false.obs; // Tracks if text field is clicked

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

    // Listen to focus changes for the border color
    messageFocusNode.addListener(() {
      isInputFocused.value = messageFocusNode.hasFocus;
    });
  }

  void selectModel(String model) {
    selectedModel.value = model;
    _initGemini();
  }

  void _initGemini() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      String aiModel = selectedModel.value == 'gemini-2.5-flash' ? 'gemini-2.5-flash' : 'gemini-2.5-flash';
      _geminiModel = GenerativeModel(model: aiModel, apiKey: apiKey);
    }
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize();
  }

  void createNewChat() {
    currentSessionId.value = '';
    currentMessages.clear(); // Clears messages to show "Welcome" screen
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

  // Feature: Stop AI generation
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

    // Create session if it doesn't exist
    if (currentSessionId.value.isEmpty) {
      currentSessionId.value = const Uuid().v4();
      // Only start listening to Firebase after creating ID
      loadSession(currentSessionId.value);
    }

    messageController.clear();
    FocusScope.of(Get.context!).unfocus();
    isAiThinking.value = true;
    _cancelAiGeneration = false; // Reset cancel flag

    String? base64String;
    List<Part> promptParts = [];

    if (text.isNotEmpty) promptParts.add(TextPart(text));

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      base64String = base64Encode(bytes);
      promptParts.add(DataPart('image/jpeg', bytes));
    }

    selectedImage.value = null; // clear image after encoding

    // 1. Optimistically add user message to UI immediately
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      base64Image: base64String,
      timestamp: DateTime.now(),
    );
    currentMessages.add(userMsg);

    try {
      // Save user message to Firebase
      await chatRepository.saveMessage(user.uid, currentSessionId.value, userMsg, text.isNotEmpty ? text : 'Image Chat');

      // Check if API key is missing
      if (_geminiModel == null) {
        throw Exception('MISSING_API_KEY');
      }

      // Generate AI Content
      final response = await _geminiModel!.generateContent([Content.multi(promptParts)]);

      if (_cancelAiGeneration) return; // Ignore response if user clicked stop

      final aiText = response.text ?? 'I could not process that.';

      // Save AI message to Firebase
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

      // Handle Quota/Limits or Missing Key
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
      currentMessages.add(errorMsg); // Show error in chat

    } finally {
      isAiThinking.value = false;
    }
  }
}