import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/domain/repos/room_repo.dart';

class GetRoomById implements Usecase<Room, String> {
  const GetRoomById(this._repo);

  final RoomRepo _repo;

  @override
  ResultFuture<Room> call(String params) => _repo.getRoomById(params);
}
