import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import '../mixins/record_mixin.dart';
import 'stats_column.dart';


class ExamStatsSubpage extends StatelessWidget with RecordMixin {

  final Test test;

  const ExamStatsSubpage({ super.key, required this.test });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
      //  color: Constants.yellow,
        borderRadius: BorderRadius.circular(10)
      ),
      child: FutureBuilder<List<Record>?>(
        future: DataManager.getAllRecords(test),
        builder: (BuildContext context, AsyncSnapshot<List<Record>?> snapshot) {
          if (snapshot.hasData) {
            List<Record> records = snapshot.data ?? [];
            Map<TestMode, List<Record>> sortedRecords = sortRecordsByType(records);
            return Row(
              children: [
                Expanded(
                  child: StatsColumn(
                    mode: TestMode.timed,
                    records: sortedRecords[TestMode.timed] ?? [],
                  )
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatsColumn(
                    mode: TestMode.lives,
                    records: sortedRecords[TestMode.lives] ?? [],
                  )
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatsColumn(
                    mode: TestMode.full,
                    records: sortedRecords[TestMode.full] ?? [],
                  )
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
