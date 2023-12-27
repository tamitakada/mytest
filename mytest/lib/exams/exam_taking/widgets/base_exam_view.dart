import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';

import 'package:mytest/utils/file_utils.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/widgets/scrollable_image_display.dart';


class BaseExamView extends StatefulWidget {

  final Test test;
  final Question question;
  final int questionNumber;

  final bool mistakeMode;
  final bool paused;

  final TestMode mode;

  final void Function(String) onSubmitted;
  final void Function() exitMistakeMode;
  final void Function() unpause;
  
  final TextEditingController? controller;

  const BaseExamView({
    super.key,
    required this.test,
    required this.question,
    required this.questionNumber,
    required this.mistakeMode,
    required this.paused,
    required this.mode,
    required this.onSubmitted,
    required this.exitMistakeMode,
    required this.unpause,
    this.controller
  });

  @override
  State<BaseExamView> createState() => _BaseExamViewState();
}

class _BaseExamViewState extends State<BaseExamView> with ExamMixin {

  final FocusNode _focusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();

  void _exitMistakeMode(RawKeyEvent event) {
    if (widget.mistakeMode && event.isKeyPressed(LogicalKeyboardKey.enter)) {
      widget.controller?.text = '';
      widget.exitMistakeMode();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mistakeMode && !_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    else if (!widget.mistakeMode) {
      _answerFocusNode.requestFocus();
    }

    return Container(
      decoration: BoxDecoration(
        color: Constants.sakura,
        borderRadius: BorderRadius.circular(20)
      ),
      padding: const EdgeInsets.all(40),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.paused
        ? Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Constants.salmon),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow_rounded, color: Constants.salmon, size: 50),
                  onPressed: widget.unpause,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.replay, color: Constants.salmon,),
                onPressed: () => Navigator.of(context, rootNavigator: true).popAndPushNamed(
                  '/exams/${Constants.modeRouteName(widget.mode)}',
                  arguments: {'test': widget.test}
                ),
              )
            ]
          )
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.questionNumber}',
                  style: Theme.of(context).textTheme.displayMedium
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    widget.test.flipTerms ?
                      widget.question.answer : widget.question.question,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                )
              ]
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ScrollableImageDisplay(
                  images: widget.question.images?.map((e) => Pair<String, bool>(a: e, b: true)).toList() ?? [],
                ),
              )
            ),
            widget.mistakeMode
            ? Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Constants.salmon
              ),
              child: Text(
                widget.test.flipTerms ?
                  widget.question.question : widget.question.answer,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
              )
            ) : Container(),
            RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _exitMistakeMode,
              child: TextField(
                readOnly: widget.mistakeMode,
                controller: widget.controller,
                style: Theme.of(context).textTheme.bodySmall,
                focusNode: _answerFocusNode,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  isDense: true,
                  filled: true,
                  hintText: '答えを入力',
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7)
                  ),
                  // hoverColor: widget.mistakeMode ? Constants.yellow : _modeColors[widget.mode]?['dark'],
                  // fillColor: widget.mistakeMode ? Constants.yellow : _modeColors[widget.mode]?['dark'],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                ),
                onSubmitted: widget.onSubmitted
              ),
            ),
          ]
        ),
      )
    );
  }
}
