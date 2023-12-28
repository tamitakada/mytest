import 'package:flutter/material.dart';

import 'package:mytest/models/test.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/spaced_group.dart';


class PausedTestView extends StatelessWidget {

  final Test test;
  final TestMode mode;
  final void Function() unpause;

  const PausedTestView({
    super.key, required this.test, required this.mode, required this.unpause
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpacedGroup(
        axis: Axis.horizontal,
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Constants.salmon),
            onPressed: () => Navigator.of(context, rootNavigator: true).popUntil(
              ModalRoute.withName("/")
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Constants.salmon, size: 50),
            onPressed: unpause,
          ),
          IconButton(
            icon: const Icon(Icons.replay, color: Constants.salmon,),
            onPressed: () => Navigator.of(context, rootNavigator: true).popAndPushNamed(
              '/exams/${Constants.modeRouteName(mode)}',
              arguments: {'test': test}
            ),
          )
        ]
      )
    );
  }
}
