import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/common/widgets/input_field.dart';
import 'package:available/core/enums/snack_bar_type.dart';
import 'package:available/core/extensions/context_extensions.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:available/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:available/src/auth/presentation/widgets/auth_page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) {
        if (state case AuthError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state is LoggedIn) {
          CoreUtils.showSnackBar(
            context,
            title: 'Success',
            message: 'Login successful',
            type: SnackBarType.success,
          );
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      builder: (_, state) => LoginView(
        state: state,
        onLogin: ({required String email, required String password}) {
          context.read<AuthCubit>().login(
                email: email,
                password: password,
                invalidateCache: true,
              );
        },
        onForgotPassword: () {
          Navigator.of(context).pushNamed(ForgotPasswordScreen.path);
        },
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({
    required this.state,
    required this.onLogin,
    required this.onForgotPassword,
    super.key,
  });

  final AuthState state;
  final void Function({required String email, required String password})
      onLogin;
  final VoidCallback onForgotPassword;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final visibilityNotifier = ValueNotifier(false);

  void submit() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                const AuthPageTitle('Login'),
                const Gap(10),
                Text(
                  'Enter the email and password provided by your campus admin'
                  ' during your on-boarding as a course representative.',
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const Gap(40),
                InputField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  label: 'Student Email',
                ),
                const Gap(20),
                ValueListenableBuilder(
                  valueListenable: visibilityNotifier,
                  builder: (_, isVisible, __) {
                    return InputField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: !isVisible,
                      label: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => visibilityNotifier.value = !isVisible,
                      ),
                      onFieldSubmitted: (_) => submit(),
                    );
                  },
                ),
                const Gap(40),
                if (widget.state is AuthLoading)
                  const AdaptiveLoader()
                else
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('LOGIN'),
                  ),
                const Gap(20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: widget.onForgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
