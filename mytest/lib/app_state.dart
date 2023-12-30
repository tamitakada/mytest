import 'package:flutter/material.dart';
import 'utils/data_manager.dart';
import 'models/models.dart';
import 'models/editing_test.dart';

class AppState {

  static List<Test> allTests = [];

  static ValueNotifier<Test?> selectedTest = ValueNotifier(null);

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

}