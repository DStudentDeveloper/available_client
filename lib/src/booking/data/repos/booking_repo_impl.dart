import 'package:available/core/errors/exception.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/data/datasources/booking_remote_data_src.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/domain/repos/booking_repo.dart';
import 'package:dartz/dartz.dart';

class BookingRepoImpl implements BookingRepo {
  const BookingRepoImpl(this._remoteDataSource);

  final BookingRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<Booking> bookRoom(Booking booking) async {
    try {
      final result = await _remoteDataSource.bookRoom(booking);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<void> cancelBooking(String bookingId) async {
    try {
      await _remoteDataSource.cancelBooking(bookingId);
      return const Right(null);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }

  @override
  ResultFuture<Booking> updateBooking(Booking booking) async {
    try {
      final result = await _remoteDataSource.updateBooking(booking);
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure.fromException(exception));
    }
  }
}
