import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/errors/failure.dart';
import 'package:available/core/interfaces/usecase.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/domain/usecases/get_all_rooms.dart';
import 'package:available/src/room/domain/usecases/get_room_bookings.dart';
import 'package:available/src/room/domain/usecases/get_room_by_id.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit({
    required GetAllRooms getAllRooms,
    required GetRoomBookings getRoomBookings,
    required GetRoomById getRoomById,
    required AvailabilityController availabilityController,
  })  : _getAllRooms = getAllRooms,
        _getRoomBookings = getRoomBookings,
        _getRoomById = getRoomById,
        _availabilityController = availabilityController,
        super(const RoomInitial());

  final GetAllRooms _getAllRooms;
  final GetRoomBookings _getRoomBookings;
  final GetRoomById _getRoomById;
  final AvailabilityController _availabilityController;

  Future<void> getAllRooms() async {
    emit(const RoomLoading());

    final result = await _getAllRooms(const NoParams());

    result.fold(
      (failure) => emit(RoomError.fromFailure(failure)),
      (rooms) => emit(RoomsFetched(rooms)),
    );
  }

  Future<void> getRoomById(String id) async {
    emit(const RoomLoading());

    final result = await _getRoomById(id);

    result.fold(
      (failure) => emit(RoomError.fromFailure(failure)),
      (room) async {
        await _availabilityController.updateRoomAvailabilityCache(
          roomId: room.id,
          updatedBookings: room.bookings ?? [],
          room: room,
          create: true,
        );
        emit(RoomFetched(room));
      },
    );
  }

  /// Get the bookings for a room
  ///
  /// There's no point using this for UI. Use the [AvailabilityController]
  /// instead for live availability updates.
  Future<void> getRoomBookings(String id) async {
    emit(const RoomLoading());

    final result = await _getRoomBookings(id);

    result.fold(
      (failure) => emit(RoomError.fromFailure(failure)),
      (bookings) => emit(RoomBookingsFetched(bookings)),
    );
  }

  @override
  void emit(RoomState state) {
    if (!isClosed) super.emit(state);
  }
}
