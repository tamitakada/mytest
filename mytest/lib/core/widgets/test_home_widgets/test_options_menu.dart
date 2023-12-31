import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/app_state.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/global_widgets/mt_button.dart';


class TestOptionsMenu extends StatelessWidget with AlertMixin {

  final void Function() resetState;

  const TestOptionsMenu({
    super.key, required this.resetState
  });

  void _onOptionSelect(BuildContext context, void Function() navigateToTest) {
    switch (AppState.editingState.value) {
      case EditingState.editingTest:
        showConfirmationDialog(
          context: context,
          title: "練習を開始しますか？",
          description: "保存されていない変更があります。変更を放棄してテストを開始しますか？",
          confirmText: "開始する",
          onConfirm: navigateToTest
        );
        break;
      case EditingState.editingTestListing:
        showConfirmationDialog(
          context: context,
          title: "練習を開始しますか？",
          description: "保存されていない変更があります。変更を放棄してテストを開始しますか？",
          confirmText: "開始する",
          onConfirm: navigateToTest
        );
        break;
      case EditingState.editingBoth:
        showConfirmationDialog(
            context: context,
            title: "練習を開始しますか？",
            description: "保存されていない変更があります。変更を放棄してテストを開始しますか？",
            confirmText: "開始する",
            onConfirm: navigateToTest
        );
        break;
      case EditingState.notEditing:
        navigateToTest();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.salmon,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "勉強する",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.white
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: TestMode.values.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    0, 0, index < TestMode.values.length - 1 ? 10 : 0, 0
                  ),
                  child: MTButton(
                    onTap: () => _onOptionSelect(context, () {
                      resetState();
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        '/exams/${Constants.modeRouteName(TestMode.values[index])}',
                      );
                    }),
                    text: Constants.modeName(TestMode.values[index]),
                    enabled: AppState.selectedTest.value!.questions.isNotEmpty,
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
