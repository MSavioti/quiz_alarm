import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_trivia_question_repository.dart';

class GetTriviaQuestionsRepositoryImpl implements GetTriviaQuestionRepository {
  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestions(
      {required int amount,
      required String category,
      required String difficulty}) {
    // TODO: implement getQuestions
    throw UnimplementedError();
  }
}
