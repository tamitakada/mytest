import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';
import '../widgets/base_exam_view.dart';


class TimedExamPage extends StatefulWidget {

  const TimedExamPage({Key? key}) : super(key: key);

  @override
  State<TimedExamPage> createState() => _TimedExamPageState();
}

class _TimedExamPageState extends State<TimedExamPage> with ExamMixin {

  Test? test;

  List<Pair<Question, bool>> _questions = [];
  double _score = 1;

  bool _mistakeMode = false;
  bool _paused = false;

  double _timeLeft = 90;

  Timer? _timer;

  final TextEditingController _controller = TextEditingController();

  void _tick(Timer _) {
    if (_timeLeft - 0.2 <= 0) {
      _timer?.cancel();
      Navigator.of(context).pushNamed(
        '/exams/result',
        arguments: {'questions': _questions, 'mode': TestMode.infinite}
      );
    } else {
      setState(() { _timeLeft -= 0.2; });
    }
  }

  void _checkAnswer(String answer) {
    if (!_mistakeMode) {
      bool correct = isAnswerCorrect(_questions[_questions.length - 1].a, answer, test?.flipTerms ?? false, test?.allowError ?? false);
      _questions[_questions.length - 1].b = correct;
      _score = (_score * (_questions.length - 1) + (correct ? 1 : 0)) / _questions.length;
      if (correct) {
        _controller.text = '';
        setState(() {
          _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
        });
      }
      else { setState(() { _mistakeMode = true; }); }
    }
  }

  void _exitMistakeMode() {
    _controller.text = '';
    setState(() {
      _mistakeMode = false;
      _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() { _paused = true; });
  }

  void _unpause() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), _tick);
    setState(() { _paused = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      test = args['test'];
      _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
      _timer = Timer.periodic(const Duration(milliseconds: 200), _tick);
    }
    return Scaffold(
      backgroundColor: Constants.red,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAlias,
                    child: LinearProgressIndicator(
                      backgroundColor: Constants.lightRed,
                      color: Constants.yellow,
                      value: _timeLeft / 90,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 24),
                  onPressed: _pause,
                )
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
                mode: TestMode.timed,
                onSubmitted: _checkAnswer,
                exitMistakeMode: _exitMistakeMode,
                unpause: _unpause,
                controller: _controller,
              )
            )
          ]
        ),
      )
    );
  }
}
