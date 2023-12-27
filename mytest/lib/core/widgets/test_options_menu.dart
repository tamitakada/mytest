import 'package:flutter/material.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/mt_button.dart';
import 'package:mytest/widgets/spaced_group.dart';
import 'package:mytest/models/test.dart';

class TestOptionsMenu extends StatelessWidget {

  final Test test;

  const TestOptionsMenu({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.salmon,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "勉強する",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SpacedGroup(
            axis: Axis.horizontal,
            spacing: 10,
            children: [
              MTButton(
                onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                  '/exams/full', arguments: {'test': test}
                ),
                text: "全問テスト"
              ),
              MTButton(
                onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                  '/exams/infinite', arguments: {'test': test}
                ),
                text: "無限練習"
              ),
              MTButton(
                onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                  '/exams/lives', arguments: {'test': test}
                ),
                text: "３アウト"
              ),
              MTButton(
                onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                  '/exams/timed', arguments: {'test': test}
                ),
                text: "タイムアタック"
              )
            ],
          )
        ],
      ),
    );
  }
}
