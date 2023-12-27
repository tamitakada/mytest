import 'utils/data_manager.dart';
import 'models/models.dart';

class AppState {

  static List<Test> allTests = [];
  static bool testsInitialized = false;

  static List<Test> getAllTests() => allTests;

  static Future<bool> fetchTests() async {
    List<Test>? allTestsTemp = await DataManager.getAllTests();
    if (allTestsTemp != null) {
      allTests = allTestsTemp;
      testsInitialized = true;
      return true;
    }
    return false;
  }

  static Future<bool> saveTests(List<Test> testsToDelete) async {
    for (int i = 0; i < allTests.length; i++) {
      allTests[i].order = i;
    }
    if (await DataManager.upsertTests(allTests)) {
      if (testsToDelete.isNotEmpty) {
        return await DataManager.deleteTests(testsToDelete);
      }
      return true;
    }
    return false;
  }

  static Future<bool> addTest(Test test) async {
    if (await DataManager.upsertTest(test)) {
      allTests.add(test);
      return true;
    }
    return false;
  }

  static Future<bool> reorderTest(Test test) async {
    if (await DataManager.upsertTest(test)) {
      allTests.remove(test);
      allTests.insert(test.order, test);
      return true;
    }
    return false;
  }
}