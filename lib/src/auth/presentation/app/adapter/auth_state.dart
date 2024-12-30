part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class LoggedIn extends AuthState {
  const LoggedIn(this.user);

  final CourseRepresentative user;

  @override
  List<Object> get props => [user];
}

final class PasswordResetEmailSent extends AuthState {
  const PasswordResetEmailSent();
}

final class PasswordResetCodeVerified extends AuthState {
  const PasswordResetCodeVerified(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class PasswordResetCompleted extends AuthState {
  const PasswordResetCompleted();
}

final class AuthError extends AuthState {
  const AuthError({required this.title, required this.message});

  AuthError.fromFailure(Failure failure)
      : this(title: failure.title, message: failure.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
