import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'presentation/home/ui/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load API Key
    await dotenv.load(fileName: ".env");

    // 2. CHECK IF KEY LOADED AND PRINT TO TERMINAL
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      print("==========================================");
      print("✅ SUCCESS: .env file loaded successfully!");
      // Print just the first 3 characters for security
      print("🔑 API Key found, starts with: ${apiKey.substring(0, 3)}***");
      print("==========================================");
    } else {
      print("==========================================");
      print("❌ ERROR: .env file loaded, but GEMINI_API_KEY is empty!");
      print("==========================================");
    }
  } catch (e) {
    print("==========================================");
    print("🛑 CRITICAL ERROR: Could not load .env file!");
    print("Error details: $e");
    print("==========================================");
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp(
    home: HomeScreen(),
  ));
}