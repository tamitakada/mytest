import 'package:flutter/material.dart';

import 'package:mytest/models/question.dart';
import 'package:mytest/constants.dart';


class QuestionListTile extends StatelessWidget {

  final Question question;
  final void Function() onTap;

  const QuestionListTile({ super.key, required this.question, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Constants.lightBlue,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "問",
                  style: Theme.of(context).textTheme.bodySmall
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    question.question,
                    style: Theme.of(context).textTheme.bodySmall
                  )
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "答",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    question.answer,
                    style: Theme.of(context).textTheme.bodySmall
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
