import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/app_state.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/widgets/error_page.dart';
import 'package:mytest/widgets/spaced_group.dart';

import '../widgets/test_setting_listing.dart';


class TestSettingsSubpage extends StatefulWidget {

  final void Function() onDeleteTest;

  const TestSettingsSubpage({
    super.key, required this.onDeleteTest
  });

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          toolbarHeight: 80,
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
              TestSettingListing(
                description: 'テスト名を変える',
                settingChild: IconButton(
                  onPressed: () =>  showTitleEditDialog(
                    context,
                    'テスト改名',
                    (title) => _editTestTitle(context, title),
                    initialValue: AppState.selectedTest.value!.title
                  ),
                  icon: const Icon(
                    Icons.change_circle_outlined,
                    color: Constants.charcoal,
                    size: 24,
                  ),
                ),
              ),
              TestSettingListing(
                description: '一定の誤差まで許容する',
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
                description: '問題と答えを逆にする',
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
                description: 'テストを削除する',
                settingChild: IconButton(
                  onPressed: () => showDeletionConfirmationDialog(
                    context, () => _deleteTest(context)
                  ),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Constants.charcoal,
                    size: 20,
                  ),
                ),
              ),
            ]
          ),
        ),
      )
      : const ErrorPage(margin: EdgeInsets.fromLTRB(0, 0, 20, 0), message: "表示できるテストがありません");
  }
}
