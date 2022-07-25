import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

import '../../fixtures/get_question_fixture.dart';

void main() {
  late final QuestionEntity tQuestion;

  test('should have a valid QuestionModel when building from a JSON', () {
    final jsonContent = GetQuestionsFixture.getDummyTriviaQuestionJson();
    tQuestion = QuestionModel.fromJson(jsonContent);
    assert(tQuestion.category.isNotEmpty);
    assert(tQuestion.correctAnswer.isNotEmpty);
    assert(tQuestion.difficulty.isNotEmpty);
    assert(tQuestion.question.isNotEmpty);
    assert(tQuestion.type.isNotEmpty);
    assert(tQuestion.wrongAnswers.isNotEmpty);
  });
}
