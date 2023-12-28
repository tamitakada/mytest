import 'package:flutter/material.dart';
import '../mixins/result_mixin.dart';
import 'package:mytest/models/question.dart';
import 'package:mytest/pair.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/spaced_group.dart';

class TestResultPage extends StatefulWidget {

  const TestResultPage({Key? key}) : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> with ExamResultMixin {

  TestMode? _mode;
  List<Pair<Question, bool>>? _questions;

  int _correct = 0;
  int? _score;

  void _initResults() {
    for (var pair in _questions!) {
      _correct += pair.b ? 1 : 0;
    }
    _score = getPercentageScore(_questions ?? []);
    saveResult(_questions ?? [], _questions!.first.a.test.value!, _mode ?? TestMode.lives);
  }

  Widget _buildLargeScore() {
    return _mode == TestMode.full
      ? Column(
        children: [
          Text(
            "$_correct",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Constants.sakura
            ),
          ),
          Container(
            width: 50,
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Constants.sakura
            ),
          ),
          Text(
            "${_questions?.length ?? 0}",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Constants.charcoal
            ),
          ),
        ],
      )
      : Text(
        "${_questions?.length ?? 0}問突破",
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: Constants.charcoal
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_score == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _questions = args['questions'];
      _mode = args['mode'];
      _initResults();
    }

    return Scaffold(
     backgroundColor: Constants.salmon,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SpacedGroup(
          axis: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Text(
              '結果',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Constants.sakura
              ),
            ),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.sakura
              ),
              child: Center(
                child: SpacedGroup(
                  axis: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    _buildLargeScore(),
                    Text(
                      "正解率 $_score%",
                      style: Theme.of(context).textTheme.bodyLarge
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.replay, color: Constants.white, size: 20,),
                    onPressed: () => Navigator.of(context).popAndPushNamed(
                      '/exams/${Constants.modeRouteName(_mode!)}',
                      arguments: {'test': _questions?.first.a.test.value}
                    )
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Constants.white, size: 20,),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}
