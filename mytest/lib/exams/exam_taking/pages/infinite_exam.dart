import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';


class InfiniteExamPage extends StatefulWidget {

  const InfiniteExamPage({Key? key}) : super(key: key);

  @override
  State<InfiniteExamPage> createState() => _InfiniteExamPageState();
}

class _InfiniteExamPageState extends State<InfiniteExamPage> with ExamMixin {

  final FocusNode _focusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  Test? test;

  List<Pair<Question, bool>> _questions = [];
  double _score = 1;

  bool _mistakeMode = false;
  bool _paused = false;

  void _checkAnswer(String answer) {
    if (!_mistakeMode) {
      bool correct = isAnswerCorrect(_questions[_questions.length - 1].a, answer);
      _questions[_questions.length - 1].b = correct;
      _score = (_score * (_questions.length - 1) + (correct ? 1 : 0)) / _questions.length;
      if (correct) {
        _textEditingController.text = '';
        setState(() {
          _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
          _answerFocusNode.requestFocus();
        });
      }
      else { setState(() { _mistakeMode = true; }); }
    }
  }

  void _exitMistakeMode(RawKeyEvent event) {
    if (_mistakeMode && event.isKeyPressed(LogicalKeyboardKey.enter)) {
      _textEditingController.text = '';
      setState(() {
        _mistakeMode = false;
        _questions.add(
          Pair<Question, bool>(
            a: generateRandomQuestion(test!),
            b: false
          )
        );
        _answerFocusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      test = args['test'];
      _questions.add(
        Pair<Question, bool>(
          a: generateRandomQuestion(test!),
          b: false
        )
      );
    }

    if (_mistakeMode && !_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    return Scaffold(
      backgroundColor: Constants.green,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 200,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LinearProgressIndicator(
                        backgroundColor: Constants.lightGreen,
                        color: Constants.yellow,
                        value: _score,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '${(_score * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium
                    )
                  ]
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white, size: 24),
                      onPressed: () => setState(() { _paused = true; }),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pushNamed(
                        '/exams/result',
                        arguments: {'questions': _questions, 'mode': TestMode.infinite}
                      ),
                    ),
                  ],
                )
              ]
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.lightGreen,
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:  _paused
                  ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 50
                            ),
                            onPressed: () => setState(() { _paused = false; }),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.replay,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).popAndPushNamed(
                            '/exams/infinite', arguments: {'test': test}
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
                            '${_questions.length}',
                            style: Theme.of(context).textTheme.displayMedium
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Text(
                              _questions[_questions.length - 1].a.question,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyMedium
                            )
                          )
                        ]
                      ),
                      const SizedBox(height: 20),
                      // TODO: Add photos
                      Expanded(
                        child: Container()
                      ),
                      _mistakeMode
                      ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Constants.lightGreen
                        ),
                        child: Text(
                          _questions.last.a.answer,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white
                          ),
                        )
                      ) : Container(),
                      RawKeyboardListener(
                        focusNode: _focusNode,
                        onKey: _exitMistakeMode,
                        child: TextField(
                          readOnly: _mistakeMode,
                          controller: _textEditingController,
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
                            hoverColor: _mistakeMode ? Constants.yellow : Constants.green,
                            fillColor: _mistakeMode ? Constants.yellow : Constants.green,
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
                          onSubmitted: _checkAnswer
                        ),
                      ),
                    ]
                  ),
                )
              )
            )
          ]
        ),
      )
    );
  }
}
