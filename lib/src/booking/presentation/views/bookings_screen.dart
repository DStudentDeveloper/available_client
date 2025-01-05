import 'package:available/core/common/app/state/user_provider.dart';
import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/utils/core_constants.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/presentation/app/adapter/booking_cubit.dart';
import 'package:available/src/booking/presentation/views/update_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  static const path = '/bookings';

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  void getBookings() {
    context.read<BookingCubit>().getUserBookings(
          UserProvider.instance.user!.id,
        );
  }

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (_, state) {
        if (state case BookingError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state is ClassEnded || state is BookingCancelled) {
          getBookings();
        }
      },
      builder: (_, state) {
        return BookingsView(
          state: state,
          onCancelBooking: (booking) {
            context.read<BookingCubit>().cancelBooking(booking.id);
          },
          onEndClass: (booking) {
            context.read<BookingCubit>().endClass(booking.id);
          },
          onUpdate: (booking) async {
            final result = await CoreConstants.rootNavigatorKey.currentState!
                .pushNamed<bool>(
              UpdateBookingScreen.path,
              arguments: booking,
            );
            if (result ?? false) {
              getBookings();
            }
          },
        );
      },
    );
  }
}

class BookingsView extends StatelessWidget {
  const BookingsView({
    required this.state,
    required this.onCancelBooking,
    required this.onEndClass,
    required this.onUpdate,
    super.key,
  });

  final BookingState state;
  final void Function(Booking booking) onCancelBooking;
  final void Function(Booking booking) onEndClass;
  final void Function(Booking booking) onUpdate;

  @override
  Widget build(BuildContext context) {
    if (state is BookingLoading) {
      return const AdaptiveLoader();
    } else if (state case UserBookingsFetched(:final bookings)) {
      if (bookings.isEmpty) {
        return const Center(
          child: Text('No bookings found'),
        );
      }
      bookings.sort((a, b) => a.startTime.compareTo(b.startTime));
      // move all expired ones to the end
      final expired = bookings.where((b) => b.endTime.isBefore(DateTime.now()));
      final notExpired =
          bookings.where((b) => !b.endTime.isBefore(DateTime.now()));
      final sortedBookings = [...notExpired, ...expired];
      return ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (_, index) {
          final booking = sortedBookings[index];
          final startTime = TimeOfDay.fromDateTime(booking.startTime);
          final endTime = TimeOfDay.fromDateTime(booking.endTime);
          return ListTile(
            leading: const Icon(Icons.book_online_outlined),
            title: Text(booking.room!.fullCode),
            subtitle: Text(
              '${startTime.format(context)} - ${endTime.format(context)}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'cancel') {
                  final result = await CoreUtils.showConfirmationDialog(
                    context,
                    title: 'Cancel Class',
                    message: 'Are you sure you want to cancel this class?',
                    important: true,
                  );
                  if (result) onCancelBooking(booking);
                } else if (value == 'end') {
                  final result = await CoreUtils.showConfirmationDialog(
                    context,
                    title: 'End Class',
                    message: 'Are you sure you want to end this class?',
                    important: true,
                  );
                  if (result) onEndClass(booking);
                } else if (value == 'update') {
                  onUpdate(booking);
                }
              },
              itemBuilder: (_) {
                final expired = booking.endTime.isBefore(DateTime.now());
                final classHasStarted = booking.startTime.isBefore(
                  DateTime.now(),
                );
                if (expired) {
                  return const [
                    PopupMenuItem(
                      value: 'cancel',
                      child: Text('Delete Booking'),
                    ),
                  ];
                }
                return [
                  if (classHasStarted)
                    const PopupMenuItem(
                      value: 'end',
                      child: Text('End Class'),
                    )
                  else
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Text('Cancel Booking'),
                    ),
                  const PopupMenuItem(
                    value: 'update',
                    child: Text('Update Booking'),
                  ),
                ];
              },
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
