import 'package:flutter/material.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/abstract_classes/overlay_manager.dart';

import '../widgets/widgets.dart';

import 'package:mytest/constants.dart';


class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin implements OverlayManager  {

  bool _overlayHidden = true;
  bool _animateShadow = true;

  Test? _testToNavigate;

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

  @override
  Widget build(BuildContext context) {
    if (_testToNavigate != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Test testToNavigate = _testToNavigate!;
        _testToNavigate = null;
        Navigator.of(context).pushNamed(
          '/exams/home',
          arguments: {'test': testToNavigate}
        ).then((_) => setState(() {}));
      });
    }

    return Scaffold(
      backgroundColor: Constants.blue,
      body: Stack(
        children: [
          Center(
            child: HomePageContent(manager: this)
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
                              child: NewTestOverlay(
                                closeOverlay: (Test test) {
                                  print(test);
                                  _testToNavigate = test;
                                  closeOverlay();
                                },
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
