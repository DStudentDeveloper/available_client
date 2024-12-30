import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/helpers/database_helper.dart';
import 'package:available/core/utils/core_constants.dart';
import 'package:available/src/auth/data/models/course_representative_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveUser(CourseRepresentativeModel user);

  Future<CourseRepresentativeModel?> getUser(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  @override
  Future<CourseRepresentativeModel?> getUser(String email) async {
    try {
      final user = await _databaseHelper.get<CourseRepresentativeModel>(
        table: CoreConstants.userTable,
        key: CoreConstants.userPrimaryKey,
        value: email,
      );
      return user;
    } catch (e, s) {
      return DataSourceHelper.handleLocalSourceException<
          CourseRepresentativeModel?>(
        e,
        repositoryName: 'AuthLocalDataSourceImpl',
        methodName: 'getUser',
        stackTrace: s,
        throwException: false,
      );
    }
  }

  @override
  Future<void> saveUser(CourseRepresentativeModel user) async {
    try {
      await _databaseHelper.insert(user);
    } catch (e, s) {
      return DataSourceHelper.handleLocalSourceException<void>(
        e,
        repositoryName: 'AuthLocalDataSourceImpl',
        methodName: 'saveUser',
        stackTrace: s,
      );
    }
  }
}
