import 'package:available/core/res/colours.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/room/presentation/views/rooms_screen.dart';
import 'package:flutter/material.dart';

class BlockTile extends StatelessWidget {
  const BlockTile(
    this.index,
    this.block, {
    this.receiveGestures = true,
    super.key,
  });

  final int index;
  final Block block;
  final bool receiveGestures;

  @override
  Widget build(BuildContext context) {
    final outlined = index.isEven;
    return Hero(
      tag: block.id,
      child: GestureDetector(
        onTap: receiveGestures
            ? () {
                Navigator.of(context).pushNamed(
                  RoomsScreen.path,
                  arguments: {'block': block, 'index': index},
                );
              }
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: outlined ? null : Colours.primary,
            borderRadius: BorderRadius.circular(15),
            border: outlined ? Border.all(color: Colors.black45) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Icon(
                  Icons.apartment_outlined,
                  color: outlined ? Colours.primary : Colors.white,
                ),
                Text(
                  'Block ${block.code}'.toUpperCase(),
                  style: TextStyle(
                    color: outlined ? Colours.primary : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
