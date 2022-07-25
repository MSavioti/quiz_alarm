import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quiz_waker/src/app/environment/env.dart';
import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

class GetQuestionsRemoteDataSourceImpl implements GetQuestionsRemoteDataSource {
  final Dio client;

  GetQuestionsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<QuestionModel>> getQuestionsFromApi({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      final response = await client.get(
        Env.baseUrl,
        queryParameters: Env.questionParameters(
          amount: amount,
          category: category,
          difficulty: difficulty,
        ),
      );

      if (response.statusCode != 200) {
        throw ServerException();
      }

      final results = _extractQuestionResults(response);
      final questions = results.map((e) => QuestionModel.fromJson(e));
      return questions.toList();
    } on DioError {
      throw ServerException();
    }
  }

  List<dynamic> _extractQuestionResults(Response response) {
    if (response.data == null || response.data.isEmpty) {
      return [];
    }

    var data = {};

    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = response.data;
    }

    if (data['results'] == null) {
      return [];
    }

    final results = data['results'] as List;
    return results;
  }
}
