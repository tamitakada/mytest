import 'package:mytest/models/models.dart';
import 'dart:math';

mixin ExamMixin {

  Question generateRandomQuestion(Test test) {
    Random random = Random();
    int questionIndex = random.nextInt(test.questions.length);
    return test.questions.elementAt(questionIndex);
  }
  
  bool _matchStringWithinError(String s1, String s2, int error) {
    int mistakes = 0;
    for (int i = 0; i < s1.length; i++) {
      if (i >= s2.length || s1[i] != s2[i]) {
        mistakes++;
        if (mistakes > error) {
          return false;
        }
      }
    }
    mistakes += (s2.length > s1.length) ? (s2.length - s1.length) : 0;
    return mistakes <= error;
  }

  bool isAnswerCorrect(Question question, String answer) {
    List<String> answers = question.answer.split('・');
    RegExp bracketMatch = RegExp(r'\[.*?\]');

    for (var a in answers) {
      a = a.replaceAll(bracketMatch, '');
      if (_matchStringWithinError(a, answer, question.allowedMistakes)) {
        return true;
      }
    }

    return false;
  }

}