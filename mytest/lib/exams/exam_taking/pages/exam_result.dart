import 'package:flutter/material.dart';
import '../mixins/result_mixin.dart';
import 'package:mytest/models/question.dart';
import 'package:mytest/pair.dart';
import '../widgets/question_view.dart';
import 'package:mytest/constants.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({Key? key}) : super(key: key);

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> with ExamResultMixin {

  List<Pair<Question, bool>>? _questions;
  int? _score;

  void _initResults() {
    _score = getPercentageScore(_questions ?? []);
    saveResult(_questions ?? [], _questions!.first.a.test.value!);
  }

  @override
  Widget build(BuildContext context) {
    if (_score == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _questions = args['questions'];
      _initResults();
    }

    return Scaffold(
      backgroundColor: Constants.blue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView.builder(
          itemCount: (_questions?.length ?? 0) + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: Text(
                      '結果',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  Text(
                    "$_score点",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay, color: Colors.white, size: 20,),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/exams',
                              arguments: {'test': _questions?.first.a.test.value}
                            );
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 20,),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/');
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: Text('問題一覧', style: Theme.of(context).textTheme.bodyLarge),
                  )
                ],
              );
            } else {
              return QuestionView(
                question: (_questions ?? [])[index - 1].a,
                correct:  (_questions ?? [])[index - 1].b,
              );
            }
          },
        ),
      )
    );
  }
}
