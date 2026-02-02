import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(0), // AI side
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return FadeTransition(
            opacity: DelayTween(
              begin: 0.0,
              end: 1.0,
              delay: index * 0.2,
            ).animate(_controller),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({super.begin, super.end, required this.delay});

  @override
  double lerp(double t) {
    return super.lerp((t - delay).clamp(0.0, 1.0));
  }
}
