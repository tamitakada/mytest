import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

class ErrorPage extends StatelessWidget {

  final EdgeInsets margin;

  const ErrorPage({super.key, this.margin = const EdgeInsets.all(20)});

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
          const Icon(
            Icons.error_outline,
            color: Constants.salmon,
            size: 30,
          ),
          const SizedBox(height: 20),
          Text(
            'エラーが発生しました',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.salmon
            ),
          ),
        ],
      ),
    );
  }
}
