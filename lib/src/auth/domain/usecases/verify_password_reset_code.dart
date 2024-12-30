import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/repos/auth_repo.dart';

class VerifyPasswordResetCode implements Usecase<String, String> {
  const VerifyPasswordResetCode(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call(String params) {
    return _repo.verifyPasswordResetCode(params);
  }
}
