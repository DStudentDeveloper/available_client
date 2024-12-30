import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/auth/domain/repos/auth_repo.dart';

class InitiatePasswordReset implements Usecase<void, String> {
  const InitiatePasswordReset(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.initiatePasswordReset(params);
}
