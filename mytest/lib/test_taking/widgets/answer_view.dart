import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

class AnswerView extends StatelessWidget {

  final String answer;

  const AnswerView({ super.key, required this.answer });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Constants.salmon, width: 2)
          ),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Constants.salmon
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: FractionalTranslation(
            translation: const Offset(0, -0.5),
            child: Container(
              color: Constants.sakura,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                "正解は",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Constants.salmon
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
