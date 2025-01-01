part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initMemoryCache();
  await _initSocket();
  await _initAuth();
  await _initBlock();
  await _initBooking();
  await _initRoom();
}

Future<void> _initRoom() async {
  sl
    ..registerFactory(
      () => RoomCubit(
        getAllRooms: sl(),
        getRoomBookings: sl(),
        getRoomById: sl(),
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
      ),
    )
    ..registerLazySingleton(() => BookRoom(sl()))
    ..registerLazySingleton(() => CancelBooking(sl()))
    ..registerLazySingleton(() => UpdateBooking(sl()))
    ..registerLazySingleton<BookingRepo>(() => BookingRepoImpl(sl()))
    ..registerLazySingleton<BookingRemoteDataSrc>(
      () => BookingRemoteDataSrcImpl(httpClient: sl(), authClient: sl()),
    );
}

Future<void> _initBlock() async {
  sl
    ..registerFactory(
      () => BlockCubit(
        getAllBlocks: sl(),
        getBlockById: sl(),
        getBlockRooms: sl(),
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
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(auth: sl(), firestore: sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance);
}

Future<void> _initSocket() async {
  sl
    ..registerLazySingleton(AvailabilityController.new)
    ..registerSingleton<SocketService>(
      SocketService(
        url: 'ws://192.168.8.2:3030',
        availabilityController: sl(),
      ),
    );
}

Future<void> _initMemoryCache() async {
  final databaseHelper = DatabaseHelper();
  final dbPath = await getDatabasesPath();
  await databaseHelper.open(path.join(dbPath, 'available.db'));

  sl.registerLazySingleton<DatabaseHelper>(() => databaseHelper);
}
