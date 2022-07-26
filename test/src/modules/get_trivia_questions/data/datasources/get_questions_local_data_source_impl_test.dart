import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/hive/hive_question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/shared/constants/hive_constants.dart';

import '../../fixtures/get_question_fixture.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late final MockHiveInterface mockHiveInterface;
  late final MockBox<List<HiveQuestionModel>> mockBox;
  late final GetQuestionsLocalDataSourceImpl localDataSource;
  final tQuestionEntity = GetQuestionsFixture.getDummyTriviaQuestion();
  final tHiveQuestionModel =
      GetQuestionsFixture.getDummyTriviaQuestionHiveModel();
  const tQuestionsAmount = 3;
  const String tCategory = 'Entertainment: Video Games';
  const String tDifficulty = 'Medium';

  setUpAll(() async {
    final path = '${Directory.current.path}/test/favorites';
    mockHiveInterface = MockHiveInterface();
    mockHiveInterface.init(path);

    mockBox = MockBox<List<HiveQuestionModel>>();
    localDataSource = GetQuestionsLocalDataSourceImpl(
      hiveInterface: mockHiveInterface,
    );
  });

  // tearDownAll(() async {
  //   print(mockHiveInterface.close());
  //   await mockHiveInterface.close();
  //   await mockHiveInterface.deleteFromDisk();
  // });

  group('Retrieve questions from local storage', () {
    test(
        'should retrieve a List of QuestionModel from local storage when there are favorites saved in the local storage',
        () async {
      when(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
              HiveConstants.storedQuestionsBoxName))
          .thenAnswer((_) async => mockBox);
      when(() => mockBox.get(HiveConstants.storedQuestionskey)).thenReturn(
          GetQuestionsFixture.getDummyTriviaQuestionHiveModels(
              tQuestionsAmount));

      final result = await localDataSource.getQuestionsFromLocalStorage(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      );

      expect(result, isA<List<QuestionModel>>());
      verify(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
          HiveConstants.storedQuestionsBoxName));
      verify(() => mockBox.get(HiveConstants.storedQuestionskey));
    });

    test(
        'should throw LocalStorageException when the call to retrieve stored questions is not successful',
        () async {
      when(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
              HiveConstants.storedQuestionsBoxName))
          .thenThrow(HiveError('Forced error for testing.'));

      final call = localDataSource.getQuestionsFromLocalStorage(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      );

      await expectLater(call, throwsA(isA<LocalStorageException>()));
    });
  });

  group('Save questions to local storage', () {
    test(
        'should return true when the call to save questions to the local storage is successful',
        () async {
      when(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
              HiveConstants.storedQuestionsBoxName))
          .thenAnswer((_) async => mockBox);
      when(() => mockBox.put(any(), any())).thenAnswer((_) async => true);

      final result = await localDataSource.saveQuestionsToLocalStorage(
        questions: GetQuestionsFixture.getDummyTriviaQuestionHiveModels(
            tQuestionsAmount),
        category: tCategory,
        difficulty: tDifficulty,
      );

      expect(result, true);
      verify(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
          HiveConstants.storedQuestionsBoxName));
      verify(() => mockBox.put(any(), any()));
    });

    test(
        'should throw a LocalStorageException when the call to save questions to local storage is not successful',
        () async {
      when(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
              HiveConstants.storedQuestionsBoxName))
          .thenThrow(HiveError('Forced error for testing.'));

      final call = localDataSource.saveQuestionsToLocalStorage(
        questions: GetQuestionsFixture.getDummyTriviaQuestionHiveModels(
            tQuestionsAmount),
        category: tCategory,
        difficulty: tDifficulty,
      );

      await expectLater(call, throwsA(isA<LocalStorageException>()));
    });
  });

  group('Delete questions from the local storage', () {
    test(
        'should delete questions from the local storage and return them when there is questions stored',
        () async {
      when(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
              HiveConstants.storedQuestionsBoxName))
          .thenAnswer((_) async => mockBox);

      final result = await localDataSource.removeQuestionsFromLocalStorage(
        amount: tQuestionsAmount,
        category: tCategory,
        difficulty: tDifficulty,
      );

      expect(result, isA<List<QuestionModel>>());
      expect(result != null, true);
      expect(result!.isNotEmpty, true);
      verify(() => mockHiveInterface.openBox<List<HiveQuestionModel>>(
          HiveConstants.storedQuestionsBoxName));
    });
  });
}
