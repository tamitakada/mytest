import 'package:flutter/material.dart';

import 'package:mytest/constants.dart';


class NewTestListingEditor extends StatefulWidget {

  final void Function(String) createNewDocument;

  const NewTestListingEditor({ super.key, required this.createNewDocument });

  @override
  State<NewTestListingEditor> createState() => _NewTestListingEditorState();
}

class _NewTestListingEditorState extends State<NewTestListingEditor> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _validateName() {
    String name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.createNewDocument(name);
    }
    else {
      print("ERROR! TRY AGAIN.");
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) { _validateName(); }
    });
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Constants.salmon, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Constants.sakura
        ),
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
          decoration: const InputDecoration(
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.all(5)
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Constants.salmon
          ),
        ),
      ),
    );
  }
}
