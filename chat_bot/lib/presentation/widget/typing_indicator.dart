import 'package:chat_bot/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double delay = index * 0.2;
        final double value =
            (1.0 + (delay - _controller.value) % 1.0).clamp(0.0, 1.0);
        final double scale = 0.6 + (0.4 * (1.0 - (value - 0.5).abs() * 2));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage("assets/images/bot_avatar.png"),
        ).pOnly(right: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) => _buildDot(index)),
        )
            .p12()
            .box
            .color(AppTheme.secondaryColor)
            .rounded
            .make(),
      ],
    ).pOnly(left: 8, right: 60, top: 4, bottom: 4);
  }
}
