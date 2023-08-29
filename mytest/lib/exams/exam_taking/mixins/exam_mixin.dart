import 'package:mytest/models/models.dart';
import 'dart:math';

mixin ExamMixin {

  Question generateRandomQuestion(Test test) {
    Random random = Random();
    int questionIndex = random.nextInt(test.questions.length);
    return test.questions.elementAt(questionIndex);
  }

  bool isAnswerCorrect(Question question, String answer) {
    int mistakes = 0;
    for (int i = 0; i < question.answer.length; i++) {
      if (i >= answer.length || question.answer[i] != answer[i]) {
        mistakes++;
        if (mistakes > question.allowedMistakes) {
          return false;
        }
      }
    }
    mistakes += (answer.length > question.answer.length) ? (answer.length - question.answer.length) : 0;
    return mistakes <= question.allowedMistakes;
  }

}