import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';
import '../animated_editor_view.dart';


class TestListing extends StatelessWidget {

  final String testTitle;
  final int index;
  final bool isSelected;
  final bool isEditing;
  final void Function() onSelect;

  const TestListing({
    super.key,
    required this.index,
    required this.testTitle,
    required this.isSelected,
    required this.isEditing,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onSelect,
        child: AnimatedEditorView(
          index: index,
          isEditing: isEditing,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Constants.salmon, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Constants.salmon : Constants.sakura
            ),
            child: Text(
              testTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Constants.white : Constants.salmon
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ),
      ),
    );
  }
}
