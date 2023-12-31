import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mytest/models/test.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/global_widgets/scale_button.dart';
import 'package:mytest/global_widgets/spaced_group.dart';


class PausedTestView extends StatelessWidget with AlertMixin {

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
        spacing: 30,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleButton(
            onTap: () => showConfirmationDialog(
              context: context,
              title: "前の画面に戻りますか？",
              description: "このテストは記録されません。",
              confirmText: "戻る",
              onConfirm: () => Navigator.of(context, rootNavigator: true)
                .popUntil(ModalRoute.withName('/'))
            ),
            child: SvgPicture.asset(
              'assets/images/exit.svg',
              height: 20,
            ),
          ),
          ScaleButton(
            onTap: unpause,
            child: SvgPicture.asset(
              'assets/images/play.svg',
              height: 30,
            ),
          ),
          ScaleButton(
            onTap: () => showConfirmationDialog(
              context: context,
              title: "テストをやり直しますか？",
              description: "このテストは記録されません。",
              confirmText: "やり直す",
              onConfirm: () => Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed(
                  '/exams/${Constants.modeRouteName(mode)}',
                  arguments: {'test': test}
                )
            ),
            child: SvgPicture.asset(
              'assets/images/repeat.svg',
              height: 20,
            ),
          )
        ]
      )
    );
  }
}
