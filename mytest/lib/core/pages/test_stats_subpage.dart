import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import '../mixins/record_mixin.dart';

import 'package:mytest/global_widgets/global_widgets.dart';
import '../widgets/test_stats_widgets/stats_column.dart';
import 'package:mytest/app_state.dart';


class TestStatsSubpage extends StatefulWidget {

  const TestStatsSubpage({super.key});

  @override
  State<TestStatsSubpage> createState() => _TestStatsSubpageState();
}

class _TestStatsSubpageState extends State<TestStatsSubpage> with RecordMixin, AlertMixin {

  Test? _currentTest;
  bool _isShowingError = false; // Prevent duplicate error messages

  void _pushNewTestDetail() {
    if (_currentTest != AppState.selectedTest.value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        "test_detail/home", (route) => false
      );
    }
  }

  @override
  void initState() {
    _currentTest = AppState.selectedTest.value;
    AppState.selectedTest.addListener(_pushNewTestDetail);
    super.initState();
  }

  @override
  void dispose() {
    AppState.selectedTest.removeListener(_pushNewTestDetail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppState.selectedTest.value != null
      ? Scaffold(
        backgroundColor: Constants.white,
        body: Column(
          children: [
            MTAppBar(
              title: '記録',
              leading: ScaleButton(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  'assets/images/back.svg',
                  height: 20,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Record>?>(
                future: DataManager.getAllRecords(AppState.selectedTest.value!),
                builder: (BuildContext context, AsyncSnapshot<List<Record>?> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      List<Record> records = snapshot.data!;
                      Map<TestMode, List<Record>> sortedRecords = sortRecordsByType(records);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
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
                          ],
                        ),
                      );
                    }
                    if (!_isShowingError) {
                      _isShowingError = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showErrorDialog(context, ErrorType.fetch)
                          .then((_) => _isShowingError = false);
                      });
                    }
                    return const ErrorPage(margin: EdgeInsets.fromLTRB(20, 20, 0, 20));
                  }
                  return const StaticLoader();
                },
              ),
            ),
          ],
        ),
      )
      : const ErrorPage(margin: EdgeInsets.fromLTRB(20, 0, 0, 20), message: "表示できるテストがありません");
  }
}
