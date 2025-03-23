import 'package:flutter/material.dart';
import 'package:robotics_app/widgets/moving_logo.dart';

class WaitingPageAtFirst extends StatefulWidget {
  const WaitingPageAtFirst({super.key});

  @override
  State<WaitingPageAtFirst> createState() => _WaitingPageAtFirstState();
}

class _WaitingPageAtFirstState extends State<WaitingPageAtFirst>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true); // Repeat the animation in reverse

    _animation = Tween<double>(begin: -50.0, end: 50.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MovingLogo(
      animationController: _animationController,
      animation: _animation,
    );
  }
}
