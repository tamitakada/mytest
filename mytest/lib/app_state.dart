import 'package:flutter/material.dart';
import 'utils/data_manager.dart';
import 'models/models.dart';
import 'models/editing_test.dart';

enum EditingType {
  test,
  listing,
  both,
  none
}

enum EditingState {
  editingTest,
  editingTestListing,
  editingBoth,
  notEditing
}

enum EditingAction {
  beginEditingTest,
  beginEditingTestListing,
  endEditingTest,
  endEditingTestListing
}

class AppState {

  static List<Test> allTests = [];

  static ValueNotifier<Test?> selectedTest = ValueNotifier(null);
  static ValueNotifier<EditingState> editingState = ValueNotifier(EditingState.notEditing);

  static List<Test> getAllTests() => allTests;
  static List<EditingTest> getEditingCopy() =>
    allTests.map((t) => EditingTest.test(t)).toList();

  static Future<bool> fetchTests() async {
    List<Test>? allTestsTemp = await DataManager.getAllTests();
    if (allTestsTemp != null) {
      allTests = allTestsTemp;
      return true;
    }
    return false;
  }

  static Future<bool> saveEditedTests(List<EditingTest> editingTests) async {
    allTests = [];
    for (int i = 0; i < editingTests.length; i++) {
      editingTests[i].order = i;
      if (!(await editingTests[i].upsertTest())) {
        return false;
      }
      allTests.add(editingTests[i].test!);
    }
    return true;
  }

  static Future<bool> addTest(Test test) async {
    if (await DataManager.upsertTest(test)) {
      allTests.add(test);
      return true;
    }
    return false;
  }

  static Future<bool> deleteTest(Test test) async {
    if (await DataManager.deleteTest(test)) {
      allTests.remove(test);
      for (int i = 0; i < allTests.length; i++) {
        allTests[i].order = i;
      }
      return await DataManager.upsertTests(allTests);
    }
    return false;
  }

  static bool isEditing(EditingType type) {
    switch (type) {
      case EditingType.test:
        return editingState.value == EditingState.editingTest
              || editingState.value == EditingState.editingBoth;
      case EditingType.listing:
        return editingState.value == EditingState.editingTestListing
            || editingState.value == EditingState.editingBoth;
      case EditingType.both:
        return editingState.value == EditingState.editingBoth;
      case EditingType.none:
        return editingState.value == EditingState.notEditing;
    }
  }

  static void updateEditingState(EditingAction action) {
    switch (editingState.value) {
      case EditingState.editingTest:
        switch (action) {
          case EditingAction.beginEditingTestListing:
            editingState.value = EditingState.editingBoth;
            break;
          case EditingAction.endEditingTest:
            editingState.value = EditingState.notEditing;
            break;
          default:
            break;
        }
        break;
      case EditingState.editingTestListing:
        switch (action) {
          case EditingAction.beginEditingTest:
            editingState.value = EditingState.editingBoth;
            break;
          case EditingAction.endEditingTestListing:
            editingState.value = EditingState.notEditing;
            break;
          default:
            break;
        }
        break;
      case EditingState.editingBoth:
        switch (action) {
          case EditingAction.endEditingTest:
            editingState.value = EditingState.editingTestListing;
            break;
          case EditingAction.endEditingTestListing:
            editingState.value = EditingState.editingTest;
            break;
          default:
            break;
        }
        break;
      case EditingState.notEditing:
        switch (action) {
          case EditingAction.beginEditingTest:
            editingState.value = EditingState.editingTest;
            break;
          case EditingAction.beginEditingTestListing:
            editingState.value = EditingState.editingTestListing;
            break;
          default:
            break;
        }
        break;
    }
  }

}