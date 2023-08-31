import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';


class LivesExamPage extends StatefulWidget {

  const LivesExamPage({Key? key}) : super(key: key);

  @override
  State<LivesExamPage> createState() => _LivesExamPageState();
}

class _LivesExamPageState extends State<LivesExamPage> with ExamMixin {

  final FocusNode _focusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  Test? test;

  List<Pair<Question, bool>> _questions = [];
  int _lives = 3;

  bool _mistakeMode = false;
  bool _paused = false;

  void _checkAnswer(String answer) {
    if (!_mistakeMode) {
      bool correct = isAnswerCorrect(_questions[_questions.length - 1].a, answer);
      _questions[_questions.length - 1].b = correct;
      if (correct) {
        _textEditingController.text = '';
        setState(() {
          _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
          _answerFocusNode.requestFocus();
        });
      } else {
        setState(() {
          _lives--;
          _mistakeMode = true;
        });
      }
    }
  }

  void _exitMistakeMode(RawKeyEvent event) {
    if (_mistakeMode && event.isKeyPressed(LogicalKeyboardKey.enter)) {
      if (_lives == 0) {
        Navigator.of(context).pushNamed(
            '/exams/result',
            arguments: {'questions': _questions, 'mode': TestMode.infinite}
        );
      } else {
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
  }

  void _pauseExam() {
    setState(() { _paused = true; });
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
      backgroundColor: Constants.blue,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite, color: _lives > 0 ? Constants.yellow : Colors.white.withOpacity(0.5),
                      size: 24,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.favorite, color: _lives > 1 ? Constants.yellow : Colors.white.withOpacity(0.5),
                      size: 24
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.favorite, color: _lives > 2 ? Constants.yellow : Colors.white.withOpacity(0.5),
                      size: 24
                    )
                  ]
                ),
                IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 24),
                  onPressed: _pauseExam,
                )
              ]
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.lightBlue,
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
                          onPressed: () => Navigator.of(context).popAndPushNamed('/exams', arguments: {'test': test}),
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
                            hoverColor: _mistakeMode ? Constants.yellow : Constants.blue,
                            fillColor: _mistakeMode ? Constants.yellow : Constants.blue,
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
