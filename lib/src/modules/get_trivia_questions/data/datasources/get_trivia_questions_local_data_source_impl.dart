import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_trivia_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

class GetTriviaQuestionsLocalDataSourceImpl
    implements GetTriviaQuestionsLocalDataSource {
  @override
  Future<List<QuestionModel>> getQuestionsFromApi(
      {required int amount,
      required String category,
      required String difficulty}) {
    // TODO: implement getQuestionsFromApi
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionModel>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  }) {
    // TODO: implement getQuestionsFromLocalStorage
    throw UnimplementedError();
  }
}
