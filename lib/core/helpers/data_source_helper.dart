import 'dart:developer';

import 'package:available/core/errors/exception.dart';
import 'package:available/core/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class DataSourceHelper {
  const DataSourceHelper();

  static Future<void> authorizeUser(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user == null) {
      log(
        'Error occurred: Unauthorized user access',
        name: 'NetworkUtils.authorizeUser',
        level: 1200,
      );

      throw const ServerException(
        message: 'Unauthorized user access',
        title: 'UnauthorizedError',
      );
    }
  }

  static T handleRemoteSourceException<T>(
    Object e, {
    required String repositoryName,
    required String methodName,
    String? errorMessage,
    String? statusCode,
    StackTrace? stackTrace,
  }) {
    log(
      'Error Occurred: ${statusCode ?? 'UNKNOWN'}',
      name: '$repositoryName.$methodName',
      error: e,
      stackTrace: stackTrace ?? StackTrace.current,
      level: 1200,
    );
    throw ServerException(
      message: errorMessage ?? 'Something went wrong',
      title: statusCode ?? '${methodName.snakeCase.toUpperCase()}UNKNOWN',
    );
  }

  static Future<T> handleLocalSourceException<T>(
    Object e, {
    required String repositoryName,
    required String methodName,
    String? errorMessage,
    String? statusCode,
    StackTrace? stackTrace,
    bool throwException = true,
  }) {
    log(
      'Error Occurred',
      name: '$repositoryName.$methodName',
      error: e,
      stackTrace: stackTrace ?? StackTrace.current,
      level: 1200,
    );
    if (throwException) {
      throw CacheException(
        message: errorMessage ?? 'Something went wrong',
        title: statusCode ?? '${methodName.snakeCase.toUpperCase()}UNKNOWN',
      );
    }
    return Future<T>.value();
  }
}
