import 'package:mytest/models/models.dart';
import 'package:mytest/constants.dart';
import 'package:intl/intl.dart';

mixin RecordMixin {

  String getDate(Record record) {
    final DateFormat formatter = DateFormat('yy.MM.dd hh:mm');
    return formatter.format(record.time);
  }

  int getScore(Record record) {
    double score = 0;
    if (record.correctQuestions.isNotEmpty || record.incorrectQuestions.isNotEmpty) {
      score = record.correctQuestions.length / (record.correctQuestions.length + record.incorrectQuestions.length);
    }
    return (score * 100).toInt();
  }

  Map<TestMode, List<Record>> sortRecordsByType(List<Record> allRecords) {
    Map<TestMode, List<Record>> map = {
      TestMode.full: [],
      TestMode.lives: [],
      TestMode.practice: []
    };

    for (var record in allRecords) {
      if (record.testMode > 3 || record.testMode < 0) {
        map[TestMode.values[0]]!.add(record);
      } else {
        map[TestMode.values[record.testMode]]!.add(record);
      }
    }
    return map;
  }

}