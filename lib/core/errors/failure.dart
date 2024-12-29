import 'package:available/core/errors/exception.dart';
import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message, required this.title});

  final String message;
  final String title;

  @override
  List<Object> get props => [message, title];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.title});

  ServerFailure.fromException(ServerException exception)
      : this(
          message: exception.message,
          title: exception.title,
        );
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, required super.title});

  CacheFailure.fromException(CacheException exception)
      : this(
          message: exception.message,
          title: exception.title,
        );
}
