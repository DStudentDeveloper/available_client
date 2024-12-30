
import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class ResetPassword implements Usecase<void, ResetPasswordParams> {
  const ResetPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams params) {
    return _repo.resetPassword(code: params.code, password: params.password);
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.code,
    required this.password,
  });

  const ResetPasswordParams.empty()
      : this(code: 'Test String', password: 'Test String');

  final String code;
  final String password;

  @override
  List<Object?> get props => [code, password];
}
