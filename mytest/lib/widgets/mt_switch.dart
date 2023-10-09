import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';

class MTSwitch extends StatefulWidget {

  final bool initialState;
  final Color switchColor;
  final Color onColor;
  final Color offColor;
  final double height;

  final void Function(bool)? switchUpdated;

  const MTSwitch({
    super.key,
    this.height = 22,
    this.onColor = Constants.lightGreen,
    this.offColor = Constants.yellow,
    this.switchColor = Colors.white,
    this.initialState = true,
    this.switchUpdated
  });

  @override
  State<MTSwitch> createState() => _MTSwitchState();
}

class _MTSwitchState extends State<MTSwitch> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _animation;

  late bool _isOn;

  @override
  void initState() {
    _isOn = widget.initialState;
    _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 240)
    );
    _animation = Tween<Offset>(
      begin: _isOn ? Offset(0, 0) : Offset(1, 0),
      end: _isOn ? Offset(1, 0) : Offset(0, 0)
    ).animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() { _isOn = !_isOn; });
        if (_isOn) { _controller.reverse(); }
        else { _controller.forward(); }
        if (widget.switchUpdated != null) {
          widget.switchUpdated!(_isOn);
        }
      },
      child: Stack(
        children: [
          AnimatedContainer(
            height: widget.height,
            width: widget.height * 2,
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(
              color: _isOn ? widget.onColor : widget.offColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: widget.switchColor.withOpacity(0.5), width: 2)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'オフ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
                Text(
                  'オン',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return SlideTransition(
                position: _animation,
                child: child,
              );
            },
            child: Container(
              width: widget.height,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.switchColor,
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
