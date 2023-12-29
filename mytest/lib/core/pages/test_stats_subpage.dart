import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import '../mixins/record_mixin.dart';

import 'package:mytest/widgets/spaced_group.dart';
import '../widgets/test_stats_widgets/stats_column.dart';
import 'package:mytest/widgets/error_page.dart';
import 'package:mytest/app_state.dart';


class TestStatsSubpage extends StatelessWidget with RecordMixin, AlertMixin {

  const TestStatsSubpage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.selectedTest,
      builder: (context, test, child) {
        return test != null
          ? Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              centerTitle: false,
              title: Text(
                "記録",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            backgroundColor: Constants.white,
            body: FutureBuilder<List<Record>?>(
              future: DataManager.getAllRecords(test),
              builder: (BuildContext context, AsyncSnapshot<List<Record>?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    List<Record> records = snapshot.data!;
                    Map<TestMode, List<Record>> sortedRecords = sortRecordsByType(records);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: SpacedGroup(
                        axis: Axis.horizontal,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: StatsColumn(
                              mode: TestMode.full,
                              records: sortedRecords[TestMode.full] ?? [],
                            )
                          ),
                          Expanded(
                            child: StatsColumn(
                              mode: TestMode.lives,
                              records: sortedRecords[TestMode.lives] ?? [],
                            )
                          ),
                          Expanded(
                            child: StatsColumn(
                              mode: TestMode.practice,
                              records: sortedRecords[TestMode.practice] ?? [],
                            )
                          ),
                        ],
                      ),
                    );
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showErrorDialog(context, ErrorType.fetch);
                  });
                  return const ErrorPage(margin: EdgeInsets.fromLTRB(0, 20, 20, 0));
                }
                return Container(); // TODO: loading
              },
            ),
          )
          : const ErrorPage(margin: EdgeInsets.fromLTRB(0, 0, 20, 0), message: "表示できるテストがありません");
      }
    );
  }
}
