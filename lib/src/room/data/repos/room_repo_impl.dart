import 'package:available/core/errors/exception.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/data/datasources/room_remote_data_src.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/domain/repos/room_repo.dart';
import 'package:dartz/dartz.dart';

class RoomRepoImpl implements RoomRepo {
  const RoomRepoImpl(this._remoteDataSource);

  final RoomRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Room>> getAllRooms() async {
    try {
      final result = await _remoteDataSource.getAllRooms();
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<List<Booking>> getRoomBookings(String roomId) async {
    try {
      final result = await _remoteDataSource.getRoomBookings(roomId);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<Room> getRoomById(String roomId) async {
    try {
      final result = await _remoteDataSource.getRoomById(roomId);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
