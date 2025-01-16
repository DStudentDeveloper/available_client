part of 'router.dart';

Route<dynamic> routerConfig(RouteSettings settings) {
  log(name: 'Router', 'Route: ${settings.name}');

  Widget page;

  if (settings.name == '/') {
    if (CacheHelper.instance.isFirstTimer) {
      page = BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const OnBoardingScreen(),
      );
    } else if (FirebaseAuth.instance.currentUser == null) {
      return routerConfig(const RouteSettings(name: LoginScreen.path));
    } else if (UserProvider.instance.user == null) {
      page = BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const SplashScreen(),
      );
    } else {
      page = HomeScreen(user: UserProvider.instance.user!);
    }
  } else if (settings.name == LoginScreen.path) {
    page = BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const LoginScreen(),
    );
  } else if (settings.name == ForgotPasswordScreen.path) {
    page = BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const ForgotPasswordScreen(),
    );
  } else if (settings.name == PasswordResetConfirmationScreen.path) {
    page = BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: PasswordResetConfirmationScreen(
        email: settings.arguments! as String,
      ),
    );
  } else if (settings.name == BlocksScreen.path) {
    page = BlocProvider(
      create: (_) => sl<BlockCubit>(),
      child: const BlocksScreen(),
    );
  } else if (settings.name == RoomsScreen.path) {
    final args = settings.arguments! as DataMap;
    page = BlocProvider(
      create: (_) => sl<BlockCubit>(),
      child: RoomsScreen(
        block: args['block'] as Block,
        index: args['index'] as int,
      ),
    );
  } else if (settings.name == RoomConfirmationScreen.path) {
    page = RoomConfirmationScreen(settings.arguments! as Room);
  } else if (settings.name == BookRoomScreen.path) {
    page = BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: BookRoomScreen(settings.arguments! as Room),
    );
  } else if (settings.name == BookingConfirmedScreen.path) {
    final args = settings.arguments! as DataMap;
    page = BookingConfirmedScreen(
      room: args['room'] as Room,
      startTime: args['startTime'] as TimeOfDay,
      endTime: args['endTime'] as TimeOfDay,
    );
  } else if (settings.name == BookingsScreen.path) {
    page = BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: BookingsScreen(
        highlightedBookingId: settings.arguments as String?,
      ),
    );
  } else if (settings.name == UpdateBookingScreen.path) {
    page = BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: UpdateBookingScreen(settings.arguments! as Booking),
    );
  } else if (settings.name == LeaveFeedbackScreen.path) {
    page = BlocProvider(
      create: (_) => sl<FeedbackCubit>(),
      child: const LeaveFeedbackScreen(),
    );
  } else if (settings.name == FeedbackConfirmedScreen.path) {
    page = FeedbackConfirmedScreen(feedback: settings.arguments! as Feedback);
  } else {
    log(name: 'Router', 'No route defined for ${settings.name}');
    page = const Scaffold(body: Center(child: Text('404')));
  }
  if (settings.name == UpdateBookingScreen.path) {
    return MaterialPageRoute<bool>(builder: (_) => page, settings: settings);
  }
  return MaterialPageRoute(builder: (_) => page, settings: settings);
}
