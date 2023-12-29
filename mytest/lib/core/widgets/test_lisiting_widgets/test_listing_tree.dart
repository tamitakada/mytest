import 'package:flutter/material.dart';

import 'package:mytest/models/models.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'test_listing.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/app_state.dart';


class TestListingTree extends StatefulWidget {

  const TestListingTree({super.key});

  @override
  State<TestListingTree> createState() => _TestListingTreeState();
}

class _TestListingTreeState extends State<TestListingTree> with AlertMixin {

  List<Test> _testsToDelete = [];

  int _selectedTestIndex = -1;
  bool _isEditing = false;

  /* ADD/UPDATE TEST ======================================================== */

  void _addTest(BuildContext context) {
    Test test = Test(title: "無題", order: AppState.getAllTests().length);
    AppState.addTest(test).then((success) {
      if (success) { setState((){}); }
      else { showErrorDialog(context, ErrorType.save); }
    });
  }

  void _editTestName(String name, int index) {
    AppState.allTests[index].title = name;
  }

  void _reorderTest(int oldIndex, int newIndex) {
    Test test = AppState.allTests[oldIndex];
    int trueIndex = newIndex - (oldIndex < newIndex ? 1 : 0);
    setState(() {
      AppState.allTests.removeAt(oldIndex);
      AppState.allTests.insert(trueIndex, test);

      if (oldIndex < _selectedTestIndex && newIndex >= _selectedTestIndex) {
        _selectedTestIndex--;
      }
      else if (oldIndex > _selectedTestIndex && newIndex <= _selectedTestIndex) {
        _selectedTestIndex++;
      }
      else if (oldIndex == _selectedTestIndex) {
        _selectedTestIndex = trueIndex;
      }
    });
  }

  void _deleteTest(int index) {
    _testsToDelete.add(AppState.allTests[index]);
    if (index == _selectedTestIndex) {
      // If deleting selected test, change selection
      AppState.selectedTest.value = index > 0 ? AppState.allTests[index - 1] : null;
      setState(() => _selectedTestIndex = index - 1);
    }
    setState(() {
      AppState.allTests.removeAt(index);
      if (index < _selectedTestIndex) {
        _selectedTestIndex--;
      }
    });
  }

  void _validateTests(BuildContext context) {
    AppState.saveTests(_testsToDelete).then((success) {
      _testsToDelete = [];
      if (!success) { showErrorDialog(context, ErrorType.save); }
    });
    setState(() => _isEditing = false);
  }

  /* INIT/BUILD ============================================================= */

  @override
  void initState() {
    _selectedTestIndex = AppState.selectedTest.value?.order ?? -1;
    super.initState();
  }

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
                    onPressed: () => _addTest(context),
                  )
                  : Container(),
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: Constants.charcoal,
                    size: 18,
                  ),
                  onPressed:  () {
                    if (_isEditing) { _validateTests(context); }
                    else { setState(() => _isEditing = true); }
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
                  padding: EdgeInsets.fromLTRB(0, index == 0 ? 10 : 0, 0, 0),
                  child: TestListing(
                    key: UniqueKey(),
                    testTitle: AppState.allTests[index].title,
                    index: index,
                    isEditing: _isEditing,
                    isSelected: index == _selectedTestIndex,
                    onSelect: () {
                      if (!_isEditing) {
                        AppState.selectedTest.value = AppState.allTests[index];
                        setState(() => _selectedTestIndex = index);
                      }
                    },
                    onEdit: (name) => _editTestName(name, index),
                    onDelete: () => _deleteTest(index),
                  )
                );
              },
              itemCount: AppState.allTests.length,
              shrinkWrap: true,
              onReorder: _reorderTest
            ),
          )
        ],
      ),
    );
  }
}
