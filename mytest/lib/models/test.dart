import 'package:isar/isar.dart';
import 'question.dart';
import 'record.dart';

part 'test.g.dart';

@collection
class Test {

  Id id = Isar.autoIncrement;

  String title;

  bool flipTerms;
  bool allowError;

  @Index()
  DateTime? lastTestDate;

  @Backlink(to: 'test')
  final questions = IsarLinks<Question>();

  @Backlink(to: 'test')
  final records = IsarLinks<Record>();

  Test({ required this.title, this.flipTerms = false, this.allowError = false });

}