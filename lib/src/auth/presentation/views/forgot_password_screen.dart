import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/common/widgets/input_field.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:available/src/auth/presentation/views/password_reset_confirmation_screen.dart';
import 'package:available/src/auth/presentation/widgets/auth_page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const path = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) {
        if (state case AuthError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state case PasswordResetEmailSent(:final email)) {
          Navigator.of(context).pushReplacementNamed(
            PasswordResetConfirmationScreen.path,
            arguments: email,
          );
        }
      },
      builder: (_, state) => ForgotPasswordView(
        state: state,
        onContinue: (email) {
          context.read<AuthCubit>().initiatePasswordReset(email);
        },
      ),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    required this.state,
    required this.onContinue,
    super.key,
  });

  final AuthState state;
  final void Function(String email) onContinue;

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void submit() {
    if (_formKey.currentState!.validate()) {
      widget.onContinue(_emailController.text.trim());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const AuthPageTitle('Forgot Password'),
                const Gap(40),
                InputField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  label: 'Student Email',
                  onFieldSubmitted: (_) => submit(),
                ),
                const Gap(40),
                if (widget.state is AuthLoading)
                  const AdaptiveLoader()
                else
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('Continue'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
