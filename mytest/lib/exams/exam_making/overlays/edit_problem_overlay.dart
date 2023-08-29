import 'package:flutter/material.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/counter.dart';
import 'package:mytest/abstract_classes/counter_listener.dart';

import 'package:mytest/utils/data_manager.dart';
import 'package:mytest/models/models.dart';

import '../mixins/exam_edit_mixin.dart';


class EditProblemOverlay extends StatefulWidget {

  final Test test;
  final Question? question;
  final void Function(bool) closeOverlay;

  const EditProblemOverlay({ super.key, required this.test, required this.closeOverlay, this.question });

  @override
  State<EditProblemOverlay> createState() => _EditProblemOverlayState();
}

class _EditProblemOverlayState extends State<EditProblemOverlay> with ExamEditMixin implements CounterListener {

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  int _allowedMistakes = 0;

  @override
  void valueChanged(int newValue) => _allowedMistakes = newValue;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _questionController.text = widget.question?.question ?? "";
    _answerController.text = widget.question?.answer ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "問題追加",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: MTTextField(
            hintText: "問題",
            controller: _questionController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: MTTextField(
            hintText: "答え",
            controller: _answerController,
          ),
        ),
        Row(
          children: [
            Counter(listener: this),
            Text("誤字まで許可する"),
          ],
        ),
        TextButton(onPressed: () {}, child: Text("写真をアップする")),
        TextButton(
          child: Text("決定"),
          onPressed: () {
            print("heloooo???");
            editQuestion(
              widget.test,
              _questionController.text,
              _answerController.text,
              _allowedMistakes,
              [],
              widget.question,
              widget.closeOverlay
            );
          },
        )
      ],
    );
  }
}