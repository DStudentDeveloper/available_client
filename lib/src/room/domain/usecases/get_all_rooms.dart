import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/domain/repos/room_repo.dart';

class GetAllRooms implements Usecase<List<Room>, NoParams> {
  const GetAllRooms(this._repo);

  final RoomRepo _repo;

  @override
  ResultFuture<List<Room>> call(NoParams _) => _repo.getAllRooms();
}
