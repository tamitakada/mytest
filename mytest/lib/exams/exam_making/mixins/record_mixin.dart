import 'package:mytest/models/models.dart';

mixin RecordMixin {

  int getScore(Record record) {
    double score = record.correctQuestions.length / (record.correctQuestions.length + 3);
    return (score * 100).toInt();
  }

}