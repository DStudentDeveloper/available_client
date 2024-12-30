import 'package:available/core/common/app/state/user_provider.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';
import 'package:available/src/auth/domain/usecases/initiate_password_reset.dart';
import 'package:available/src/auth/domain/usecases/login.dart';
import 'package:available/src/auth/domain/usecases/reset_password.dart';
import 'package:available/src/auth/domain/usecases/verify_password_reset_code.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required Login login,
    required InitiatePasswordReset initiatePasswordReset,
    required VerifyPasswordResetCode verifyPasswordResetCode,
    required ResetPassword resetPassword,
    required UserProvider userProvider,
  })  : _login = login,
        _initiatePasswordReset = initiatePasswordReset,
        _verifyPasswordResetCode = verifyPasswordResetCode,
        _resetPassword = resetPassword,
        _userProvider = userProvider,
        super(const AuthInitial());

  final Login _login;
  final InitiatePasswordReset _initiatePasswordReset;
  final VerifyPasswordResetCode _verifyPasswordResetCode;
  final ResetPassword _resetPassword;
  final UserProvider _userProvider;

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await _login(LoginParams(email: email, password: password));

    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (user) {
        _userProvider.setUser(user);
        emit(LoggedIn(user));
      },
    );
  }

  Future<void> initiatePasswordReset(String email) async {
    emit(const AuthLoading());

    final result = await _initiatePasswordReset(email);

    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) => emit(const PasswordResetEmailSent()),
    );
  }

  Future<void> verifyPasswordResetCode(String code) async {
    emit(const AuthLoading());

    final result = await _verifyPasswordResetCode(code);

    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (email) => emit(PasswordResetCodeVerified(email)),
    );
  }

  Future<void> resetPassword({
    required String code,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await _resetPassword(
      ResetPasswordParams(code: code, password: password),
    );

    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) => emit(const PasswordResetCompleted()),
    );
  }
}
