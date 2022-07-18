import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

abstract class GetTriviaQuestionRepository {
  Future<Either<Failure, List<QuestionEntity>>> getQuestions({
    required int amount,
    required String category,
    required String difficulty,
  });
}
