import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';

class ShakeableView extends StatefulWidget {

  final bool animated;
  final Widget child;

  const ShakeableView({
    super.key,
    required this.animated,
    required this.child
  });

  @override
  State<ShakeableView> createState() => _ShakeableViewState();
}

class _ShakeableViewState extends State<ShakeableView> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _animation = Tween<Offset>(begin: Offset.zero, end: const Offset(0.01, 0)).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.repeat(reverse: true);
        Future.delayed(const Duration(milliseconds: 480), () {
          _controller.reset();
        });
      });
    }
    return SlideTransition(
      position: _animation,
      child: widget.child
    );
  }
}
