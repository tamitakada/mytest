import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mytest/models/models.dart';
import 'file_utils.dart';


class DataManager {

  static Isar? _isar;

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Isar> get isar async {
    _isar ??= await Isar.open(
        [TestSchema, QuestionSchema, RecordSchema],
        directory: await _localPath
    );
    return _isar!;
  }

  // GETTERS ===================================================================

  static Future<List<Record>?> getAllRecords(Test test) async {
    try {
      return await (await isar).records
        .filter()
        .test((q) => q.idEqualTo(test.id))
        .sortByTimeDesc()
        .findAll();
    }
    catch (e) { return null; }
  }

  static Future<List<Test>?> getAllTests() async {
    try {
      return await (await isar).tests
        .where()
        .sortByOrder()
        .findAll();
    }
    catch (e) { return null; }
  }

  // SETTERS ===================================================================

  static Future<bool> upsertTests(List<Test> tests) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).tests.putAll(tests);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> upsertTest(Test test) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).tests.put(test);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> upsertQuestion(Question question, Test test) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).questions.put(question);
        test.questions.add(question);
        await test.questions.save();
        await test.questions.load();
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> upsertQuestions(List<Question> questions, Test test) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).questions.putAll(questions);
        test.questions.addAll(questions);
        await test.questions.save();
        await test.questions.load();
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> upsertRecord(Record record, Test test) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).records.put(record);
        await record.incorrectQuestions.save();
        await record.correctQuestions.save();
        record.test.value = test;
        await record.test.save();
      });
      return true;
    } catch (e) { return false; }
  }

  // DELETES ===================================================================

  static Future<bool> deleteTests(List<Test> tests) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).tests.deleteAll(tests.map((t) => t.id).toList());
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteQuestions(List<Question> questions) async {
    try {
      for (Question q in questions) {
        for (String i in q.images) {
          if (!await FileUtils.deleteFile(i)) {
            return false;
          }
        }
      }
      questions.first.test.value?.questions.removeAll(questions);
      await (await isar).writeTxn(() async {
        await questions.first.test.save();
        await (await isar).questions.deleteAll(
          questions.map((q) => q.id).toList()
        );
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

}