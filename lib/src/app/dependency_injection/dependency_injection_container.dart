import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_waker/src/app/environment/env.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';
import 'package:quiz_waker/src/core/network/network_info_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_local_data_source_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/datasources/get_questions_remote_data_source_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/repositories/get_questions_repository_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_questions_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/get_questions_from_api_usecase.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/get_questions_from_local_storage_usecase.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/usecases/save_questions_to_local_storage_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final serviceLocator = GetIt.instance;

Future<void> setupDependencyInjectionContainer() async {
  await _initExternalDependencies();
  _initCore();
  _initDataSources();
  _initRepositories();
  _initFeatures();
}

Future<void> _initExternalDependencies() async {
  // Hive
  final documentsPath = await getApplicationDocumentsDirectory();
  Hive.init(documentsPath.path);
  // TODO: register adapters
  // Hive.registerAdapter(HiveGameModelAdapter());

  // Shared Preferences
  serviceLocator.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());

  // Internet Connection Checker
  serviceLocator.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  // Dio
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        validateStatus: (status) {
          return status != null && status <= 402;
        },
      ),
    ),
  );
}

void _initCore() {
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: serviceLocator()));
}

void _initDataSources() {
  serviceLocator.registerLazySingleton<GetQuestionsRemoteDataSource>(
    () => GetQuestionsRemoteDataSourceImpl(),
  );
  serviceLocator.registerLazySingleton<GetQuestionsLocalDataSource>(
    () => GetQuestionsLocalDataSourceImpl(),
  );
}

void _initRepositories() {
  serviceLocator.registerLazySingleton<GetQuestionsRepository>(
    () => GetQuestionsRepositoryImpl(
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );
}

void _initFeatures() {
  serviceLocator.registerLazySingleton<GetQuestionsFromApiUseCase>(() =>
      GetQuestionsFromApiUseCase(
          getTriviaQuestionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetQuestionsFromLocalStorageUseCase>(
      () => GetQuestionsFromLocalStorageUseCase(
          getTriviaQuestionRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SaveQuestionsToLocalStorageUseCase>(() =>
      SaveQuestionsToLocalStorageUseCase(
          getTriviaQuestionRepository: serviceLocator()));
}
