import 'package:flutter/material.dart';

import 'package:mytest/models/test.dart';
import 'package:mytest/constants.dart';
import 'animated_editor_view.dart';


class TestListing extends StatelessWidget {

  final Test test;
  final int index;
  final bool isSelected;
  final bool isEditing;
  final void Function() onSelect;
  final void Function() onDelete;

  const TestListing({
    super.key,
    required this.test,
    required this.index,
    required this.isSelected,
    required this.isEditing,
    required this.onSelect,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedEditorView(
        index: index,
        isEditing: isEditing,
        onDelete: onDelete,
        child: GestureDetector(
          onTap: onSelect,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.salmon, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Constants.salmon : Constants.sakura
            ),
            child: Text(
              test.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Constants.white : Constants.salmon
              ),
            ),
          ),
        )
      ),
    );
  }
}
