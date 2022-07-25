import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

class GetQuestionsRemoteDataSourceImpl implements GetQuestionsRemoteDataSource {
  @override
  Future<List<QuestionModel>> getQuestionsFromApi(
      {required int amount,
      required String category,
      required String difficulty}) {
    // TODO: implement getQuestionsFromApi
    throw UnimplementedError();
  }
}
