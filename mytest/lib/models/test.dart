import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'question.dart';
import 'record.dart';

part 'test.g.dart';

@collection
class Test with ChangeNotifier {

  Id id = Isar.autoIncrement;

  String _title;
  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  int order;

  bool flipTerms;
  bool allowError;

  @Index()
  DateTime? lastTestDate;

  @Backlink(to: 'test')
  final questions = IsarLinks<Question>();

  @Backlink(to: 'test')
  final records = IsarLinks<Record>();

  Test({ required String title, required this.order, this.flipTerms = false, this.allowError = false })
    : _title = title;

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