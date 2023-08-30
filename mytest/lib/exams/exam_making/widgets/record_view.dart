import 'package:flutter/material.dart';
import 'package:mytest/models/record.dart';
import '../mixins/record_mixin.dart';

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
            '${record.time.month}月${record.time.day}日${record.time.year}年　${record.time.hour}時${record.time.minute}分',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(
            width: 100,
            child: Row(
              children: [
                Text(
                  'スコア',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    '${getScore(record)}点',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

