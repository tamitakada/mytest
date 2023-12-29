import 'package:isar/isar.dart';
import 'test.dart';

part 'question.g.dart';

@collection
class Question {

  Id id = Isar.autoIncrement;

  final test = IsarLink<Test>();

  String question;
  String answer;
  int order;

  int allowedMistakes;

  bool archived;

  List<String> images;

  Question({
    required this.question,
    required this.answer,
    required this.order,
    required this.images,
    this.allowedMistakes = 0,
    this.archived = false
  });

}