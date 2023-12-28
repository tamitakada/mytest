import 'package:flutter/material.dart';

import 'package:mytest/models/test.dart';
import 'package:mytest/constants.dart';
import '../animated_editor_view.dart';
import 'package:mytest/widgets/shakeable_view.dart';


class TestListing extends StatefulWidget {

  final String testTitle;
  final int index;
  final bool isSelected;
  final bool isEditing;
  final void Function() onSelect;
  final void Function(String) onEdit;
  final void Function() onDelete;

  const TestListing({
    super.key,
    required this.index,
    required this.testTitle,
    required this.isSelected,
    required this.isEditing,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete
  });

  @override
  State<TestListing> createState() => _TestListingState();
}

class _TestListingState extends State<TestListing> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _hadFocus = false;
  bool _showInvalidAnimation = false;

  void _validateTitle() {
    if (_controller.text.trim().isEmpty) { // Only accept non-empty name
      _focusNode.requestFocus();
      setState(() => _showInvalidAnimation = true);
    }
    else {
      _hadFocus = false;
      _focusNode.unfocus();
      widget.onEdit(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller.text = widget.testTitle;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) { _hadFocus = true; }
      else if (_hadFocus) { _validateTitle(); }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showAnimation = false;
    if (_showInvalidAnimation) {
      showAnimation = true;
      _showInvalidAnimation = false;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedEditorView(
        index: widget.index,
        isEditing: widget.isEditing,
        onDelete: widget.onDelete,
        child: GestureDetector(
          onTap: widget.onSelect,
          child: ShakeableView(
            animated: showAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              decoration: BoxDecoration(
                border: Border.all(color: Constants.salmon, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: widget.isSelected ? Constants.salmon : Constants.sakura
              ),
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.isSelected ? Constants.white : Constants.salmon
                ),
                decoration: null,
                maxLines: null,
                minLines: null,
                enabled: widget.isEditing,
                onChanged: widget.onEdit,
              ),
            ),
          ),
        )
      ),
    );
  }
}
