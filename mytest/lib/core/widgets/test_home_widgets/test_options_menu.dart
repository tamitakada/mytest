import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';

import 'package:mytest/models/test.dart';

import 'package:mytest/widgets/mt_button.dart';


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
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Constants.white
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: TestMode.values.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    0, 0, index < TestMode.values.length - 1 ? 10 : 0, 0
                  ),
                  child: MTButton(
                    onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                      '/exams/${Constants.modeRouteName(TestMode.values[index])}',
                      arguments: {'test': test}
                    ),
                    text: Constants.modeName(TestMode.values[index]),
                    enabled: test.questions.isNotEmpty,
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
