import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/app_state.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/global_widgets/global_widgets.dart';
import '../widgets/test_setting_listing.dart';


class TestSettingsSubpage extends StatefulWidget {

  const TestSettingsSubpage({super.key});

  @override
  State<TestSettingsSubpage> createState() => _TestSettingsSubpageState();
}

class _TestSettingsSubpageState extends State<TestSettingsSubpage> with AlertMixin {

  Test? _currentTest;

  void _editTestTitle(BuildContext context, String title) {
    if (AppState.selectedTest.value != null) {
      AppState.selectedTest.value!.title = title;
      DataManager.upsertTest(AppState.selectedTest.value!).then((success) {
        if (!success) { showErrorDialog(context, ErrorType.save); }
      });
    }
  }

  void _deleteTest(BuildContext context) {
    if (AppState.selectedTest.value != null) {
      int order = AppState.selectedTest.value!.order;
      AppState.deleteTest(AppState.selectedTest.value!).then((success) {
        if (success) {
          // Choose new selected value upon deletion of current selection
          if (order == 0 && AppState.getAllTests().isNotEmpty) {
            // Select test directly below if no tests above
            AppState.selectedTest.value = AppState.getAllTests()[0];
          }
          else { // Select test directly above if exists
            AppState.selectedTest.value = order > 0
              ? AppState.getAllTests()[order - 1]
              : null;
          }
          Navigator.of(context).popUntil(ModalRoute.withName("test_detail/home"));
        }
        else {
          showErrorDialog(context, ErrorType.save);
        }
      });
    }
  }

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
        body: Column(
          children: [
            MTAppBar(
              title: '設定',
              leading: ScaleButton(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  'assets/images/back.svg',
                  height: 20,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: SpacedGroup(
                  axis: Axis.vertical,
                  spacing: 10,
                  children: [
                    TestSettingListing(
                      description: 'テスト名を変える',
                      settingChild: ScaleButton(
                        onTap: () =>  showTitleEditDialog(
                          context,
                          'テスト改名',
                          (title) => _editTestTitle(context, title),
                          initialValue: AppState.selectedTest.value!.title
                        ),
                        child: SvgPicture.asset(
                          'assets/images/switch.svg',
                          height: 24,
                        ),
                      ),
                    ),
                    TestSettingListing(
                      description: '10%の誤差を許容する',
                      settingChild: Switch(
                        value: AppState.selectedTest.value!.allowError,
                        activeColor: Constants.salmon,
                        inactiveThumbColor: Constants.charcoal,
                        onChanged: (bool value) {
                          setState(() => AppState.selectedTest.value!.allowError = value);
                          DataManager.upsertTest(AppState.selectedTest.value!).then((success) {
                            if (!success) {
                              setState(() => AppState.selectedTest.value!.allowError = !value); // Reverse changes
                              showErrorDialog(context, ErrorType.save);
                            }
                          });
                        },
                      ),
                    ),
                    TestSettingListing(
                      description: '問題と解答を逆にする',
                      settingChild: Switch(
                        value: AppState.selectedTest.value!.flipTerms,
                        activeColor: Constants.salmon,
                        inactiveThumbColor: Constants.charcoal,
                        onChanged: (bool value) {
                          setState(() => AppState.selectedTest.value!.flipTerms = value);
                          DataManager.upsertTest(AppState.selectedTest.value!).then((success) {
                            if (!success) {
                              setState(() => AppState.selectedTest.value!.flipTerms = !value); // Reverse changes
                              showErrorDialog(context, ErrorType.save);
                            }
                          });
                        },
                      ),
                    ),
                    TestSettingListing(
                      description: 'テスト削除',
                      settingChild: ScaleButton(
                        onTap: () => showConfirmationDialog(
                          context: context,
                          type: ConfirmationType.deletion,
                          onConfirm: () => _deleteTest(context)
                        ),
                        child: SvgPicture.asset(
                          'assets/images/delete.svg',
                          height: 24,
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      )
      : const ErrorPage(margin: EdgeInsets.fromLTRB(0, 0, 20, 0), message: "表示できるテストがありません");
  }
}
