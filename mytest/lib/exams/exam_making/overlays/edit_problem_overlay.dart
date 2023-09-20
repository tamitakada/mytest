import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/counter.dart';
import 'package:mytest/abstract_classes/counter_listener.dart';

import 'package:mytest/utils/data_manager.dart';
import 'package:mytest/models/models.dart';

import '../mixins/exam_edit_mixin.dart';

import 'package:mytest/utils/file_utils.dart';
import 'package:mytest/pair.dart';

import 'package:mytest/widgets/scrollable_image_display.dart';


class EditProblemOverlay extends StatefulWidget {

  final Test test;
  final Question? question;
  final void Function(bool) closeOverlay;

  const EditProblemOverlay({ super.key, required this.test, required this.closeOverlay, this.question });

  @override
  State<EditProblemOverlay> createState() => _EditProblemOverlayState();
}

class _EditProblemOverlayState extends State<EditProblemOverlay> with ExamEditMixin {

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  List<Pair<String, bool>> _images = [];

  void _selectNewImage() {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['jpg', 'png'],
      );
      openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]).then((file) {
        if (file != null) {
          setState((){ _images.add(Pair<String, bool>(a: file.path, b: false)); });
        }
      });
    } catch (e) {
      print(e);
    }
  }

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
    _images = widget.question?.images?.map(
      (e) => Pair<String, bool>(a: e, b: true)
    ).toList() ?? [];
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
        Expanded(
          child: ScrollableImageDisplay(
            images: _images,
            onDelete: (int index) {
              setState(() { _images.removeAt(index); });
            },
          )
        ),
        TextButton(
          onPressed: _selectNewImage,
          child: Text("写真をアップする")
        ),
        TextButton(
          child: Text("決定"),
          onPressed: () {
            editQuestion(
              widget.test,
              _questionController.text,
              _answerController.text,
              0,
              _images,
              widget.question
            ).then(widget.closeOverlay);
          },
        )
      ],
    );
  }
}