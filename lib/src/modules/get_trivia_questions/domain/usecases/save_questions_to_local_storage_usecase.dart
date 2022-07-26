import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';
import 'package:quiz_waker/src/shared/use_cases/use_case.dart';

class SaveQuestionsToLocalStorageUseCase
    implements UseCase<bool, QuestionParameters> {
  final GetQuestionsRepository getTriviaQuestionRepository;

  SaveQuestionsToLocalStorageUseCase(
      {required this.getTriviaQuestionRepository});

  @override
  Future<Either<Failure, bool>> call(
    QuestionParameters params,
  ) async {
    final questionResult =
        await getTriviaQuestionRepository.getQuestionsFromRemote(
      amount: params.amount,
      category: params.category,
      difficulty: params.difficulty,
    );

    if (questionResult.isLeft()) {
      return Left(questionResult.fold((l) => l, (r) => Failure()));
    }

    final questions =
        questionResult.fold<List<QuestionEntity>>((l) => [], (r) => r);
    final savingResult =
        await getTriviaQuestionRepository.saveQuestionsToLocalStorage(
      questions,
      params.category,
      params.difficulty,
    );
    return savingResult;
  }
}
