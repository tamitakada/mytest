import 'package:flutter/material.dart';

import 'package:mytest/models/question.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/utils/file_utils.dart';

import 'package:mytest/widgets/scrollable_image_display.dart';

import 'package:mytest/pair.dart';


class QuestionListTile extends StatelessWidget {

  final Question question;
  final void Function() onTap;
  final void Function() onDismissed;

  const QuestionListTile({
    super.key,
    required this.question,
    required this.onTap,
    required this.onDismissed
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) => onDismissed(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
         //   color: Constants.blue,
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
              ),
              SizedBox(
                height: (question.images != null && question.images!.isNotEmpty) ? 80 : 0,
                child: ScrollableImageDisplay(
                  images: question.images?.map((e) => Pair<String, bool>(a: e, b: true)).toList() ?? [],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
