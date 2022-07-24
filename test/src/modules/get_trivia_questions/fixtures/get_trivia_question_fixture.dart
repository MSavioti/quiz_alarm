import 'dart:convert';
import 'dart:io';

import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

class GetTriviaQuestionFixture {
  static Map<String, dynamic> getDummyTriviaQuestionJson() {
    final fixtureFile = File(
        'test/src/modules/get_trivia_questions/fixtures/trivia_question.json');
    final stringfiedJson = fixtureFile.readAsStringSync();
    final jsonContent = json.decode(stringfiedJson);
    return jsonContent;
  }

  static QuestionEntity getDummyTriviaQuestion() {
    final jsonContent = getDummyTriviaQuestionJson();
    final question = QuestionModel.fromJson(jsonContent);
    return question;
  }

  static List<QuestionEntity> getDummyTriviaQuestions(int count) {
    final dummyQuestion = getDummyTriviaQuestion();
    final questions =
        List<QuestionEntity>.generate(count, (_) => dummyQuestion);
    return questions;
  }

  static QuestionModel getDummyTriviaQuestionModel() {
    final jsonContent = getDummyTriviaQuestionJson();
    final question = QuestionModel.fromJson(jsonContent);
    return question;
  }

  static List<QuestionModel> getDummyTriviaQuestionModels(int count) {
    final dummyQuestion = getDummyTriviaQuestionModel();
    final questions = List<QuestionModel>.generate(count, (_) => dummyQuestion);
    return questions;
  }
}
