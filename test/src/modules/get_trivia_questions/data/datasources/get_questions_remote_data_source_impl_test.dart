import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_waker/src/app/environment/env.dart';
import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/models/question_model.dart';

import '../../fixtures/get_question_fixture.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  const tAmount = 3;
  const tCategory = 'Entertainment: Video Games';
  const tDifficulty = 'Medium';
  final GetQuestionsRemoteDataSourceImpl dataSource =
      GetQuestionsRemoteDataSourceImpl(client: dio);

  group('Remote data source', () {
    test(
        'should return a List of QuestionModel when the response status code is 200',
        () async {
      dioAdapter.onGet(
        Env.baseUrl,
        queryParameters: Env.questionParameters(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        ),
        (server) => server.reply(200, GetQuestionsFixture.getServerResponse()),
      );

      dio.httpClientAdapter = dioAdapter;

      final result = await dataSource.getQuestionsFromApi(
          amount: tAmount, category: tCategory, difficulty: tDifficulty);
      expect(result, isA<List<QuestionModel>>());
    });

    test('should throw a ServerException when the response code is not 200',
        () async {
      dioAdapter.onGet(
        Env.baseUrl,
        queryParameters: Env.questionParameters(
          amount: tAmount,
          category: tCategory,
          difficulty: tDifficulty,
        ),
        (server) => server.reply(500, GetQuestionsFixture.getServerResponse()),
      );

      dio.httpClientAdapter = dioAdapter;

      final function = dataSource.getQuestionsFromApi(
          amount: tAmount, category: tCategory, difficulty: tDifficulty);
      await expectLater(function, throwsA(isA<ServerException>()));
    });
  });
}
