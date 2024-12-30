import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/room/domain/entities/room.dart';

abstract class BlockRepo {
  ResultFuture<List<Block>> getAllBlocks();

  ResultFuture<Block> getBlockById(String blockId);

  ResultFuture<List<Room>> getBlockRooms(String blockId);
}
