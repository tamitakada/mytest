import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

class ErrorPage extends StatelessWidget {

  final EdgeInsets margin;
  final String message;

  const ErrorPage({
    super.key,
    this.message = "エラーが発生しました",
    this.margin = EdgeInsets.zero
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Constants.sakura,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '└[☉ロ☉]┘',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Constants.salmon,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.salmon
            ),
          ),
        ],
      ),
    );
  }
}
