import 'package:flutter/material.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';
import '../widgets/base_exam_view.dart';


class FullExamPage extends StatefulWidget {

  const FullExamPage({Key? key}) : super(key: key);

  @override
  State<FullExamPage> createState() => _FullExamPageState();
}

class _FullExamPageState extends State<FullExamPage> with ExamMixin {

  Test? test;

  List<Question> _remainingQuestions = [];
  List<Pair<Question, bool>> _questions = [];
  double _score = 1;

  bool _mistakeMode = false;
  bool _paused = false;

  final TextEditingController _controller = TextEditingController();

  void _goToResults() {
    Navigator.of(context).pushNamed(
      '/exams/result',
      arguments: {'questions': _questions, 'mode': TestMode.infinite}
    );
  }

  void _checkAnswer(String answer) {
    if (!_mistakeMode) {
      bool correct = isAnswerCorrect(_questions[_questions.length - 1].a, answer);
      _questions[_questions.length - 1].b = correct;
      _score = (_score * (_questions.length - 1) + (correct ? 1 : 0)) / _questions.length;
      if (correct) {
        if (_remainingQuestions.isEmpty) { _goToResults(); }
        else {
          _controller.text = '';
          setState(() {
            _questions.add(
              Pair<Question, bool>(
                a: generateRandomQuestionNR(_remainingQuestions),
                b: false
              )
            );
          });
        }
      }
      else { setState(() { _mistakeMode = true; }); }
    }
  }

  void _exitMistakeMode() {
    if (_remainingQuestions.isEmpty) { _goToResults(); }
    else {
      _controller.text = '';
      setState(() {
        _mistakeMode = false;
        _questions.add(
          Pair<Question, bool>(
            a: generateRandomQuestionNR(_remainingQuestions),
            b: false
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      test = args['test'];
      _remainingQuestions = test!.questions.toList();
      _questions.add(
        Pair<Question, bool>(
          a: generateRandomQuestionNR(_remainingQuestions),
          b: false
        )
      );
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
                              value: (test!.questions.length - _remainingQuestions.length) / test!.questions.length,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${(_score * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodyMedium
                          )
                        ]
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause, color: Colors.white, size: 24),
                        onPressed: () => setState(() { _paused = true; }),
                      ),
                    ]
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: BaseExamView(
                    test: test!,
                    question: _questions.last.a,
                    questionNumber: _questions.length,
                    mistakeMode: _mistakeMode,
                    paused: _paused,
                    mode: TestMode.infinite,
                    onSubmitted: _checkAnswer,
                    exitMistakeMode: _exitMistakeMode,
                    unpause: () => setState(() { _paused = false; }),
                    controller: _controller,
                  )
                )
              ]
          ),
        )
    );
  }
}
