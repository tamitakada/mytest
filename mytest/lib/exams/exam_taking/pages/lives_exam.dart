import 'package:flutter/material.dart';

import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';

import 'package:mytest/models/models.dart';
import '../mixins/exam_mixin.dart';

import '../widgets/base_exam_view.dart';


class LivesExamPage extends StatefulWidget {

  const LivesExamPage({Key? key}) : super(key: key);

  @override
  State<LivesExamPage> createState() => _LivesExamPageState();
}

class _LivesExamPageState extends State<LivesExamPage> with ExamMixin {

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
        setState(() {
          _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
        });
      } else {
        setState(() {
          _lives--;
          _mistakeMode = true;
        });
      }
    }
  }

  void _exitMistakeMode() {
    if (_lives == 0) {
      Navigator.of(context).pushNamed(
        '/exams/result',
        arguments: {'questions': _questions, 'mode': TestMode.infinite}
      );
    } else {
      setState(() {
        _mistakeMode = false;
        _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      test = args['test'];
      _questions.add(Pair<Question, bool>(a: generateRandomQuestion(test!), b: false));
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
                  onPressed: () => setState(() { _paused = true; }),
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
                mode: TestMode.lives,
                onSubmitted: _checkAnswer,
                exitMistakeMode: _exitMistakeMode,
                unpause: () => setState(() { _paused = false; }),
              )
            )
          ]
        ),
      )
    );
  }
}
