import 'package:dartz/dartz.dart';
import 'package:quiz_waker/src/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
