part of 'booking_cubit.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {
  const BookingInitial();
}

final class BookingLoading extends BookingState {
  const BookingLoading();
}

final class RoomBooked extends BookingState {
  const RoomBooked(this.booking);

  final Booking booking;

  @override
  List<Object> get props => [booking];
}

final class BookingCancelled extends BookingState {
  const BookingCancelled();
}

class BookingUpdated extends BookingState {
  const BookingUpdated(this.booking);

  final Booking booking;

  @override
  List<Object> get props => [booking];
}

final class BookingError extends BookingState {
  const BookingError({required this.title, required this.message});

  BookingError.fromFailure(Failure failure)
      : this(title: failure.title, message: failure.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
