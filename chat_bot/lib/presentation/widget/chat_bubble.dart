import 'package:chat_bot/core/theme/app_theme.dart';
import 'package:chat_bot/data/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

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
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/bot_avatar.png"),
          ).pOnly(right: 8),

        // Chat bubble + timestamp
        Flexible(
          child: VStack([
                message.text.text.white.make(),
                4.heightBox,
                timeString.text.xs.gray200.make(),
              ])
              .p12()
              .box
              .color(
                message.isUser
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryColor,
              )
              .rounded
              .make(),
        ),

        if (message.isUser)
          const CircleAvatar(
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
