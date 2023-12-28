import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';
import 'package:mytest/utils/file_utils.dart';
import 'dart:io';
import 'package:mytest/pair.dart';


mixin ExamEditMixin {

  Future<bool> editQuestion(
    Test test,
    String questionText,
    String answerText,
    int mistakes,
    List<Pair<String, bool>>? images,
    Question? question
  ) async {
    question?.question = questionText;
    question?.answer = answerText;
    question?.allowedMistakes = mistakes;

    Question toEdit = question ?? Question(
      order: 1,
      question: questionText,
      answer: answerText,
      allowedMistakes: mistakes
    );
    if (!(await DataManager.upsertQuestion(toEdit, test))) { return false; }

    List<String> imageNames = [];
    int order = 0;
    for (int i = 0; i < (images?.length ?? 0); i++) {
      String fileName = "${toEdit.id}-$order";
      File? copied = await FileUtils.copyFile(
        images![i].b ? await FileUtils.localFile(images[i].a) : File(images[i].a),
        fileName
      );
      if (copied != null) {
        imageNames.add(fileName);
        order++;
      }
    }

    toEdit.images = imageNames;
    return await DataManager.upsertQuestion(toEdit, test);
  }

}