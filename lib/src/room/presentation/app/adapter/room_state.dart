part of 'room_cubit.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {
  const RoomInitial();
}

final class RoomLoading extends RoomState {
  const RoomLoading();
}

final class RoomsFetched extends RoomState {
  const RoomsFetched(this.rooms);

  final List<Room> rooms;

  @override
  List<Object> get props => rooms;
}

final class RoomFetched extends RoomState {
  const RoomFetched(this.room);

  final Room room;

  @override
  List<Object> get props => [room];
}

final class RoomBookingsFetched extends RoomState {
  const RoomBookingsFetched(this.bookings);

  final List<Booking> bookings;

  @override
  List<Object> get props => bookings;
}

final class RoomError extends RoomState {
  const RoomError({required this.title, required this.message});

  RoomError.fromFailure(Failure failure)
      : this(title: failure.title, message: failure.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
