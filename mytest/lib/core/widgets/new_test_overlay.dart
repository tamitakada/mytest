import 'package:flutter/material.dart';

import 'package:mytest/abstract_classes/overlay_manager.dart';
import 'package:mytest/utils/data_manager.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/widgets/mt_text_field.dart';


class NewTestOverlay extends StatelessWidget {

  final void Function(Test) closeOverlay;

  const NewTestOverlay({ super.key, required this.closeOverlay });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("テスト追加"),
        MTTextField(
          hintText: "名前",
          onSubmitted: (title) {
            Test newTest = Test(title: title);
            DataManager.upsertTest(newTest).then(
              (success) => closeOverlay(newTest)
            );
          }
        ),
      ]
    );
  }
}
