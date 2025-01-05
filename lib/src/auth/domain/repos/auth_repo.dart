import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';

abstract interface class AuthRepo {
  ResultFuture<CourseRepresentative> login({
    required String email,
    required String password,
    required bool invalidateCache,
  });

  ResultFuture<void> initiatePasswordReset(String email);

  ResultFuture<String> verifyPasswordResetCode(String code);

  ResultFuture<void> resetPassword({
    required String code,
    required String password,
  });
}
