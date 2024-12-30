import 'package:available/core/interfaces/usecase.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/domain/repos/block_repo.dart';
import 'package:available/src/room/domain/entities/room.dart';

class GetBlockRooms implements Usecase<List<Room>, String> {
  const GetBlockRooms(this._repo);

  final BlockRepo _repo;

  @override
  ResultFuture<List<Room>> call(String params) => _repo.getBlockRooms(params);
}
