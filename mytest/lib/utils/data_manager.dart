import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mytest/models/models.dart';


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

  static Future<List<Test>?> getAllTests() async {
    try {
      return await (await isar).tests
        .where()
        .sortByLastTestDate()
        .findAll();
    }
    catch (e) { return null; }
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
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> upsertRecord(Record record, Test test) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).records.put(record);
        record.test.value = test;
        await record.test.save();
      });
      return true;
    } catch (e) { return false; }
  }

}