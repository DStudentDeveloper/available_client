import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/block/presentation/app/adapter/block_cubit.dart';
import 'package:available/src/block/presentation/widgets/block_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocksScreen extends StatefulWidget {
  const BlocksScreen({super.key});

  static const path = '/blocks';

  @override
  State<BlocksScreen> createState() => _BlocksScreenState();
}

class _BlocksScreenState extends State<BlocksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlockCubit>().getAllBlocks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlockCubit, BlockState>(
      listener: (_, state) {
        if (state case BlockError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        }
      },
      builder: (_, state) => BlocksView(state: state),
    );
  }
}

class BlocksView extends StatelessWidget {
  const BlocksView({required this.state, super.key});

  final BlockState state;

  @override
  Widget build(BuildContext context) {
    if (state is BlockLoading) return const AdaptiveLoader();
    if (state case BlocksFetched(:final blocks)) {
      blocks
          // ..add(const BlockModel.empty().copyWith(code: 'A'))
          // ..add(const BlockModel.empty().copyWith(code: 'C'))
          // ..add(const BlockModel.empty().copyWith(code: 'D'))
          // ..add(const BlockModel.empty().copyWith(code: 'G')).
          .sort((a, b) => a.code.compareTo(b.code));
      final mid = blocks.length ~/ 2;

      final interleavedBlocks = <Block>[];

      final firstHalf = blocks.sublist(0, mid);
      final secondHalf = blocks.sublist(mid);
      for (var i = 0; i < firstHalf.length; i++) {
        interleavedBlocks
          ..add(firstHalf[i])
          ..add(secondHalf[i]);
      }

      if (blocks.length.isOdd) {
        interleavedBlocks.add(secondHalf.last);
      }

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            const Text(
              'PLEASE SELECT A BLOCK FOR YOUR LECTURE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colours.primary,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 30,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children:
                      interleavedBlocks.mapIndexed(BlockTile.new).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
