import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';

class MTButton extends StatefulWidget {

  final void Function() onTap;
  final Color color;
  final String text;
  final TextStyle? style;

  const MTButton({ super.key, required this.onTap, required this.text, this.style, this.color = Constants.salmon });

  @override
  State<MTButton> createState() => _MTButtonState();
}

class _MTButtonState extends State<MTButton> with WidgetsBindingObserver {

  bool _isPressed = false;
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { setState(() { _isPressed = true; }); },
      onTapUp: (_) { setState(() { _isPressed = false; }); },
      onTapCancel: () { setState(() { _isPressed = false; }); },
      onTap: () {
        if (_isActive) {
          Future.delayed(const Duration(milliseconds: 110), () {
            setState(() { _isPressed = false; _isActive = true; });
          });
          setState(() { _isPressed = true; _isActive = false; });
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: _isActive && _isPressed ? Constants.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Constants.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          widget.text,
          style: widget.style ?? Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Constants.white
          ),
        ),
      ),
    );
  }
}
