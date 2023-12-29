import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';


class MTTextField extends StatelessWidget {

  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;

  const MTTextField({
    super.key,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        border: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal.withOpacity(0.4), width: 2)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Constants.charcoal, width: 2))
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
