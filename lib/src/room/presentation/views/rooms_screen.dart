import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/presentation/app/adapter/block_cubit.dart';
import 'package:available/src/block/presentation/widgets/block_tile.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/presentation/widgets/room_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({required this.index, required this.block, super.key});

  final int index;
  final Block block;

  static const path = '/rooms';

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlockCubit>().getBlockRooms(widget.block.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlockCubit, BlockState>(
      listener: (_, state) {
        if (state case BlockError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        }
      },
      builder: (_, state) {
        return RoomsView(
          state: state,
          index: widget.index,
          block: widget.block,
        );
      },
    );
  }
}

class RoomsView extends StatelessWidget {
  const RoomsView({
    required this.index,
    required this.block,
    required this.state,
    super.key,
  });

  final BlockState state;
  final int index;
  final Block block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          BlockTile(index, block, receiveGestures: false),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state is BlockLoading) return const AdaptiveLoader();
                if (state case BlockRoomsFetched(:final rooms)) {
                  rooms.sort((a, b) => a.code.compareTo(b.code));
                  final mid = rooms.length ~/ 2;

                  final interleavedRooms = <Room>[];

                  final firstHalf = rooms.sublist(0, mid);
                  final secondHalf = rooms.sublist(mid);
                  for (var i = 0; i < firstHalf.length; i++) {
                    interleavedRooms
                      ..add(firstHalf[i])
                      ..add(secondHalf[i]);
                  }

                  if (rooms.length.isOdd) {
                    interleavedRooms.add(secondHalf.last);
                  }

                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: interleavedRooms.map(RoomTile.new).toList(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
