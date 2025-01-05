import 'package:available/core/errors/exception.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/data/datasources/auth_local_data_source.dart';
import 'package:available/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';
import 'package:available/src/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  ResultFuture<void> initiatePasswordReset(String email) async {
    try {
      await _remoteDataSource.initiatePasswordReset(email);
      return const Right(null);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<CourseRepresentative> login({
    required String email,
    required String password,
    required bool invalidateCache,
  }) async {
    try {
      if (!invalidateCache) {
        final localUser = await _localDataSource.getUser(email);
        if (localUser != null) return Right(localUser);
      }

      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    } on CacheException catch (exception) {
      return Left(CacheFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<void> resetPassword({
    required String code,
    required String password,
  }) async {
    try {
      await _remoteDataSource.resetPassword(code: code, password: password);
      return const Right(null);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<String> verifyPasswordResetCode(String code) async {
    try {
      final email = await _remoteDataSource.verifyPasswordResetCode(code);
      return Right(email);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
