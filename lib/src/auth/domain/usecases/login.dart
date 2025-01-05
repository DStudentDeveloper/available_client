import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';
import 'package:available/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class Login implements Usecase<CourseRepresentative, LoginParams> {
  const Login(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<CourseRepresentative> call(LoginParams params) {
    return _repo.login(
      email: params.email,
      password: params.password,
      invalidateCache: params.invalidateCache,
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
    required this.invalidateCache,
  });

  const LoginParams.empty()
      : this(
          email: 'Test String',
          password: 'Test String',
          invalidateCache: false,
        );

  final String email;
  final String password;
  final bool invalidateCache;

  @override
  List<Object?> get props => [email, password, invalidateCache];
}
