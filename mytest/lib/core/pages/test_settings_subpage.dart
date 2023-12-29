import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/app_state.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/widgets/error_page.dart';
import 'package:mytest/widgets/spaced_group.dart';


class TestSettingsSubpage extends StatefulWidget {

  const TestSettingsSubpage({super.key});

  @override
  State<TestSettingsSubpage> createState() => _TestSettingsSubpageState();
}

class _TestSettingsSubpageState extends State<TestSettingsSubpage> with AlertMixin {

  Test? _currentTest;

  late bool _mistakeMode;
  late bool _flipped;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.selectedTest,
      builder: (context, test, child) {
        if (_currentTest != test) {
          _mistakeMode = test?.allowError ?? false;
          _flipped = test?.flipTerms ?? false;
          _currentTest = test;
        }
        return test != null
          ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  "設定",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Constants.charcoal,
                    size: 20,
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: SpacedGroup(
                axis: Axis.vertical,
                spacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.sakura
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '一定の誤差まで許容する',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _mistakeMode,
                          activeColor: Constants.salmon,
                          inactiveThumbColor: Constants.charcoal,
                          onChanged: (bool value) {
                            setState(() => _mistakeMode = value);
                            test.allowError = _mistakeMode;
                            DataManager.upsertTest(test).then((success) {
                              if (!success) {
                                setState(() => _mistakeMode = !value); // Reverse changes
                                showErrorDialog(context, ErrorType.save);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.sakura
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '問題と解答を逆にする',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _flipped,
                          activeColor: Constants.salmon,
                          inactiveThumbColor: Constants.charcoal,
                          onChanged: (bool value) {
                            setState(() => _flipped = value);
                            test.flipTerms = _flipped;
                            DataManager.upsertTest(test).then((success) {
                              if (!success) {
                                setState(() => _flipped = !value); // Reverse changes
                                showErrorDialog(context, ErrorType.save);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.sakura
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'テストをCSVファイルとしてダウンロードする',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            String str = "";
                            for (Question q in test!.questions) {
                              str += "${q.question}\n${q.answer}\n${q.images}\n\n";
                            }
                            print(str);
                          },
                          icon: Icon(
                            Icons.download
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
          )
          : const ErrorPage(margin: EdgeInsets.fromLTRB(0, 0, 20, 0), message: "表示できるテストがありません");
      }
    );
  }
}
