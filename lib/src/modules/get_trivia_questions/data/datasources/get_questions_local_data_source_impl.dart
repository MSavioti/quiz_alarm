import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

class GetQuestionsLocalDataSourceImpl implements GetQuestionsLocalDataSource {
  @override
  Future<List<QuestionModel>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  }) {
    // TODO: implement getQuestionsFromLocalStorage
    throw UnimplementedError();
  }

  @override
  Future<bool> saveQuestionsToLocalStorage(
      {required List<QuestionEntity> questions}) {
    // TODO: implement saveQuestionsToLocalStorage
    throw UnimplementedError();
  }
}
