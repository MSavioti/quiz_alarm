import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/save_questions_to_local_storage_usecase.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';

import '../../fixtures/get_question_fixture.dart';

class MockGetQuestionsRepository extends Mock
    implements GetQuestionsRepository {}

void main() {
  final mockGetQuestionsRepository = MockGetQuestionsRepository();
  final useCase = SaveQuestionsToLocalStorageUseCase(
    getTriviaQuestionRepository: mockGetQuestionsRepository,
  );
  const int tQuestionsAmount = 3;
  const String tCategory = 'Entertainment: Video Games';
  const String tDifficulty = 'Medium';
  final List<QuestionEntity> tQuestions =
      GetQuestionsFixture.getDummyTriviaQuestions(tQuestionsAmount);

  group('Save questions to local storage use case', () {
    test(
        'should save questions to local storage when questions are retrieved from remote data source ',
        () async {
      when(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: any(named: 'amount'),
            category: any(named: 'category'),
            difficulty: any(named: 'difficulty'),
          )).thenAnswer((_) async => Right(tQuestions));
      when(() => mockGetQuestionsRepository.saveQuestionsToLocalStorage(
              any(), any(), any()))
          .thenAnswer(
              (_) async => const Right<LocalStorageFailure, bool>(true));

      await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      ));

      verify(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: tCategory,
            difficulty: tDifficulty,
          ));
      verify(() => mockGetQuestionsRepository.saveQuestionsToLocalStorage(
            tQuestions,
            tCategory,
            tDifficulty,
          ));
    });

    test(
        'should return a Failure when repository cannot retrieve questions from remote data source',
        () async {
      when(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: any(named: 'amount'),
            category: any(named: 'category'),
            difficulty: any(named: 'difficulty'),
          )).thenAnswer((_) async => Left(ServerFailure()));

      final result = await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      ));

      expect(result, isA<Left<Failure, bool>>());
      final hasSucceeded = result.fold<bool>((l) => false, (r) => r);
      expect(hasSucceeded, false);
      verify(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: tCategory,
            difficulty: tDifficulty,
          ));
    });

    test(
        'should return a failure when repository cannot save questions to local storage',
        () async {
      when(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: any(named: 'amount'),
            category: any(named: 'category'),
            difficulty: any(named: 'difficulty'),
          )).thenAnswer((_) async => Left(LocalStorageFailure()));

      final result = await useCase(QuestionParameters(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      ));

      expect(result, isA<Left<Failure, bool>>());
      final hasSucceeded = result.fold<bool>((l) => false, (r) => r);
      expect(hasSucceeded, false);
      verify(() => mockGetQuestionsRepository.getQuestionsFromRemote(
            amount: tQuestionsAmount,
            category: tCategory,
            difficulty: tDifficulty,
          ));
    });
  });
}
