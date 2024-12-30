part of 'block_cubit.dart';

sealed class BlockState extends Equatable {
  const BlockState();

  @override
  List<Object> get props => [];
}

final class BlockInitial extends BlockState {
  const BlockInitial();
}

final class BlockLoading extends BlockState {
  const BlockLoading();
}

final class BlocksFetched extends BlockState {
  const BlocksFetched(this.blocks);

  final List<Block> blocks;

  @override
  List<Object> get props => blocks;
}

final class BlockFetched extends BlockState {
  const BlockFetched(this.block);

  final Block block;

  @override
  List<Object> get props => [block];
}

final class BlockRoomsFetched extends BlockState {
  const BlockRoomsFetched(this.rooms);

  final List<Room> rooms;

  @override
  List<Object> get props => rooms;
}

final class BlockError extends BlockState {
  const BlockError({required this.title, required this.message});

  BlockError.fromFailure(Failure failure)
      : this(title: failure.title, message: failure.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
