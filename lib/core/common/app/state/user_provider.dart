import 'package:available/src/auth/domain/entities/course_representative.dart';

class UserProvider {
  UserProvider._internal();

  static final UserProvider instance = UserProvider._internal();

  CourseRepresentative? _currentUser;

  CourseRepresentative? get user => _currentUser;

  void setUser(CourseRepresentative user) {
    if (_currentUser != user) _currentUser = user;
  }
}
