import 'package:hive/hive.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

part 'hive_question_model.g.dart';

@HiveType(typeId: 0)
class HiveQuestionModel implements QuestionModel {
  @override
  @HiveField(0)
  final String category;

  @override
  @HiveField(1)
  final String correctAnswer;

  @override
  @HiveField(2)
  final String difficulty;

  @override
  @HiveField(3)
  final String question;

  @override
  @HiveField(4)
  final String type;

  @override
  @HiveField(5)
  final List<String> wrongAnswers;

  HiveQuestionModel({
    required this.category,
    required this.correctAnswer,
    required this.difficulty,
    required this.question,
    required this.type,
    required this.wrongAnswers,
  });

  factory HiveQuestionModel.fromQuestionEntity(QuestionEntity question) {
    return HiveQuestionModel(
      category: question.category,
      correctAnswer: question.correctAnswer,
      difficulty: question.difficulty,
      question: question.question,
      type: question.type,
      wrongAnswers: question.wrongAnswers,
    );
  }
}
