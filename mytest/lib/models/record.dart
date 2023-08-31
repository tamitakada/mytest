import 'package:isar/isar.dart';
import 'test.dart';
import 'question.dart';

part 'record.g.dart';

@collection
class Record {

  Id id = Isar.autoIncrement;

  DateTime time;
  int testMode;

  final test = IsarLink<Test>();
  final correctQuestions = IsarLinks<Question>();
  final incorrectQuestions = IsarLinks<Question>();

  Record({ required this.time, required this.testMode });

}