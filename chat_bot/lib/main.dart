import 'package:chat_bot/firebase_options.dart';
import 'package:chat_bot/presentation/screen/chat_screen.dart';
import 'package:chat_bot/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configurations from local .env
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with dynamic options
  try {
    if (DefaultFirebaseOptions.web.apiKey != 'YOUR_FIREBASE_API_KEY') {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Dynamic Anonymous Sign-In on app startup
      await FirebaseAuth.instance.signInAnonymously();
      debugPrint("Firebase Auth: Authenticated anonymously successfully!");
    } else {
      // Safe fallback if Firebase is not yet configured in firebase_options.dart
      debugPrint("Firebase Notice: Initializing Firebase locally. Make sure to paste your actual keys into lib/firebase_options.dart!");
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase Warning: Initialization/Authentication failed. $e");
  }

  runApp(const ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Linked central theme
      home: const ChatScreen(),
    );
  }
}
