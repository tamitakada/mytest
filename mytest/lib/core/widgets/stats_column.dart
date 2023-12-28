import 'package:flutter/material.dart';
import 'package:mytest/models/record.dart';
import 'package:mytest/constants.dart';
import 'record_view.dart';


class StatsColumn extends StatelessWidget {

  final TestMode mode;
  final List<Record> records;

  const StatsColumn({ super.key, required this.mode, required this.records });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Constants.sakura
          ),
          child: Text(
            Constants.modeName(mode),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Constants.salmon,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (BuildContext context, int index) {
                return RecordView(record: records[index]);
              }
            ),
          ),
        ),
      ],
    );
  }
}
