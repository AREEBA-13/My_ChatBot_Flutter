import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HStack([
  Expanded(
    child: TextField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: "Type a message",
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(16),
      ),
    ).box.border(color: Vx.gray300).roundedLg.make(),
  ),
  8.widthBox,
  VxBox(
    child: Icon(
      Icons.send,
      color: Colors.white,
      size: 24,
    ),
  )
      .roundedFull
      .color(const Color.fromARGB(255, 20, 32, 139))
      .size(48, 48)
      .make()
      .onTap(_submit),
])
.p12()
.backgroundColor(Colors.white);

  }
}
