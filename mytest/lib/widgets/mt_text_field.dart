import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';


class MTTextField extends StatelessWidget {

  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;

  const MTTextField({ super.key, this.hintText, this.onSubmitted, this.onChanged, this.controller });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Constants.charcoal.withOpacity(0.5)
        ),
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.charcoal, width: 2)
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.charcoal, width: 2)
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.charcoal, width: 2)
        ),
        suffixIcon: const Icon(
          Icons.arrow_forward_rounded,
          color: Constants.charcoal,
        )
      ),
    );
  }
}
