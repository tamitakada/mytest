import 'package:mytest/models/models.dart';
import 'dart:math';

mixin ExamMixin {
  // NR = No Replacement
  Question generateRandomQuestionNR(List<Question> questions) {
    Random random = Random();
    int questionIndex = random.nextInt(questions.length);
    Question toReturn = questions[questionIndex];
    questions.removeAt(questionIndex);
    return toReturn;
  }

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

  void _addToAnswers(
    String letter,
    int currentAnswer,
    List<String> answers,
    bool optional,
    int currentOptional
  ) {
    int i = currentAnswer;
    if (optional) { i += pow(2, currentOptional) as int; }
    for (i; i < answers.length; i++) {
      answers[i] += letter;
    }
  }

  List<String> parseAnswer(String answer) {
    List<String> answers = [""];
    int currentAnswer = 0;

    bool optional = false;
    int currentOptional = -1;

    for (int i = 0; i < answer.length; i++) {
      switch (answer[i]) {
        case "・": // Split answer
          answers.add("");
          currentAnswer = answers.length - 1;
          currentOptional = -1;
          break;
        case "[": // Begin optional block iff not already begun
          if (!optional) {
            optional = true;
            currentOptional++;

            // Copy all current answers
            int currentLen = answers.length;
            for (int j = currentAnswer; j < currentLen; j++) {
              answers.add(answers[j]);
            }
          }
          else { // Treat like a normal optional char
            _addToAnswers(answer[i], currentAnswer, answers, true, currentOptional);
          }
          break;
        case "]": // End optional block iff previously begun
          if (optional) { optional = false; }
          else { // Treat like a normal char
            _addToAnswers(answer[i], currentAnswer, answers, false, currentOptional);
          }
          break;
        default:
          _addToAnswers(answer[i], currentAnswer, answers, optional, currentOptional);
          break;
      }
    }

    return answers;
  }

  bool isAnswerCorrect(Question question, String answer, bool flipTerms) {
    List<String> answers = parseAnswer(flipTerms ? question.question : question.answer);
    return answers.contains(answer);
  }

}
