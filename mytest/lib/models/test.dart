import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'question.dart';
import 'record.dart';

part 'test.g.dart';

@collection
class Test {

  Id id = Isar.autoIncrement;

  String title;

  int order;

  bool flipTerms;
  bool allowError;

  @Index()
  DateTime? lastTestDate;

  @Backlink(to: 'test')
  final questions = IsarLinks<Question>();

  @Backlink(to: 'test')
  final records = IsarLinks<Record>();

  Test({ required this.title, required this.order, this.flipTerms = false, this.allowError = false });

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Test && (other.id == id);
  }

}

extension QuestionSort on Test {
  List<Question> getOrderedQuestions() {
    List<Question> ordered = questions.toList();
    ordered.sort((a, b) => a.order.compareTo(b.order));
    return ordered;
  }
}