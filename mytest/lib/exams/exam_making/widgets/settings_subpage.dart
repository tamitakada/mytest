import 'package:flutter/material.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/mt_button.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/widgets/mt_switch.dart';
import 'package:mytest/models/models.dart';

import 'package:mytest/utils/data_manager.dart';


class ExamSettingsSubpage extends StatefulWidget {

  final Test test;
  final void Function() onDelete;
  final void Function(String) onUpdateTitle;

  const ExamSettingsSubpage({
    super.key,
    required this.test,
    required this.onDelete,
    required this.onUpdateTitle
  });

  @override
  State<ExamSettingsSubpage> createState() => _ExamSettingsSubpageState();
}

class _ExamSettingsSubpageState extends State<ExamSettingsSubpage> {

  late bool _mistakeMode;
  late bool _flipped;

  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    _mistakeMode = widget.test.allowError;
    _flipped = widget.test.flipTerms;
    _titleController.text = widget.test.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      decoration: BoxDecoration(
        color: Constants.salmon,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          MTTextField(
            hintText: 'テスト名',
            controller: _titleController,
            onSubmitted: widget.onUpdateTitle,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '一定の誤差まで許容する',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              MTSwitch(
                height: 26,
                initialState: _mistakeMode,
                switchUpdated: (isOn) {
                  _mistakeMode = isOn;
                  widget.test.allowError = isOn;
                  DataManager.upsertTest(widget.test);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '問題と解答を逆にする',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              MTSwitch(
                height: 26,
                initialState: _flipped,
                switchUpdated: (isOn) {
                  _flipped = isOn;
                  widget.test.flipTerms = isOn;
                  DataManager.upsertTest(widget.test);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          MTButton(
            text: '削除',
            onTap: widget.onDelete
          ),
        ]
      ),
    );
  }
}
