import 'package:flutter/material.dart';
import 'package:mytest/models/record.dart';
import '../../mixins/record_mixin.dart';
import 'package:mytest/constants.dart';

class RecordView extends StatelessWidget with RecordMixin {

  final Record record;

  const RecordView({ super.key, required this.record });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getDate(record),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Constants.white
            ),
          ),
          Row(
            children: [
              Text(
                '${record.correctQuestions.length + record.incorrectQuestions.length}問',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Constants.white
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '${getScore(record)}点',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Constants.white
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

