import 'package:flutter/material.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import '../widgets/question_list_tile.dart';

import 'package:mytest/constants.dart';


class ExamProblemsSubpage extends StatefulWidget {

  final void Function(Question? question) editProblem;

  const ExamProblemsSubpage({ super.key, required this.editProblem });

  @override
  State<ExamProblemsSubpage> createState() => _ExamProblemsSubpageState();
}

class _ExamProblemsSubpageState extends State<ExamProblemsSubpage>  {

  Test? _test;
  String? _query;

  @override
  Widget build(BuildContext context) {
    if (_test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _test = args['test'];
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: Constants.lightBlue,
        borderRadius: BorderRadius.circular(10)
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MTTextField(
                  hintText: "問題を検索する",
                  onChanged: (query) => setState(() { _query = query; }),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => widget.editProblem(null),
                icon: const Icon(Icons.add, color: Colors.white)
              ),
            ]
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _test!.questions.length,
              itemBuilder: (BuildContext context, int index) {
                if (_query == null
                    || _test!.questions.elementAt(index).question.toLowerCase().contains(_query!.toLowerCase())
                    || _test!.questions.elementAt(index).answer.toLowerCase().contains(_query!.toLowerCase())
                ) {
                  return QuestionListTile(
                    question: _test!.questions.elementAt(index),
                    onTap: () => widget.editProblem(_test!.questions.elementAt(index)),
                    onDismissed: () {
                      DataManager.deleteQuestion(_test!.questions.elementAt(index)).then(
                        (success) {
                          if (success) {
                            _test!.questions.load().then(
                              (_) => setState((){})
                            );
                          }
                        }
                      );
                    },
                  );
                }
                return Container();
              },
            )
          )
        ],
      ),
    );
  }
}