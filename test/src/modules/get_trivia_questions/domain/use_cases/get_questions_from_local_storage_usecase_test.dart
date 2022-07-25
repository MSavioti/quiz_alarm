import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/get_questions_from_local_storage_usecase.dart';
import 'package:quiz_waker/src/shared/constants/categories_ids_constants.dart';
import 'package:quiz_waker/src/shared/constants/categories_names_constants.dart';
import 'package:quiz_waker/src/shared/constants/difficulties_names_constants.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';

import '../../fixtures/get_question_fixture.dart';

class MockGetQuestionsRepository extends Mock
    implements GetQuestionsRepository {}

void main() {
  final mockGetTriviaQuestionRepository = MockGetQuestionsRepository();
  late final List<QuestionEntity> tQuestions;
  late final GetQuestionsFromLocalStorageUseCase useCase;
  const int tQuestionsAmount = 3;

  setUpAll(() {
    useCase = GetQuestionsFromLocalStorageUseCase(
      getTriviaQuestionRepository: mockGetTriviaQuestionRepository,
    );
    tQuestions = GetQuestionsFixture.getDummyTriviaQuestions(tQuestionsAmount);
  });

  test(
      'should get a valid List of QuestionEntity from the local storage when needed',
      () async {
    when(() => mockGetTriviaQuestionRepository.getQuestionsFromLocalStorage(
          amount: tQuestionsAmount,
          category: CategoriesIdsConstants.generalKnowledge,
          difficulty: DifficultiesNamesConstants.easy,
        )).thenAnswer((_) async => Right(tQuestions));

    final result = await useCase(QuestionParameters(
      amount: tQuestionsAmount,
      category: CategoriesIdsConstants.generalKnowledge,
      difficulty: DifficultiesNamesConstants.easy,
    ));
    expect(result, isA<Right<Failure, List<QuestionEntity>>>());

    final questions = result.fold<List<QuestionEntity>>((l) => [], (r) => r);
    expect(questions.length, tQuestionsAmount);
    verify(() => mockGetTriviaQuestionRepository.getQuestionsFromLocalStorage(
          amount: tQuestionsAmount,
          category: CategoriesIdsConstants.generalKnowledge,
          difficulty: DifficultiesNamesConstants.easy,
        ));

    for (var question in questions) {
      assert(question.category == CategoriesNamesConstants.generalKnowledge);
      assert(question.difficulty == DifficultiesNamesConstants.easy);
    }
  });
}
