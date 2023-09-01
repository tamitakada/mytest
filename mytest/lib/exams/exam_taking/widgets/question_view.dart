import 'package:flutter/material.dart';

import 'package:mytest/models/question.dart';

import 'package:mytest/constants.dart';


class QuestionView extends StatefulWidget {

  final Question question;
  final int questionNumber;
  final bool correct;

  const QuestionView({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.correct
  });

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {

  bool _questionSide = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          widget.correct ? Icons.circle_outlined : Icons.close,
          color: widget.correct? Constants.lightGreen : Constants.yellow,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: _questionSide ? Constants.lightBlue : Constants.darkBlue,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Text(
                  '${widget.questionNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _questionSide ? widget.question.question : widget.question.answer,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() { _questionSide = !_questionSide; }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _questionSide ? Constants.darkBlue : Constants.lightBlue,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                    ),
                    child: Text(
                      _questionSide ? '答' : '問',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
              ],
            )
          ),
        )
      ]
    );
  }
}
