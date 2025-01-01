import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/interfaces/usecase.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/domain/usecases/get_all_blocks.dart';
import 'package:available/src/block/domain/usecases/get_block_by_id.dart';
import 'package:available/src/block/domain/usecases/get_block_rooms.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'block_state.dart';

class BlockCubit extends Cubit<BlockState> {
  BlockCubit({
    required GetAllBlocks getAllBlocks,
    required GetBlockById getBlockById,
    required GetBlockRooms getBlockRooms,
    required AvailabilityController availabilityController,
  })  : _getAllBlocks = getAllBlocks,
        _getBlockById = getBlockById,
        _getBlockRooms = getBlockRooms,
        _availabilityController = availabilityController,
        super(const BlockInitial());

  final GetAllBlocks _getAllBlocks;
  final GetBlockById _getBlockById;
  final GetBlockRooms _getBlockRooms;
  final AvailabilityController _availabilityController;

  Future<void> getAllBlocks() async {
    emit(const BlockLoading());

    final result = await _getAllBlocks(const NoParams());

    result.fold(
      (failure) => emit(BlockError.fromFailure(failure)),
      (blocks) => emit(BlocksFetched(blocks)),
    );
  }

  Future<void> getBlockById(String id) async {
    emit(const BlockLoading());

    final result = await _getBlockById(id);

    result.fold(
      (failure) => emit(BlockError.fromFailure(failure)),
      (block) => emit(BlockFetched(block)),
    );
  }

  Future<void> getBlockRooms(String id) async {
    emit(const BlockLoading());

    final result = await _getBlockRooms(id);

    result.fold(
      (failure) => emit(BlockError.fromFailure(failure)),
      (rooms) async {
        await _availabilityController.cacheAvailabilityForRooms(rooms);
        emit(BlockRoomsFetched(rooms));
      },
    );
  }
}
