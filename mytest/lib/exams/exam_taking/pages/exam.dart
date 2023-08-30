import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';

import 'package:mytest/widgets/mt_text_field.dart';

import 'package:mytest/pair.dart';
import 'dart:async';

import 'package:mytest/constants.dart';


class ExamPage extends StatefulWidget {

  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with ExamMixin {

  final FocusNode _focusNode = FocusNode();
  final FocusNode _answerFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  Test? test;

  List<Pair<Question, bool>> _questions = [];
  int _lives = 3;

  bool _mistakeMode = false;

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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${_questions.length}',
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _questions[_questions.length - 1].a.question,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                        ),
                      )
                    ),
                    RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: (event) {
                        if (_mistakeMode && event.isKeyPressed(LogicalKeyboardKey.enter)) {
                          if (_lives == 0) {
                            Navigator.of(context).pushNamed(
                              '/exams/result',
                              arguments: {'questions': _questions}
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
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _mistakeMode ? Icons.close : Icons.edit,
                                color: _mistakeMode ? Constants.yellow : Colors.white,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  readOnly: _mistakeMode,
                                  controller: _textEditingController,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  focusNode: _answerFocusNode,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _mistakeMode ? Constants.yellow : Colors.white,
                                        width: 2
                                      )
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _mistakeMode ? Constants.yellow : Colors.white,
                                        width: 2
                                      )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _mistakeMode ? Constants.yellow : Colors.white,
                                        width: 2
                                      )
                                    )
                                  ),
                                  onSubmitted: _checkAnswer
                                ),
                              )
                            ]
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _mistakeMode ? const Icon(
                                Icons.circle_outlined,
                                color: Constants.green,
                              ) : Container(),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _mistakeMode
                                  ? Text(
                                    _questions.last.a.answer,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Constants.green
                                    ),
                                  )
                                  : Container()
                              ),
                            ],
                          ),
                        ]
                      )
                    )
                  ]
                ),
              ),
            ),
            Column(
              children: [
                Icon(
                  Icons.favorite, color: _lives > 0 ? Constants.green : Colors.white.withOpacity(0.5),
                  size: 30,
                ),
                const SizedBox(height: 5),
                Icon(
                  Icons.favorite, color: _lives > 1 ? Constants.yellow : Colors.white.withOpacity(0.5),
                  size: 30
                ),
                const SizedBox(height: 5),
                Icon(
                  Icons.favorite, color: _lives > 2 ? Constants.yellow : Colors.white.withOpacity(0.5),
                  size: 30
                )
              ]
            ),
          ]
        ),
      )
    );
  }
}
