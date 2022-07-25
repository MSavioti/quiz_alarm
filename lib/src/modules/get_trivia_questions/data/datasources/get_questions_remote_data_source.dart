import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

abstract class GetQuestionsRemoteDataSource {
  Future<List<QuestionModel>> getQuestionsFromApi({
    required int amount,
    required String category,
    required String difficulty,
  });
}
