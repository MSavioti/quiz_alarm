import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

abstract class GetTriviaQuestionsLocalDataSource {
  Future<List<QuestionModel>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  });
}
