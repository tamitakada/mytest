import 'package:flutter/material.dart';

class ScaleButton extends StatefulWidget {

  final Widget child;
  final void Function() onTap;

  const ScaleButton({super.key, required this.onTap, required this.child});

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =  AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200)
    );
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.8), weight: 0.5),
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1), weight: 0.5)
    ]).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { _controller.reset(); _controller.forward(); },
      onTap: () {
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }

}
