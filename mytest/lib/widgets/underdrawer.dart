import 'package:flutter/material.dart';

class Underdrawer extends StatefulWidget {

  final Widget? child;

  Underdrawer({ super.key, this.child });

  @override
  State<Underdrawer> createState() => _UnderdrawerState();
}

class _UnderdrawerState extends State<Underdrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: widget.child,
      ),
    );
  }
}
