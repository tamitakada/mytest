import 'package:flutter/material.dart';

import 'package:mytest/models/test.dart';

import 'package:mytest/constants.dart';


class TestListTile extends StatelessWidget {
  
  final Test test;
  final void Function() onTap;
  
  const TestListTile({ super.key, required this.test, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          color: Constants.lightBlue,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                test.title,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            )
          ],
        )
      ),
    );
  }
}
