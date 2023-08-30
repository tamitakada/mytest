import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';
import 'record_view.dart';


class ExamStatsSubpage extends StatefulWidget {
  const ExamStatsSubpage({Key? key}) : super(key: key);

  @override
  State<ExamStatsSubpage> createState() => _ExamStatsSubpageState();
}

class _ExamStatsSubpageState extends State<ExamStatsSubpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: Constants.yellow,
        borderRadius: BorderRadius.circular(10)
      ),
      child: FutureBuilder<List<Record>?>(
        future: DataManager.getAllRecords(),
        builder: (BuildContext context, AsyncSnapshot<List<Record>?> snapshot) {
          if (snapshot.hasData) {
            List<Record> records = snapshot.data ?? [];
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (BuildContext context, int index) {
                return RecordView(record: records[index]);
              }
            );
          }
          return Container();
        },
      ),
    );
  }
}
