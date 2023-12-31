import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:mytest/models/models.dart';
import 'package:mytest/models/editing_test.dart';

import 'package:mytest/global_mixins/alert_mixin.dart';

import 'package:mytest/global_widgets/spaced_group.dart';
import 'package:mytest/global_widgets/scale_button.dart';
import 'test_listing.dart';

import 'package:mytest/constants.dart';
import 'package:mytest/app_state.dart';


class TestListingTree extends StatefulWidget {

  const TestListingTree({super.key});

  @override
  State<TestListingTree> createState() => _TestListingTreeState();
}

class _TestListingTreeState extends State<TestListingTree> with AlertMixin {

  late List<EditingTest> _editingTests;

  int _selectedTestIndex = -1;

  /* CREATE NEW TEST ======================================================== */

  void _addTest(BuildContext context, String title) {
    Test test = Test(title: title, order: AppState.getAllTests().length);
    AppState.addTest(test).then((success) {
      if (success) { setState(() {}); }
      else { showErrorDialog(context, ErrorType.save); }
    });
  }

  /* REORDER TEST =========================================================== */

  void _reorderTest(int oldIndex, int newIndex) {
    EditingTest test = _editingTests[oldIndex];
    int trueIndex = newIndex - (oldIndex < newIndex ? 1 : 0);
    setState(() {
      _editingTests.removeAt(oldIndex);
      _editingTests.insert(trueIndex, test);
      if (oldIndex < _selectedTestIndex && trueIndex >= _selectedTestIndex) {
        _selectedTestIndex--;
      }
      else if (oldIndex > _selectedTestIndex && trueIndex <= _selectedTestIndex) {
        _selectedTestIndex++;
      }
      else if (oldIndex == _selectedTestIndex) {
        _selectedTestIndex = trueIndex;
      }
    });
  }

  void _saveTests(BuildContext context) {
    AppState.saveEditedTests(_editingTests).then((success) {
      setState(() => _editingTests = []);
      if (!success) { showErrorDialog(context, ErrorType.save); }
    });
    setState(() => AppState.updateEditingState(EditingAction.endEditingTestListing));
  }

  int _indexOfTest(Test test) {
    for (int i = 0; i < _editingTests.length; i++) {
      if (_editingTests[i].test == test) {
        return i;
      }
    }
    return -1;
  }

  void _onSelect(BuildContext context, int index) {
    if (!AppState.isEditing(EditingType.listing)) { // Only allow selection if NOT editing
      if (AppState.editingState.value != EditingState.notEditing) {
        showConfirmationDialog(
            context: context,
            title: "変更は保存されません",
            description: "保存されていない変更があります。変更を放棄して次の画面に進みますか？",
            confirmText: "進む",
            onConfirm: () {
              AppState.updateEditingState(EditingAction.endEditingTest);
              AppState.updateEditingState(EditingAction.endEditingTestListing);
              AppState.selectedTest.value = AppState.allTests[index];
              setState(() => _selectedTestIndex = index);
            }
        );
      } else {
        AppState.selectedTest.value = AppState.allTests[index];
        setState(() => _selectedTestIndex = index);
      }
    }
  }

  /* INIT/BUILD ============================================================= */

  @override
  void initState() {
    _selectedTestIndex = AppState.selectedTest.value?.order ?? -1;
    AppState.editingState.addListener(() {
      if (!AppState.isEditing(EditingType.listing)) {
        setState(() {
          _selectedTestIndex = AppState.selectedTest.value?.order ?? -1;
        }); // Reload if editing was force stopped by detail nav
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Constants.sakura,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
            child: SpacedGroup(
              axis: Axis.horizontal,
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                !AppState.isEditing(EditingType.listing)
                  ? ScaleButton(
                    child: SvgPicture.asset('assets/images/add.svg', height: 16),
                    onTap: () =>
                      showTitleEditDialog(
                        context,
                        '新テスト作成',
                        (title) => _addTest(context, title)
                      ),
                  )
                  : Container(),
                ScaleButton(
                  child: SvgPicture.asset(
                    'assets/images/${AppState.isEditing(EditingType.listing) ? 'save' : 'edit'}.svg',
                    height: 16
                  ),
                  onTap: () {
                    if (AppState.isEditing(EditingType.listing)) { _saveTests(context); }
                    else {
                      setState(() {
                        _editingTests = AppState.getEditingCopy();
                        AppState.updateEditingState(EditingAction.beginEditingTestListing);
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: AppState.selectedTest,
              builder: (context, test, child) {
                if (AppState.isEditing(EditingType.listing)) {
                  if (test != null && test != _editingTests[_selectedTestIndex].test) {
                    _selectedTestIndex = _indexOfTest(test);
                  }
                }
                return AppState.selectedTest.value != null
                  ? ListenableBuilder(
                    listenable: AppState.selectedTest.value!,
                    builder: (context, child) {
                      return ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            key: Key('$index'),
                            padding: EdgeInsets.fromLTRB(0, index == 0 ? 10 : 0, 0, 0),
                            child: TestListing(
                              key: UniqueKey(),
                              testTitle: AppState.isEditing(EditingType.listing)
                                ? _editingTests[index].title
                                : AppState.allTests[index].title,
                              index: index,
                              isEditing: AppState.isEditing(EditingType.listing),
                              isSelected: index == _selectedTestIndex,
                              onSelect: () => _onSelect(context, index),
                            )
                          );
                        },
                        itemCount: AppState.isEditing(EditingType.listing) ? _editingTests.length : AppState.allTests.length,
                        shrinkWrap: true,
                        onReorder: _reorderTest
                      );
                    }
                  )
                  : ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          key: Key('$index'),
                          padding: EdgeInsets.fromLTRB(0, index == 0 ? 10 : 0, 0, 0),
                          child: TestListing(
                            key: UniqueKey(),
                            testTitle: AppState.isEditing(EditingType.listing)
                                ? _editingTests[index].title
                                : (index == _selectedTestIndex ? test!.title : AppState.allTests[index].title),
                            index: index,
                            isEditing: AppState.isEditing(EditingType.listing),
                            isSelected: index == _selectedTestIndex,
                            onSelect: () {
                              if (!AppState.isEditing(EditingType.listing)) {
                                AppState.selectedTest.value = AppState.allTests[index];
                                setState(() => _selectedTestIndex = index);
                              }
                            },
                          )
                      );
                    },
                    itemCount: AppState.isEditing(EditingType.listing) ? _editingTests.length : AppState.allTests.length,
                    shrinkWrap: true,
                    onReorder: _reorderTest
                  );
              }
            ),
          )
        ],
      ),
    );
  }
}
