import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/abstract_classes/overlay_manager.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/utils/data_manager.dart';

import '../widgets/tab_button.dart';
import '../widgets/problems_subpage.dart';
import '../widgets/settings_subpage.dart';

import '../overlays/edit_problem_overlay.dart';
import 'package:mytest/widgets/mt_button.dart';


enum ExamMakingPage {
  problems,
  settings,
  stats
}

class ExamHomePage extends StatefulWidget {

  const ExamHomePage({ super.key });

  @override
  State<ExamHomePage> createState() => _ExamHomePageState();
}

class _ExamHomePageState extends State<ExamHomePage> with TickerProviderStateMixin implements OverlayManager {

  bool _overlayHidden = true;
  bool _animateShadow = true;

  late AnimationController _shadowController;
  late Animation<double> _shadowAnimation;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  ExamMakingPage _page = ExamMakingPage.problems;

  Question? _selectedQuestion;

  Widget? _overlayChild;
  Test? test;

  void _setExamMakingPage(ExamMakingPage page) {
    if (_page != page) {
      setState(() { _page = page; });
    }
  }

  void _openProblemEditOverlay(Question? question) {
    setState(() {
      _selectedQuestion = question;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      openOverlay();
    });
  }

  void _deleteTest() {
    DataManager.deleteTest(test!).then((success) {
      if (success) {
        Navigator.of(context).pop();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    test = args['test'];

    return Scaffold(
      backgroundColor: Constants.blue,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      test?.title ?? "",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                  child: MTButton(
                    onTap: () => Navigator.of(context).pushNamed('/exams', arguments: {'test': test}),
                    text: 'テスト開始',
                    style:  Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Row(
                  children: [
                    TabButton(
                      text: '問題集',
                      color: Constants.lightBlue,
                      onTap: () => _setExamMakingPage(ExamMakingPage.problems),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TabButton(
                        text: '設定',
                        color: Constants.green,
                        onTap: () => _setExamMakingPage(ExamMakingPage.settings),
                      ),
                    ),
                    TabButton(
                      text: '記録',
                      color: Constants.yellow,
                      onTap: () => _setExamMakingPage(ExamMakingPage.stats),
                    )
                  ]
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _page == ExamMakingPage.problems
                    ? ExamProblemsSubpage(editProblem: _openProblemEditOverlay)
                    : _page == ExamMakingPage.settings
                    ? ExamSettingsSubpage(onDelete: _deleteTest) : Container()
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
                      child: _page == ExamMakingPage.problems
                        ? EditProblemOverlay(
                          test: test!,
                          question: _selectedQuestion,
                          closeOverlay: (success) => closeOverlay(),
                        )
                        : Container(),
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