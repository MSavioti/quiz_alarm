import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_waker/src/app/environment/env.dart';
import 'package:quiz_waker/src/core/network/network_info.dart';
import 'package:quiz_waker/src/core/network/network_info_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/data/repositories/get_trivia_questions_repository_impl.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/repositories/get_trivia_question_repository.dart';
import 'package:quiz_waker/src/modules/get_trivia_questions/domain/use_cases/get_trivia_questions_use_case.dart';
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

void _initDataSources() {}

void _initRepositories() {
  serviceLocator.registerLazySingleton<GetTriviaQuestionRepository>(
      () => GetTriviaQuestionsRepositoryImpl());
}

void _initFeatures() {
  serviceLocator.registerLazySingleton<GetTriviaQuestionsUseCase>(() =>
      GetTriviaQuestionsUseCase(getTriviaQuestionRepository: serviceLocator()));
}
