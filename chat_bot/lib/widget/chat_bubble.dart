import 'package:chat_bot/model/message.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(message.time);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: message.isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!message.isUser)
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/bot_avatar.png"),
          ).pOnly(right: 8),

        // Chat bubble + timestamp
        VStack([
              message.text.text.white.make(),
              4.heightBox,
              timeString.text.xs.gray200.make(),
            ])
            .p12()
            .box
            .color(
              message.isUser
                  ? const Color.fromARGB(255, 20, 32, 139)
                  : const Color.fromARGB(255, 91, 147, 243),
            )
            .rounded
            .make(),

        if (message.isUser)
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/user_avatar.png"),
          ).pOnly(left: 8),
      ],
    ).pOnly(
      left: message.isUser ? 60 : 8,
      right: message.isUser ? 8 : 60,
      top: 4,
      bottom: 4,
    );
  }
}
