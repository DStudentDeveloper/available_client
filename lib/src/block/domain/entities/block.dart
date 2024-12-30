import 'package:available/src/room/domain/entities/room.dart';
import 'package:equatable/equatable.dart';

class Block extends Equatable {
  const Block({
    required this.id,
    required this.code,
    this.rooms,
  });

  const Block.empty()
      : id = 'Test String',
        code = 'Test String',
        rooms = null;

  final String id;
  final String code;
  final List<Room>? rooms;

  @override
  List<dynamic> get props => [id, code, ...?rooms];
}
