import 'package:flutter/material.dart';

import 'package:mytest/widgets/mt_text_field.dart';
import 'package:mytest/widgets/mt_button.dart';

import 'package:mytest/constants.dart';


class ExamSettingsSubpage extends StatefulWidget {

  final void Function() onDelete;

  const ExamSettingsSubpage({ super.key, required this.onDelete });

  @override
  State<ExamSettingsSubpage> createState() => _ExamSettingsSubpageState();
}

class _ExamSettingsSubpageState extends State<ExamSettingsSubpage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      decoration: BoxDecoration(
        color: Constants.green,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          MTTextField(
            hintText: 'テスト名',
          ),
          MTButton(
            text: '削除',
            onTap: widget.onDelete
          )
        ]
      ),
    );
  }
}
