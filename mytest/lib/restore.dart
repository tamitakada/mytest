import 'utils/file_utils.dart';
import 'utils/data_manager.dart';
import 'models/models.dart';


class Development {


  
  static Future<bool> addBackup(String title, int order, String backup) async {
    List<String> questions = backup.split("\n\n");
    List<Question> questionsToAdd = [];
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].trim().isNotEmpty) {
        List<String> details = questions[i].split("\n");
        String question = details[0];
        String answer = details[1];
        questionsToAdd.add(
          Question(
            question: question,
            answer: answer,
            order: i,
            images: List<String>.empty(growable: true)
          )
        );
      }
    }
    Test test = Test(title: title, order: order);
    return await DataManager.upsertTest(test) && await DataManager.upsertQuestions(questionsToAdd, test);
  }

  static Future<bool> createTestFromString(String title, int order, String testText) async {
    List<String> questionTexts = testText.split("\n\n");
    List<Question> questions = [];
    int count = 0;
    for (var text in questionTexts) {
      if (text.isNotEmpty) {
        List<String> details = text.split("\n");
        if (details.length > 1) {
          String question = details[0];
          String answer = details[1];
          questions.add(
            Question(
              question: question, answer: answer, order: count,
              images: List<String>.empty(growable: true)
            )
          );
          count++;
        }
      }
    }
    Test test = Test(title: title, order: order);
    return await DataManager.upsertTest(test)
        && await DataManager.upsertQuestions(questions, test);
  }
  
}