import 'package:available/core/errors/failure.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/domain/usecases/book_room.dart';
import 'package:available/src/booking/domain/usecases/cancel_booking.dart';
import 'package:available/src/booking/domain/usecases/get_user_bookings.dart';
import 'package:available/src/booking/domain/usecases/update_booking.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required BookRoom bookRoom,
    required CancelBooking cancelBooking,
    required UpdateBooking updateBooking,
    required GetUserBookings getUserBookings,
  })  : _bookRoom = bookRoom,
        _cancelBooking = cancelBooking,
        _updateBooking = updateBooking,
        _getUserBookings = getUserBookings,
        super(const BookingInitial());

  final BookRoom _bookRoom;
  final CancelBooking _cancelBooking;
  final UpdateBooking _updateBooking;
  final GetUserBookings _getUserBookings;

  Future<void> bookRoom(Booking booking) async {
    emit(const BookingLoading());

    final result = await _bookRoom(booking);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (booking) => emit(RoomBooked(booking)),
    );
  }

  Future<void> cancelBooking(String id) async {
    emit(const BookingLoading());

    final result = await _cancelBooking(id);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (_) => emit(const BookingCancelled()),
    );
  }

  Future<void> updateBooking(Booking booking) async {
    emit(const BookingLoading());

    final result = await _updateBooking(booking);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (booking) => emit(BookingUpdated(booking)),
    );
  }

  Future<void> getUserBookings(String userId) async {
    emit(const BookingLoading());

    final result = await _getUserBookings(userId);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (bookings) => emit(UserBookingsFetched(bookings)),
    );
  }

  Future<void> endClass(String bookingId) async {
    emit(const BookingLoading());

    final result = await _cancelBooking(bookingId);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (_) => emit(const ClassEnded()),
    );
  }

  @override
  void emit(BookingState state) {
    if (!isClosed) super.emit(state);
  }
}
