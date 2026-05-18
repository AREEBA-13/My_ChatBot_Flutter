import 'package:chat_bot/core/theme/app_theme.dart';
import 'package:chat_bot/data/model/message_model.dart';
import 'package:chat_bot/data/service/groq_service.dart';
import 'package:chat_bot/data/service/firestore_service.dart';
import 'package:chat_bot/presentation/widget/chat_bubble.dart';
import 'package:chat_bot/presentation/widget/msg_input.dart';
import 'package:chat_bot/presentation/widget/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GroqService _groqService = GroqService();
  final FirestoreService _firestoreService = FirestoreService();
  
  List<MessageModel> _cachedMessages = [];
  bool _isTyping = false;

  Future<void> _handleSend(String userInput) async {
    if (userInput.trim().isEmpty) return;

    // 1. Save user message to Firestore (automatically updates the UI stream in real-time)
    await _firestoreService.saveMessage(userInput, true);

    // 2. Show the animated typing indicator
    setState(() {
      _isTyping = true;
    });

    // 3. Format history for Groq API in chronological order (oldest first)
    // Since our stream orders newest first (for the reversed list view), we reverse it back.
    final chatHistory = _cachedMessages.reversed.map((msg) {
      return {
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.text,
      };
    }).toList();

    // 4. Request dynamic completion response from Groq AI
    final botReply = await _groqService.getChatResponse(chatHistory);

    // 5. Save bot reply to Firestore
    await _firestoreService.saveMessage(botReply, false);

    // 6. Stop typing indicator
    setState(() {
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Groq Chat Bot".text.semiBold.white.make(),
        backgroundColor: AppTheme.primaryColor,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            tooltip: "Clear Chat History",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Clear History"),
                  content: const Text("Are you sure you want to delete all messages? This cannot be undone."),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    TextButton(
                      child: const Text("Clear", style: TextStyle(color: Colors.red)),
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _firestoreService.clearChatHistory();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: _firestoreService.getMessagesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: "Error loading chat: ${snapshot.error}".text.red500.make().p16(),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Cache the real-time messages list locally to generate context for Groq
                  if (snapshot.hasData) {
                    _cachedMessages = snapshot.data!;
                  }

                  final messages = snapshot.data ?? [];

                  if (messages.isEmpty && !_isTyping) {
                    return Center(
                      child: VStack([
                        const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white54),
                        16.heightBox,
                        "Start a conversation with Groq AI!".text.white.semiBold.make(),
                      ], alignment: MainAxisAlignment.center, crossAlignment: CrossAxisAlignment.center),
                    );
                  }

                  return ListView.builder(
                    reverse: true, // Newer messages appear at the bottom
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (ctx, index) {
                      if (_isTyping && index == 0) {
                        return const TypingIndicator();
                      }
                      final msgIndex = _isTyping ? index - 1 : index;
                      return ChatBubble(message: messages[msgIndex]);
                    },
                  );
                },
              ),
            ),
            MessageInput(onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}
