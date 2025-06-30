import 'package:chat_bot/model/message.dart';
import 'package:chat_bot/widget/chat_bubble.dart';
import 'package:chat_bot/widget/msg_input.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(Message(text: text, isUser: isUser, time: DateTime.now()));
    });
  }

  void _handleSend(String userInput) {
    if (userInput.trim().isEmpty) return;

    _addMessage(userInput, true); // user message

    // simple bot reply
    Future.delayed(const Duration(milliseconds: 500), () {
      String botReply = _getBotReply(userInput);
      _addMessage(botReply, false);
    });
  }

  String _getBotReply(String message) {
    if (message.toLowerCase().contains("hello")) {
      return "Hi there!";
    } else if (message.toLowerCase().contains("how are you")) {
      return "I'm just a bot, but I'm doing great!";
    } else {
      return "Sorry, I didn't get that.";
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: "Chat Bot".text.semiBold.white.make(),
      backgroundColor: const Color.fromARGB(255, 20, 32, 139),
      elevation: 4,
      centerTitle: true,
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
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) =>
                  ChatBubble(message: _messages[index]),
            ),
          ),
          MessageInput(onSend: _handleSend),
        ],
      ),
    ),
  );
}
}
