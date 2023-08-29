import 'package:flutter/material.dart';

import 'package:mytest/models/question.dart';


class QuestionView extends StatelessWidget {

  final Question question;
  final bool correct;

  const QuestionView({ super.key, required this.question, required this.correct });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: correct ? Colors.greenAccent.shade100 : Colors.redAccent.shade100,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.circle_outlined : Icons.close,
            color: correct ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('問', style: Theme.of(context).textTheme.bodySmall,),
                  const SizedBox(width: 10),
                  Text(
                    question.question,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('答', style: Theme.of(context).textTheme.bodySmall,),
                  const SizedBox(width: 10),
                  Text(
                    question.answer,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
