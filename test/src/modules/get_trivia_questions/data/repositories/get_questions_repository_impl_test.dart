import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/repositories/get_questions_repository_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

import '../../fixtures/get_question_fixture.dart';

class MockGetQuestionsRemoteDataSource extends Mock
    implements GetQuestionsRemoteDataSource {}

class MockGetQuestionsLocalDataSource extends Mock
    implements GetQuestionsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late final MockNetworkInfo mockNetworkInfo;
  late final GetQuestionsRepositoryImpl repository;
  late final MockGetQuestionsRemoteDataSource mockRemoteDataSource;
  late final MockGetQuestionsLocalDataSource mockLocalDataSource;
  late final int tAmount;
  late final String tCategory;
  late final String tDifficulty;
  late final List<QuestionModel> dummyQuestionModels;

  setUpAll(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockGetQuestionsRemoteDataSource();
    mockLocalDataSource = MockGetQuestionsLocalDataSource();
    repository = GetQuestionsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    tAmount = 3;
    tCategory = 'Entertainment: Video Games';
    tDifficulty = 'Medium';
    dummyQuestionModels =
        GetQuestionsFixture.getDummyTriviaQuestionModels(tAmount);
  });

  group('Get Trivia Questions repository', () {
    group('check internet connection', () {
      test(
          'should try to connect to the internet when retrieving trivia questions',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer(
          (_) async =>
              GetQuestionsFixture.getDummyTriviaQuestionModels(tAmount),
        );

        await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        verify(mockNetworkInfo.isConnected);
      });

      test(
          'should try to connect to the internet when retrieving trivia questions',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        verify(mockNetworkInfo.isConnected);
      });
    });

    group('If device is connected to the internet', () {
      test(
          'should retrieve questions from data source when the device is connected to the internet',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer(
          (_) async =>
              GetQuestionsFixture.getDummyTriviaQuestionModels(tAmount),
        );

        final result = await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        verify(mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            ));
        expect(result, isA<Right<Failure, List<QuestionEntity>>>());
        final questions = result.fold((l) => [], (r) => r);
        expect(questions.isNotEmpty, true);
      });

      test(
          'should cache questions in the local storage when the device is connected to the internet',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer((_) async => dummyQuestionModels);
        when(() => mockLocalDataSource.saveQuestionsToLocalStorage(
              questions: dummyQuestionModels,
            )).thenAnswer((_) async => true);

        final result = await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );
        final questions =
            result.fold<List<QuestionEntity>>((l) => [], (r) => r);
        final cacheSuccess =
            await repository.saveQuestionsToLocalStorage(questions);

        expect(result, isA<Right<Failure, List<QuestionEntity>>>());
        expect(cacheSuccess, isA<Right<Failure, bool>>());
        expect(questions.isNotEmpty, true);
        verify(mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            ));
      });

      test(
          'should return a LocalStorageFailure when the repository in not able to save questions to the local storage',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer((_) async => dummyQuestionModels);
        when(() => mockLocalDataSource.saveQuestionsToLocalStorage(
              questions: dummyQuestionModels,
            )).thenThrow(LocalStorageException());

        final result = await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );
        final questions =
            result.fold<List<QuestionEntity>>((l) => [], (r) => r);
        final cacheSuccess =
            await repository.saveQuestionsToLocalStorage(questions);

        expect(result, isA<Right<Failure, List<QuestionEntity>>>());
        expect(cacheSuccess, isA<Left<Failure, bool>>());
        verify(mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getQuestionsFromApi(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            ));
        verify(() => mockLocalDataSource.saveQuestionsToLocalStorage(
            questions: dummyQuestionModels));
      });
    });

    group('If device is not connected to the internet', () {
      test(
          'should return ServerFailure when the device is not connected to the internet',
          () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await repository.getQuestionsFromRemote(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        verify(mockNetworkInfo.isConnected);
        expect(result, isA<Left<Failure, List<QuestionEntity>>>());
      });

      test(
          'should return a List of QuestionEntity from local storage when there\'s questions saved in the local storage',
          () async {
        when(() => mockLocalDataSource.getQuestionsFromLocalStorage(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer(
          (_) async =>
              GetQuestionsFixture.getDummyTriviaQuestionModels(tAmount),
        );

        final result = await repository.getQuestionsFromLocalStorage(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        expect(result, isA<Right<Failure, List<QuestionEntity>>>());
        final questions = result.fold((l) => [], (r) => r);
        expect(questions.isNotEmpty, true);
        verify(() => mockLocalDataSource.getQuestionsFromLocalStorage(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            ));
      });

      test(
          'should return a failure when the repository cannot get questions from the local storage',
          () async {
        when(() => mockLocalDataSource.getQuestionsFromLocalStorage(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenThrow(LocalStorageException());

        final result = await repository.getQuestionsFromLocalStorage(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        );

        expect(result, isA<Left<Failure, List<QuestionEntity>>>());
        verify(() => mockLocalDataSource.getQuestionsFromLocalStorage(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            ));
      });
    });
  });
}
