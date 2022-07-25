import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_trivia_question_repository.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';
import 'package:quiz_waker/src/shared/use_cases/use_case.dart';

class GetTriviaQuestionsFromLocalStorageUseCase
    implements UseCase<List<QuestionEntity>, QuestionParameters> {
  final GetTriviaQuestionRepository getTriviaQuestionRepository;

  GetTriviaQuestionsFromLocalStorageUseCase(
      {required this.getTriviaQuestionRepository});

  @override
  Future<Either<Failure, List<QuestionEntity>>> call(
    QuestionParameters params,
  ) async {
    return await getTriviaQuestionRepository.getQuestionsFromLocalStorage(
      amount: params.amount,
      category: params.category,
      difficulty: params.difficulty,
    );
  }
}
