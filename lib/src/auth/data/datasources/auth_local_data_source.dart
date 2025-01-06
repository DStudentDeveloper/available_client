import 'package:available/core/helpers/data_source_helper.dart';
import 'package:available/core/helpers/database_helper.dart';
import 'package:available/core/utils/core_constants.dart';
import 'package:available/src/auth/data/models/course_representative_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveUser(CourseRepresentativeModel user);

  Future<CourseRepresentativeModel?> getUser(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required DatabaseHelper databaseHelper,
    required FirebaseAuth authClient,
  })  : _databaseHelper = databaseHelper,
        _authClient = authClient;

  final DatabaseHelper _databaseHelper;
  final FirebaseAuth _authClient;

  @override
  Future<CourseRepresentativeModel?> getUser(String email) async {
    if (_authClient.currentUser == null) return null;
    try {
      final user = await _databaseHelper.get(
        table: CoreConstants.userTable,
        key: CoreConstants.userPrimaryKey,
        value: email,
      );
      if (user == null) return null;

      final localUser = CourseRepresentativeModel.fromMap(user);
      final remoteUser = _authClient.currentUser!;
      if (localUser.id != remoteUser.uid ||
          localUser.name != remoteUser.displayName) {
        return null;
      }
      return localUser;
    } on Exception catch (e, s) {
      return DataSourceHelper.handleLocalSourceException<
          CourseRepresentativeModel?>(
        e,
        repositoryName: 'AuthLocalDataSourceImpl',
        methodName: 'getUser',
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> saveUser(CourseRepresentativeModel user) async {
    try {
      await _databaseHelper.insert(user);
    } on Exception catch (e, s) {
      return DataSourceHelper.handleLocalSourceException<void>(
        e,
        repositoryName: 'AuthLocalDataSourceImpl',
        methodName: 'saveUser',
        stackTrace: s,
      );
    }
  }
}
