import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/save_questions_to_local_storage_usecase.dart';
import 'package:quiz_waker/src/shared/constants/categories_ids_constants.dart';
import 'package:quiz_waker/src/shared/constants/difficulties_names_constants.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';

import '../../fixtures/get_question_fixture.dart';

class MockGetQuestionsRepository extends Mock
    implements GetQuestionsRepository {}

void main() {
  final mockGetTriviaQuestionRepository = MockGetQuestionsRepository();
  late final List<QuestionEntity> tQuestions;
  late final SaveQuestionsToLocalStorageUseCase useCase;
  const int tQuestionsAmount = 3;
  const String tCategory = 'Entertainment: Video Games';
  const String tDifficulty = 'Medium';

  setUpAll(() {
    useCase = SaveQuestionsToLocalStorageUseCase(
      getTriviaQuestionRepository: mockGetTriviaQuestionRepository,
    );
    tQuestions = GetQuestionsFixture.getDummyTriviaQuestions(tQuestionsAmount);
  });

  group('Save questions to local storage use case', () {
    test(
        'should save questions to local storage when questions are retrieved from remote data source ',
        () async {
      when(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          )).thenAnswer((_) async => Right(tQuestions));
      when(() => mockGetTriviaQuestionRepository.saveQuestionsToLocalStorage(
              tQuestions, tCategory, tDifficulty))
          .thenAnswer((_) async => const Right(true));

      final result = await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: CategoriesIdsConstants.generalKnowledge,
        difficulty: DifficultiesNamesConstants.easy,
      ));

      expect(result, isA<Right<Failure, bool>>());
      final hasSucceeded = result.fold<bool>((l) => false, (r) => r);
      expect(hasSucceeded, true);
      verify(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          ));
      verify(() => mockGetTriviaQuestionRepository.saveQuestionsToLocalStorage(
          tQuestions, tCategory, tDifficulty));
    });

    test(
        'should return a Failure when repository cannot retrieve questions from remote data source',
        () async {
      when(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          )).thenAnswer((_) async => Left(Failure()));

      final result = await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: CategoriesIdsConstants.generalKnowledge,
        difficulty: DifficultiesNamesConstants.easy,
      ));

      expect(result, isA<Left<Failure, bool>>());
      final hasSucceeded = result.fold<bool>((l) => false, (r) => r);
      expect(hasSucceeded, false);
      verify(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          ));
    });

    test(
        'should return a failure when repository cannot save questions to local storage',
        () async {
      when(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          )).thenAnswer((_) async => Right(tQuestions));
      when(() => mockGetTriviaQuestionRepository.saveQuestionsToLocalStorage(
              tQuestions, tCategory, tDifficulty))
          .thenAnswer((_) async => Left(LocalStorageFailure()));

      final result = await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: CategoriesIdsConstants.generalKnowledge,
        difficulty: DifficultiesNamesConstants.easy,
      ));

      expect(result, isA<Left<Failure, bool>>());
      final hasSucceeded = result.fold<bool>((l) => false, (r) => r);
      expect(hasSucceeded, false);
      verify(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: CategoriesIdsConstants.generalKnowledge,
            difficulty: DifficultiesNamesConstants.easy,
          ));
      verify(() => mockGetTriviaQuestionRepository.saveQuestionsToLocalStorage(
          tQuestions, tCategory, tDifficulty));
    });
  });
}
