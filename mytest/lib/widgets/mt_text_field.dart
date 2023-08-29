import 'package:flutter/material.dart';

class MTTextField extends StatelessWidget {

  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String? hintText;

  const MTTextField({ super.key, this.hintText, this.onSubmitted, this.controller });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1
          )
        ),
        suffixIcon: Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        )
      ),
    );
  }
}
