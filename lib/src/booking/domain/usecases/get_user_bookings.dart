import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/domain/repos/booking_repo.dart';

class GetUserBookings implements Usecase<List<Booking>, String> {
  const GetUserBookings(this._repo);

  final BookingRepo _repo;

  @override
  ResultFuture<List<Booking>> call(String params) =>
      _repo.getUserBookings(params);
}
