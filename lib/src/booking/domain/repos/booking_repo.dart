import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';

abstract class BookingRepo {
  ResultFuture<Booking> bookRoom(Booking booking);

  ResultFuture<void> cancelBooking(String bookingId);

  ResultFuture<Booking> updateBooking(Booking booking);
}
