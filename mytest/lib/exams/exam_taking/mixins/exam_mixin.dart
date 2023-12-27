import 'package:mytest/models/models.dart';
import 'package:mytest/constants.dart';
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

  Question generateRandomQuestion(TestMode mode, List<Question> questions) {
    if (questions.length > 1) {
      Random random = Random();
      int questionIndex = random.nextInt(questions.length - 1);

      // Swap to prevent same question from appearing twice in a row
      Question temp = questions[questionIndex];
      questions[questionIndex] = questions[questions.length - 1];
      questions[questions.length - 1] = temp;

      return temp;
    } else {
      return questions[0];
    }
  }

  bool _matchWithinError(List<String> answers, String input) {
    for (String answer in answers) {
      bool match = true;
      int allowedError = (answer.length * 0.1).toInt();

      for (int i = 0; i < input.length; i++) {
        if (answer.length <= i || input[i] != answer[i]) {
          allowedError--;
          if (allowedError < 0) { match = false; }
        }
      }

      if (answer.length > input.length) {
        allowedError -= (answer.length - input.length);
        if (allowedError < 0) { match = false; }
      }

      if (match) { return true; }
    }
    return false;
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

    answers.add(answer); // Add full answer

    return answers;
  }

  bool isAnswerCorrect(Question question, String answer, bool flipTerms, bool allowError) {
    List<String> answers = parseAnswer(flipTerms ? question.question : question.answer);
    if (allowError) {
      return _matchWithinError(answers, answer);
    } else {
      return answers.contains(answer);
    }
  }

}
