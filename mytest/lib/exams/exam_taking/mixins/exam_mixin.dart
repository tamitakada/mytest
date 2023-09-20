import 'package:mytest/models/models.dart';
import 'dart:math';

mixin ExamMixin {

  Question generateRandomQuestion(Test test) {
    Random random = Random();
    int questionIndex = random.nextInt(test.questions.length);
    return test.questions.elementAt(questionIndex);
  }
  
  bool _matchStringWithinError(String s1, String s2, int error) {
    int s1Index = 0;
    int s2Index = 0;

    bool openBrackets = false;

    while (s1Index < s1.length && s2Index < s2.length) {
      if ((!openBrackets && s1[s1Index] == '[') || (openBrackets && s1[s1Index] == ']')) {
        if (s2[s2Index] == s1[s1Index]) s2Index++;
        openBrackets = !openBrackets;
      } else {
        if (s1[s1Index] != s2[s2Index]) { return false; }
        s2Index++;
      }
      s1Index++;
    }

    while (openBrackets && s1Index < s1.length) {
      if (s1[s1Index] == ']') { break; }
      else {
        s1Index++;
        if (s1Index == s1.length) { return false; }
      }
    }

    return !((s1Index < s1.length) || s2Index < s2.length);
  }

  List<String> parseAnswers(String answer) {
    int i = 0;

    bool ignoreSpecial = false;
    bool optional = false;

    List<String> answers = [];

    String current = '';
    String optionalCurrent = '';

    while (i < answer.length) {
      if (!ignoreSpecial) {
        if (answer[i] == '\\') { ignoreSpecial = true; i++; continue; }
        else if (!optional && answer[i] == '[') {
          optionalCurrent += current;
          optional = true;
          i++; continue;
        }
        else if (optional && answer[i] == ']') { optional = false; i++; continue; }
        else if (!optional && answer[i] == '・') {
          answers.add(current);
          if (optionalCurrent.isNotEmpty) { answers.add(optionalCurrent); }
          current = '';
          optionalCurrent = '';
          i++; continue;
        }
      }
      else { ignoreSpecial = false; }

      if (!optional) { current += answer[i]; }
      if (optional || optionalCurrent.isNotEmpty) {
        optionalCurrent += answer[i];
      }

      i++;
    }

    if (current.isNotEmpty) { answers.add(current); }
    if (optionalCurrent.isNotEmpty) { answers.add(optionalCurrent); }

    return answers;
  }

  bool isAnswerCorrect(Question question, String answer) {
    List<String> answers = parseAnswers(question.answer);
    return answers.contains(answer);
  }

}
