import 'package:flutter/material.dart';

import 'package:mytest/models/models.dart';

import 'test_listing.dart';
import 'new_test_listing_editor.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/app_state.dart';


class TestListingTree extends StatefulWidget {

  final Test selectedTest;

  final void Function(Test) onSelect;
  final void Function(Test) onDelete;

  const TestListingTree({
    super.key,
    required this.selectedTest,
    required this.onSelect,
    required this.onDelete
  });

  @override
  State<TestListingTree> createState() => _TestListingTreeState();
}

class _TestListingTreeState extends State<TestListingTree> {

  List<Test> _testsToDelete = [];

  bool _isAdding = false;
  bool _isEditing = false;

  /* ADD/UPDATE TEST ======================================================== */

  void _addTest(String name, int order) {
    Test test = Test(title: name, order: order);
    setState(() { AppState.allTests.add(test); });
  }

  void _reorderTest(int oldIndex, int newIndex) {
    Test test = AppState.getAllTests()[oldIndex];
    test.order = newIndex;
    AppState.allTests.removeAt(oldIndex);
    AppState.allTests.insert(newIndex - (oldIndex < newIndex ? 1 : 0), test);
  }

  void _deleteTest(int index) {
    _testsToDelete.add(AppState.getAllTests()[index]);
    setState(() { AppState.allTests.removeAt(index); });
  }

  /* INIT/BUILD ============================================================= */

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.all(20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Constants.sakura,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _isEditing
                  ? IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Constants.charcoal,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isAdding = true),
                  )
                  : Container(),
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: Constants.charcoal,
                    size: 18,
                  ),
                  onPressed:  () {
                    if (_isEditing) {
                      AppState.saveTests(_testsToDelete).then((success) {
                        _testsToDelete = [];
                        if (!success) { print("error"); }
                      });
                      setState(() => _isEditing = false);
                    } else { setState(() => _isEditing = true); }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  key: Key('$index'),
                  padding: EdgeInsets.fromLTRB(
                      0, index == 0 ? 10 : 0, 0, 0
                  ),
                  child: index < AppState.getAllTests().length
                    ? TestListing(
                      test: AppState.getAllTests()[index],
                      index: index,
                      isEditing: _isEditing,
                      isSelected: AppState.getAllTests()[index] == widget.selectedTest,
                      onSelect: () {
                        if (!_isAdding) {
                          widget.onSelect(AppState.getAllTests()[index]);
                        }
                      },
                      onDelete: () => _deleteTest(index),
                    )
                    : NewTestListingEditor(
                      key: Key('$index'),
                      createNewDocument: (name) => _addTest(name, index)
                    )
                );
              },
              itemCount: AppState.getAllTests().length + (_isAdding ? 1 : 0),
              shrinkWrap: true,
              onReorder: _reorderTest
            ),
          )
        ],
      ),
    );
  }
}
