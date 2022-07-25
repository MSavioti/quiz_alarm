import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_trivia_question_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/use_cases/get_trivia_questions_from_api_use_case.dart';
import 'package:quiz_waker/src/shared/constants/categories_ids_constants.dart';
import 'package:quiz_waker/src/shared/constants/categories_names_constants.dart';
import 'package:quiz_waker/src/shared/constants/difficulties_names_constants.dart';
import 'package:quiz_waker/src/shared/models/question_parameters.dart';

import '../../fixtures/get_trivia_question_fixture.dart';

class MockGetTriviaQuestionRepository extends Mock
    implements GetTriviaQuestionRepository {}

void main() {
  final mockGetTriviaQuestionRepository = MockGetTriviaQuestionRepository();
  late final List<QuestionEntity> tQuestions;
  late final GetTriviaQuestionsFromApiUseCase useCase;
  const int tQuestionsAmount = 3;

  setUpAll(() {
    useCase = GetTriviaQuestionsFromApiUseCase(
      getTriviaQuestionRepository: mockGetTriviaQuestionRepository,
    );
    tQuestions =
        GetTriviaQuestionFixture.getDummyTriviaQuestions(tQuestionsAmount);
  });

  test(
      'should get a valid List of QuestionEntity with desired params when needed from the repository',
      () async {
    when(() => mockGetTriviaQuestionRepository.getQuestionsFromRemote(
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

    for (var question in questions) {
      assert(question.category == CategoriesNamesConstants.generalKnowledge);
      assert(question.difficulty == DifficultiesNamesConstants.easy);
    }
  });
}
