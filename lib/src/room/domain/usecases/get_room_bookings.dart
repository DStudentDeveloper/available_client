import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/repos/room_repo.dart';

class GetRoomBookings implements Usecase<void, String> {
  const GetRoomBookings(this._repo);

  final RoomRepo _repo;

  @override
  ResultFuture<List<Booking>> call(String params) =>
      _repo.getRoomBookings(params);
}
