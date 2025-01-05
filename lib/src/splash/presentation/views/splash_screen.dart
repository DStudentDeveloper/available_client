import 'dart:async';

import 'package:available/core/res/colours.dart';
import 'package:available/src/auth/presentation/app/adapter/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser?.email != null) {
      context.read<AuthCubit>().login(
            email: FirebaseAuth.instance.currentUser!.email!,
            password: 'password',
          );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (_, state) async {
        if (state is AuthError) {
          final navigator = Navigator.of(context);
          await FirebaseAuth.instance.signOut();
          unawaited(navigator.pushReplacementNamed('/'));
        } else if (state is LoggedIn) {
          unawaited(Navigator.of(context).pushReplacementNamed('/'));
        }
      },
      builder: (_, state) => const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SpinKitRotatingPlain(color: Colours.primary)),
    );
  }
}
