import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.category,
    required super.type,
    required super.difficulty,
    required super.question,
    required super.correctAnswer,
    required super.wrongAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final incorrectAnswers = json['incorrect_answers'] as List;
    final stringfiedIncorrectAnswers =
        incorrectAnswers.map((e) => e.toString());

    return QuestionModel(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      wrongAnswers: stringfiedIncorrectAnswers.toList(),
    );
  }
}
