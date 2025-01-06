import 'dart:async';

import 'package:available/core/errors/failure.dart';
import 'package:available/core/services/notification_service.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
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
    required NotificationService notificationService,
  })  : _bookRoom = bookRoom,
        _cancelBooking = cancelBooking,
        _updateBooking = updateBooking,
        _getUserBookings = getUserBookings,
        _notificationService = notificationService,
        super(const BookingInitial());

  final BookRoom _bookRoom;
  final CancelBooking _cancelBooking;
  final UpdateBooking _updateBooking;
  final GetUserBookings _getUserBookings;
  final NotificationService _notificationService;

  Future<void> bookRoom(Booking booking) async {
    emit(const BookingLoading());

    final result = await _bookRoom(booking);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (booking) {
        emit(RoomBooked(booking));
        _notificationService
          ..showNotification()
          ..scheduleNotification(booking as BookingModel);
      },
    );
  }

  Future<void> cancelBooking(Booking booking) async {
    emit(const BookingLoading());

    final result = await _cancelBooking(booking.id);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (_) {
        emit(const BookingCancelled());
        _notificationService.cancelNotification(booking as BookingModel);
      },
    );
  }

  Future<void> updateBooking(Booking booking) async {
    emit(const BookingLoading());

    final result = await _updateBooking(booking);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (booking) {
        emit(BookingUpdated(booking));
        _notificationService.cancelNotification(booking as BookingModel);
      },
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

  Future<void> endClass(Booking booking) async {
    emit(const BookingLoading());

    final result = await _cancelBooking(booking.id);

    result.fold(
      (failure) => emit(BookingError.fromFailure(failure)),
      (_) {
        emit(const ClassEnded());
        _notificationService.cancelNotification(booking as BookingModel);
      },
    );
  }

  @override
  void emit(BookingState state) {
    if (!isClosed) super.emit(state);
  }
}
