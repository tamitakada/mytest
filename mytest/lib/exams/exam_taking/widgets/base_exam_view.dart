import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';


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

  static const Map<TestMode, Map<String, Color>> _modeColors = {
    TestMode.lives: {'dark': Constants.blue, 'light': Constants.lightBlue},
    TestMode.infinite: {'dark': Constants.green, 'light': Constants.lightGreen},
    TestMode.timed: {'dark': Constants.red, 'light': Constants.lightRed}
  };

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
        color: _modeColors[widget.mode]?['light'],
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
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50),
                  onPressed: widget.unpause,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.replay, color: Colors.white,),
                onPressed: () => Navigator.of(context).popAndPushNamed(
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
                    widget.question.question,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                )
              ]
            ),
            const SizedBox(height: 20),
            // TODO: Add photos
            Expanded(child: Container()),
            widget.mistakeMode
            ? Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Constants.lightRed
              ),
              child: Text(
                widget.question.answer,
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
                  hoverColor: widget.mistakeMode ? Constants.yellow : _modeColors[widget.mode]?['dark'],
                  fillColor: widget.mistakeMode ? Constants.yellow : _modeColors[widget.mode]?['dark'],
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