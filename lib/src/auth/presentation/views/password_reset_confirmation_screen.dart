import 'package:available/core/extensions/context_extensions.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/lottie_files.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class PasswordResetConfirmationScreen extends StatelessWidget {
  const PasswordResetConfirmationScreen({required this.email, super.key});

  final String email;

  static const path = '/password-reset-confirmation';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) {
        if (state case AuthError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        }
      },
      builder: (_, state) => PasswordResetConfirmationView(
        email: email,
        state: state,
        onDone: Navigator.of(context).pop,
        onResendEmail: (email) {
          context.read<AuthCubit>().initiatePasswordReset(email);
        },
      ),
    );
  }
}

class PasswordResetConfirmationView extends StatelessWidget {
  const PasswordResetConfirmationView({
    required this.email,
    required this.onDone,
    required this.onResendEmail,
    required this.state,
    super.key,
  });

  final AuthState state;
  final String email;
  final VoidCallback onDone;
  final void Function(String email) onResendEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state is AuthLoading
            ? const SpinKitRotatingPlain(color: Colours.primary)
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(LottieFiles.mail),
                        Text(
                          email,
                          style: context.theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Password Reset Email Sent',
                          style: context.theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'We have sent a secure link to safely reset '
                          'your password '
                          'to the email address provided.',
                          style: context.theme.textTheme.labelMedium?.copyWith(
                            color: context.theme.colorScheme.onSurface
                                .withValues(alpha: .6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: onDone,
                          child: const Text('Done'),
                        ),
                        TextButton(
                          onPressed: () => onResendEmail(email),
                          child: const Text('Resend Email'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
