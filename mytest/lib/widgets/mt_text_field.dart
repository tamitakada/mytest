import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';


class MTTextField extends StatelessWidget {

  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;
  final Color color;

  const MTTextField({
    super.key,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.color = Constants.charcoal
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color.withOpacity(0.4)
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        border: UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: color.withOpacity(0.4), width: 2)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
