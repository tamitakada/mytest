import 'package:mytest/models/models.dart';
import 'package:mytest/utils/data_manager.dart';


mixin ExamEditMixin {

  void editQuestion(
    Test test,
    String questionText,
    String answerText,
    int mistakes,
    List<String>? images,
    Question? question,
    void Function(bool)? then
  ) {
    if (question == null) {
      Question newQuestion = Question(
        question: questionText,
        answer: answerText,
        allowedMistakes: mistakes,
        images: images
      );
      DataManager.upsertQuestion(newQuestion, test).then(then ?? (_){});
    } else {
      question.question = questionText;
      question.answer = answerText;
      question.allowedMistakes = mistakes;
      DataManager.upsertQuestion(question, test).then(then ?? (_){});
    }
  }

}