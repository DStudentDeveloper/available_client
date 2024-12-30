import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/repos/booking_repo.dart';

class CancelBooking implements Usecase<void, String> {
  const CancelBooking(this._repo);

  final BookingRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.cancelBooking(params);
}
