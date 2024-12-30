import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/domain/repos/booking_repo.dart';

class UpdateBooking implements Usecase<Booking, Booking> {
  const UpdateBooking(this._repo);

  final BookingRepo _repo;

  @override
  ResultFuture<Booking> call(Booking params) => _repo.updateBooking(params);
}
