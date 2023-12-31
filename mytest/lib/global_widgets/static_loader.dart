import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingSpinner extends AnimatedWidget {

  const LoadingSpinner({
    super.key,
    required AnimationController controller,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  // _progress.value <= 0.5 ? (_progress.value * 0.4 + 0.8) : (1 - _progress.value * 0.4)

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Transform.rotate(
            angle: 0,//_progress.value * pi / 2,
            child: Transform.scale(
              scale: 0.8 + 0.4 * (0.5 - _progress.value).abs(),
              child: Container(
                width: 40, height: 40,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/mytest_m.svg',
                    width: 12, height: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Center(
        //   child: SvgPicture.asset(
        //     'assets/images/mytest_m.svg',
        //     width: 12, height: 12,
        //   ),
        // )
      ],
    );
  }
}


class StaticLoader extends StatefulWidget {
  const StaticLoader({Key? key}) : super(key: key);

  @override
  State<StaticLoader> createState() => _StaticLoaderState();
}

class _StaticLoaderState extends State<StaticLoader> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this, duration: const Duration(seconds: 2)
    )..repeat();
    super.initState();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: LoadingSpinner(controller: _controller,)
      ),
    );
  }
}
