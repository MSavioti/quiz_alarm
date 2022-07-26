import 'package:hive/hive.dart';
import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/hive/hive_question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/shared/constants/hive_constants.dart';

class GetQuestionsLocalDataSourceImpl implements GetQuestionsLocalDataSource {
  final HiveInterface hiveInterface;

  GetQuestionsLocalDataSourceImpl({required this.hiveInterface});

  @override
  Future<List<QuestionModel>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      final questionsBox = await _getBox();
      final storedQuestions = questionsBox.get(
            HiveConstants.storedQuestionskey(
              category: category,
              difficulty: difficulty,
            ),
          ) ??
          [];

      const rangeStart = 0;
      final rangeEnd = amount.clamp(rangeStart, storedQuestions.length);
      final targetQuestions =
          storedQuestions.getRange(rangeStart, rangeEnd).toList();

      return targetQuestions;
    } on HiveError {
      throw LocalStorageException();
    } catch (_) {
      throw LocalStorageException();
    }
  }

  @override
  Future<List<QuestionModel>> getAllQuestionsFromLocalStorage({
    required String category,
    required String difficulty,
  }) async {
    try {
      final questionsBox = await _getBox();
      final storedQuestions = questionsBox.get(
            HiveConstants.storedQuestionskey(
              category: category,
              difficulty: difficulty,
            ),
          ) ??
          [];
      return storedQuestions;
    } on HiveError {
      throw LocalStorageException();
    } catch (_) {
      throw LocalStorageException();
    }
  }

  @override
  Future<bool> saveQuestionsToLocalStorage({
    required List<QuestionEntity> questions,
    required String category,
    required String difficulty,
  }) async {
    try {
      final questionsBox = await _getBox();
      final hiveQuestions = questions.map<HiveQuestionModel>(
          (e) => HiveQuestionModel.fromQuestionEntity(e));
      final key = HiveConstants.storedQuestionskey(
        category: category,
        difficulty: difficulty,
      );
      await questionsBox.put(key, hiveQuestions.toList());
      return true;
    } on HiveError {
      throw LocalStorageException();
    } catch (_) {
      throw LocalStorageException();
    }
  }

  Future<Box<List<HiveQuestionModel>>> _getBox() {
    return hiveInterface
        .openBox<List<HiveQuestionModel>>(HiveConstants.storedQuestionsBoxName);
  }

  @override
  Future<List<QuestionModel>?> removeQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      final targetQuestions = await getQuestionsFromLocalStorage(
        amount: amount,
        category: category,
        difficulty: difficulty,
      );
      final allQuestions = await getAllQuestionsFromLocalStorage(
          category: category, difficulty: difficulty);

      if (allQuestions.length <= targetQuestions.length) {
        await saveQuestionsToLocalStorage(
          questions: [],
          category: category,
          difficulty: difficulty,
        );
      } else {
        final start = targetQuestions.length;
        final end = allQuestions.length;
        final remainingQuestions = allQuestions.getRange(start, end).toList();
        await saveQuestionsToLocalStorage(
          questions: remainingQuestions,
          category: category,
          difficulty: difficulty,
        );
      }

      return targetQuestions;
    } on HiveError {
      throw LocalStorageException();
    } catch (e) {
      throw LocalStorageException();
    }
  }
}
