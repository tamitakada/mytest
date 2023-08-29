import 'package:flutter/material.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/abstract_classes/overlay_manager.dart';

import 'package:mytest/constants.dart';

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

  Widget? _overlayChild;
  Test? test;

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
      appBar: AppBar(automaticallyImplyLeading: true),
      backgroundColor: Constants.blue,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text(test?.title ?? ""),
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/exams', arguments: {'test': test}),
                  icon: const Icon(
                    Icons.play_circle_filled_rounded,
                    color: Constants.lightBlue,
                    size: 120,
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.list_rounded),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/exams/problems',
                          arguments: {
                            'test': test
                          }
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        _page = ExamMakingPage.settings;
                        openOverlay();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.bar_chart_rounded),
                      onPressed: () {
                        _page = ExamMakingPage.stats;
                        openOverlay();
                      },
                    )
                  ]
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
                        color: Colors.white,
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
                            child: Container()
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