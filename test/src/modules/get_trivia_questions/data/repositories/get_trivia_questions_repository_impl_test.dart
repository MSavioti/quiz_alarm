import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_trivia_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_trivia_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/repositories/get_trivia_questions_repository_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

import '../../fixtures/get_trivia_question_fixture.dart';

class MockGetTriviaQuestionsRemoteDataSource extends Mock
    implements GetTriviaQuestionsRemoteDataSource {}

class MockGetTriviaQuestionsLocalDataSource extends Mock
    implements GetTriviaQuestionsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late final MockNetworkInfo mockNetworkInfo;
  late final GetTriviaQuestionsRepositoryImpl repository;
  late final MockGetTriviaQuestionsRemoteDataSource mockRemoteDataSource;
  late final MockGetTriviaQuestionsLocalDataSource mockLocalDataSource;
  late final int tAmount;
  late final String tCategory;
  late final String tDifficulty;
  late final List<QuestionModel> dummyQuestionModels;

  setUpAll(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockGetTriviaQuestionsRemoteDataSource();
    mockLocalDataSource = MockGetTriviaQuestionsLocalDataSource();
    repository = GetTriviaQuestionsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    tAmount = 3;
    tCategory = 'Entertainment: Video Games';
    tDifficulty = 'Medium';
    dummyQuestionModels =
        GetTriviaQuestionFixture.getDummyTriviaQuestionModels(tAmount);
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
              GetTriviaQuestionFixture.getDummyTriviaQuestionModels(tAmount),
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
              GetTriviaQuestionFixture.getDummyTriviaQuestionModels(tAmount),
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
        reset(mockLocalDataSource);
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
          'should return a List of QuestionEntity from local storage when theres questions saved in the local storage',
          () async {
        when(() => mockLocalDataSource.getQuestionsFromLocalStorage(
              amount: tAmount,
              category: tCategory,
              difficulty: tDifficulty,
            )).thenAnswer(
          (_) async =>
              GetTriviaQuestionFixture.getDummyTriviaQuestionModels(tAmount),
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
    });
  });
}
