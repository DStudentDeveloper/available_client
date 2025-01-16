part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initMemoryCache();
  await _initSocket();
  await _initAuth();
  await _initBlock();
  await _initBooking();
  await _initRoom();
  await _initFeedback();
}

Future<void> _initFeedback() async {
  sl
    ..registerFactory(
      () => FeedbackCubit(leaveFeedback: sl()),
    )
    ..registerLazySingleton(() => LeaveFeedback(sl()))
    ..registerLazySingleton<FeedbackRepo>(() => FeedbackRepoImpl(sl()))
    ..registerLazySingleton<FeedbackRemoteDataSrc>(
      () => FeedbackRemoteDataSrcImpl(httpClient: sl(), authClient: sl()),
    );
}

Future<void> _initRoom() async {
  sl
    ..registerFactory(
      () => RoomCubit(
        getAllRooms: sl(),
        getRoomBookings: sl(),
        getRoomById: sl(),
        availabilityController: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAllRooms(sl()))
    ..registerLazySingleton(() => GetRoomById(sl()))
    ..registerLazySingleton(() => GetRoomBookings(sl()))
    ..registerLazySingleton<RoomRepo>(() => RoomRepoImpl(sl()))
    ..registerLazySingleton<RoomRemoteDataSrc>(
      () => RoomRemoteDataSrcImpl(httpClient: sl(), authClient: sl()),
    );
}

Future<void> _initBooking() async {
  sl
    ..registerFactory(
      () => BookingCubit(
        bookRoom: sl(),
        cancelBooking: sl(),
        updateBooking: sl(),
        getUserBookings: sl(),
        notificationService: sl(),
      ),
    )
    ..registerLazySingleton(() => BookRoom(sl()))
    ..registerLazySingleton(() => CancelBooking(sl()))
    ..registerLazySingleton(() => UpdateBooking(sl()))
    ..registerLazySingleton(() => GetUserBookings(sl()))
    ..registerLazySingleton<BookingRepo>(() => BookingRepoImpl(sl()))
    ..registerLazySingleton<BookingRemoteDataSrc>(
      () => BookingRemoteDataSrcImpl(httpClient: sl(), authClient: sl()),
    )
    ..registerSingleton(NotificationService());
}

Future<void> _initBlock() async {
  sl
    ..registerFactory(
      () => BlockCubit(
        getAllBlocks: sl(),
        getBlockById: sl(),
        getBlockRooms: sl(),
        availabilityController: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAllBlocks(sl()))
    ..registerLazySingleton(() => GetBlockById(sl()))
    ..registerLazySingleton(() => GetBlockRooms(sl()))
    ..registerLazySingleton<BlockRepo>(() => BlockRepoImpl(sl()))
    ..registerLazySingleton<BlockRemoteDataSrc>(
      () => BlockRemoteDataSrcImpl(httpClient: sl(), authClient: sl()),
    )
    ..registerLazySingleton(http.Client.new);
}

Future<void> _initAuth() async {
  await FirebaseAuth.instance.currentUser?.reload();
  sl
    ..registerFactory(
      () => AuthCubit(
        login: sl(),
        initiatePasswordReset: sl(),
        verifyPasswordResetCode: sl(),
        resetPassword: sl(),
        userProvider: sl(),
      ),
    )
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => InitiatePasswordReset(sl()))
    ..registerLazySingleton(() => VerifyPasswordResetCode(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(() => UserProvider.instance)
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(auth: sl(), firestore: sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(databaseHelper: sl(), authClient: sl()),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance);
}

Future<void> _initSocket() async {
  sl
    ..registerLazySingleton(AvailabilityController.new)
    ..registerSingleton<SocketService>(
      SocketService(
        url: 'ws://${NetworkConstants.authority}',
        availabilityController: sl(),
      ),
    );
}

Future<void> _initMemoryCache() async {
  final databaseHelper = DatabaseHelper();
  final dbPath = await getDatabasesPath();
  await databaseHelper.open(path.join(dbPath, 'available.db'));
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<DatabaseHelper>(() => databaseHelper)
    ..registerLazySingleton<SharedPreferences>(() => prefs);
}
