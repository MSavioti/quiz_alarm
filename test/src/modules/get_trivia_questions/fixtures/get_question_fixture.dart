import 'dart:convert';
import 'dart:io';

import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/hive/hive_question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

class GetQuestionsFixture {
  static Map<String, dynamic> getDummyTriviaQuestionJson() {
    final fixtureFile = File(
        'test/src/modules/get_trivia_questions/fixtures/trivia_question.json');
    final stringfiedJson = fixtureFile.readAsStringSync();
    final jsonContent = json.decode(stringfiedJson);
    return jsonContent;
  }

  static String getDummyTriviaQuestionString() {
    final fixtureFile = File(
        'test/src/modules/get_trivia_questions/fixtures/trivia_question.json');
    final stringfiedJson = fixtureFile.readAsStringSync();
    return stringfiedJson;
  }

  static String getServerResponse() {
    final fixtureFile = File(
        'test/src/modules/get_trivia_questions/fixtures/example_response.json');
    final stringfiedJson = fixtureFile.readAsStringSync();
    return stringfiedJson;
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

  static QuestionModel getDummyTriviaQuestionHiveModel() {
    final jsonContent = getDummyTriviaQuestionJson();
    final questionModel = QuestionModel.fromJson(jsonContent);
    final hiveQuestion = HiveQuestionModel(
      category: questionModel.category,
      correctAnswer: questionModel.correctAnswer,
      difficulty: questionModel.difficulty,
      question: questionModel.question,
      type: questionModel.type,
      wrongAnswers: questionModel.wrongAnswers,
    );
    return hiveQuestion;
  }
}
