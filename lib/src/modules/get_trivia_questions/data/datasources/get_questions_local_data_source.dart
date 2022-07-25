import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

abstract class GetQuestionsLocalDataSource {
  Future<List<QuestionModel>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  });

  Future<bool> saveQuestionsToLocalStorage({
    required List<QuestionEntity> questions,
  });
}
