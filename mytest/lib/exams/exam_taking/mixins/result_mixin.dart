import 'package:mytest/pair.dart';
import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';

mixin ExamResultMixin {

  int getPercentageScore(List<Pair<Question, bool>> questions) {
    double correct = 0;
    for (var pair in questions) {
      correct += pair.b ? 1 : 0;
    }
    double rawScore = correct / questions.length.toDouble();
    return (rawScore * 100).toInt();
  }

  Future<bool> saveResult(List<Pair<Question, bool>> questions, Test test) async {
    Record record = Record(time: DateTime.now());
    for (var pair in questions) {
      if (pair.b) {
        record.correctQuestions.add(pair.a);
      } else {
        record.incorrectQuestions.add(pair.a);
      }
    }
    return await DataManager.upsertRecord(record, test);
  }

}