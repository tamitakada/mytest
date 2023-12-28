import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/utils/data_manager.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/widgets/mt_switch.dart';
import 'package:mytest/widgets/spaced_group.dart';


class TestSettingsSubpage extends StatefulWidget {

  const TestSettingsSubpage({super.key});

  @override
  State<TestSettingsSubpage> createState() => _TestSettingsSubpageState();
}

class _TestSettingsSubpageState extends State<TestSettingsSubpage> {

  Test? test;

  late bool _mistakeMode;
  late bool _flipped;

  @override
  Widget build(BuildContext context) {
    test ??= (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)["test"] as Test;
    _mistakeMode = test!.allowError;
    _flipped = test!.flipTerms;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          "${test!.title}　設定",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
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
                  MTSwitch(
                    height: 26,
                    initialState: _mistakeMode,
                    switchUpdated: (isOn) {
                      _mistakeMode = isOn;
                      test!.allowError = isOn;
                      DataManager.upsertTest(test!);
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
                  MTSwitch(
                    height: 26,
                    initialState: _flipped,
                    switchUpdated: (isOn) {
                      _flipped = isOn;
                      test!.flipTerms = isOn;
                      DataManager.upsertTest(test!);
                    },
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
