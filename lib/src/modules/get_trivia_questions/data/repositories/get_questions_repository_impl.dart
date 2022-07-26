import 'package:quiz_waker/src/core/error/exception.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/entities/question_entity.dart';
import 'package:quiz_waker/src/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';

class GetQuestionsRepositoryImpl implements GetQuestionsRepository {
  final GetQuestionsRemoteDataSource remoteDataSource;
  final GetQuestionsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const GetQuestionsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsFromRemote({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      await _checkConnection();

      final questions = await remoteDataSource.getQuestionsFromApi(
        amount: amount,
        category: category,
        difficulty: difficulty,
      );

      return Right(questions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsFromLocalStorage({
    required int amount,
    required String category,
    required String difficulty,
  }) async {
    try {
      final questions = await localDataSource.getQuestionsFromLocalStorage(
        amount: amount,
        category: category,
        difficulty: difficulty,
      );

      return Right(questions);
    } on LocalStorageException {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<LocalStorageFailure, bool>> saveQuestionsToLocalStorage(
    List<QuestionEntity> questions,
    String category,
    String difficulty,
  ) async {
    try {
      final result = await localDataSource.saveQuestionsToLocalStorage(
        questions: questions,
        category: category,
        difficulty: difficulty,
      );
      return Right(result);
    } on LocalStorageException {
      return Left(LocalStorageFailure());
    }
  }

  Future<bool> _checkConnection() async {
    final isConnected = await networkInfo.isConnected();

    if (!isConnected) {
      throw ServerException();
    }

    return isConnected;
  }
}
