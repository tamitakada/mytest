import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import '../widgets/question_list_tile.dart';

import 'package:mytest/abstract_classes/overlay_manager.dart';

import '../overlays/edit_problem_overlay.dart';
import '../mixins/exam_edit_mixin.dart';

import 'package:mytest/constants.dart';


class ExamProblemsPage extends StatefulWidget {

  const ExamProblemsPage({Key? key}) : super(key: key);

  @override
  State<ExamProblemsPage> createState() => _ExamProblemsPageState();
}

class _ExamProblemsPageState extends State<ExamProblemsPage> with TickerProviderStateMixin, ExamEditMixin implements OverlayManager  {

  List<Question> _filteredQuestions = [];

  bool _overlayHidden = true;
  bool _animateShadow = true;

  Question? _selectedQuestion;

  late AnimationController _shadowController;
  late Animation<double> _shadowAnimation;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  Widget? _overlayChild;

  @override
  void openOverlay() {
    if (_animateShadow) {
      _shadowController.reset();
      _shadowController.forward();
    } else { _animateShadow = true; }

    _slideController.forward();

    setState(() { _overlayHidden = false; });
  }

  @override
  void closeOverlay() {
    _shadowController.addListener(hideOverlay);
    _shadowController.reverse();
    _slideController.reverse();
  }

  void hideOverlay() {
    if (_shadowController.isDismissed) {
      setState(() { _overlayHidden = true; });
      _shadowController.removeListener(hideOverlay);
    }
  }

  @override
  void updateOverlay(Widget? child) {
    _overlayChild = child;
  }

  @override
  bool isOverlayOpen() => _overlayChild != null;

  @override
  void initState() {
    _shadowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200)
    );
    _shadowAnimation = Tween<double>(begin: 0, end: 0.5)
        .animate(_shadowController);

    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200)
    );
    _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1), end: const Offset(0, 0)
    ).animate(_slideController);

    super.initState();
  }

  @override
  void dispose() {
    _shadowController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Test? _test;
  String? _query;

  @override
  Widget build(BuildContext context) {
    if (_test == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _test = args['test'];
      _filteredQuestions = _test?.questions.toList() ?? [];
    }

    return Scaffold(
      backgroundColor: Constants.blue,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    "問題集",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MTTextField(
                        hintText: "問題を検索する",
                        onSubmitted: (query) {
                          setState(() {
                            _query = query;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() { _selectedQuestion = null; });
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          openOverlay();
                        });
                      },
                      icon: Icon(Icons.add)
                    )
                  ]
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (_query == null
                          || _filteredQuestions[index].question.toLowerCase().contains(_query!.toLowerCase())
                          || _filteredQuestions[index].answer.toLowerCase().contains(_query!.toLowerCase())
                      ) {
                        return QuestionListTile(
                          question: _filteredQuestions[index],
                          onTap: () {
                            setState(() {
                              _selectedQuestion = _filteredQuestions[index];
                            });
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              openOverlay();
                            });
                          },
                        );
                      }
                      return Container();
                    },
                  )
                )
              ],
            ),
          ),
          !_overlayHidden ? Stack(
            children: [
              AnimatedBuilder(
                animation: _shadowAnimation,
                builder: (BuildContext context, Widget? child) {
                  return GestureDetector(
                    onTap: closeOverlay,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(_shadowAnimation.value),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
                    widthFactor: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Constants.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: closeOverlay,
                          ),
                          Expanded(
                            child: EditProblemOverlay(
                              test: _test!,
                              question: _selectedQuestion,
                              closeOverlay: (success) => closeOverlay(),
                            )
                          )
                        ]
                      ),
                    ),
                  )
                ),
              )
            ],
          ) : Container(),
        ]
      )
    );
  }
}
