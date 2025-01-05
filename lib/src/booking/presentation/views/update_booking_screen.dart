// if it has already started, only let them update the end time, otherwise,
// both can be updated.

import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/booking/presentation/app/adapter/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UpdateBookingScreen extends StatelessWidget {
  const UpdateBookingScreen(this.booking, {super.key});

  final Booking booking;

  static const path = '/update-booking';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (_, state) {
        if (state case BookingError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state is BookingUpdated) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (_, state) {
        return UpdateBookingView(
          booking: booking,
          state: state,
          onUpdate: (updatedBooking) {
            context.read<BookingCubit>().updateBooking(updatedBooking);
          },
        );
      },
    );
  }
}

class UpdateBookingView extends StatefulWidget {
  const UpdateBookingView({
    required this.booking,
    required this.state,
    required this.onUpdate,
    super.key,
  });

  final Booking booking;
  final BookingState state;
  final void Function(BookingModel updatedBooking) onUpdate;

  @override
  State<UpdateBookingView> createState() => _UpdateBookingViewState();
}

class _UpdateBookingViewState extends State<UpdateBookingView> {
  late ValueNotifier<TimeOfDay> startTimeNotifier;
  late ValueNotifier<TimeOfDay> endTimeNotifier;
  late bool hasStarted;

  final changeNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final originalStartTime = TimeOfDay.fromDateTime(widget.booking.startTime);
    final originalEndTime = TimeOfDay.fromDateTime(widget.booking.endTime);
    startTimeNotifier = ValueNotifier(originalStartTime)
      ..addListener(() {
        changeNotifier.value =
            !startTimeNotifier.value.isAtSameTimeAs(originalStartTime);
      });
    endTimeNotifier = ValueNotifier(originalEndTime)
      ..addListener(() {
        changeNotifier.value =
            !endTimeNotifier.value.isAtSameTimeAs(originalEndTime);
      });
    hasStarted = widget.booking.startTime.isBefore(
      DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colours.primary,
    );
    final buttonStyle =
        ElevatedButton.styleFrom(minimumSize: const Size(0, 41));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Booking'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(widget.booking.room!.fullCode),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    const Text('Start', style: titleStyle),
                    ValueListenableBuilder(
                      valueListenable: startTimeNotifier,
                      builder: (_, startTime, __) {
                        return Text(
                          startTime.format(context),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colours.primary,
                          ),
                        );
                      },
                    ),
                    if (hasStarted)
                      const Text(
                        'Class Ongoing',
                        style: TextStyle(
                          color: Colours.unavailable,
                          fontSize: 12,
                        ),
                      )
                    else
                      ElevatedButton(
                        style: buttonStyle,
                        child: const Text('Select Time'),
                        onPressed: () async {
                          final startTime = startTimeNotifier.value;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (time != null) {
                            if (time.isBefore(TimeOfDay.now()) &&
                                context.mounted) {
                              CoreUtils.showSnackBar(
                                context,
                                title: 'Invalid Time',
                                message: 'Please select a time after now',
                              );
                              return;
                            }
                            startTimeNotifier.value = time;
                          }
                        },
                      ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    const Text('End', style: titleStyle),
                    ValueListenableBuilder(
                      valueListenable: endTimeNotifier,
                      builder: (_, endTime, __) {
                        return Text(
                          endTime.format(context),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colours.primary,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      style: buttonStyle,
                      child: const Text('Select Time'),
                      onPressed: () async {
                        final startTime = startTimeNotifier.value;
                        final endTime = endTimeNotifier.value;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          String? message;

                          // Helper function to add minutes to TimeOfDay
                          TimeOfDay addMinutesToTimeOfDay(
                            TimeOfDay time,
                            int minutesToAdd,
                          ) {
                            final totalMinutes =
                                time.hour * 60 + time.minute + minutesToAdd;
                            final newHour = (totalMinutes ~/ 60) %
                                24; // Wrap around 24 hours
                            final newMinute = totalMinutes % 60;
                            return TimeOfDay(hour: newHour, minute: newMinute);
                          }

                          // Compute the minimum valid end time
                          // (start time + 30 minutes)
                          final minEndTime =
                              addMinutesToTimeOfDay(startTime, 30);

                          if (time.hour < startTime.hour ||
                              (time.hour == startTime.hour &&
                                  time.minute < startTime.minute)) {
                            message =
                                'Please select a time after the start time';
                          } else if (time.hour < minEndTime.hour ||
                              (time.hour == minEndTime.hour &&
                                  time.minute < minEndTime.minute)) {
                            message =
                                'Please select a time at least 30 minutes '
                                'after the start time';
                          } else if (time.isBefore(TimeOfDay.now())) {
                            message = 'Please select a time after now';
                          }

                          if (context.mounted && message != null) {
                            CoreUtils.showSnackBar(
                              context,
                              title: 'Invalid Time',
                              message: message,
                            );
                            return;
                          }
                          endTimeNotifier.value = time;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Gap(40),
            Center(
              child: ValueListenableBuilder(
                valueListenable: changeNotifier,
                builder: (_, updateRequired, __) {
                  final startTime = startTimeNotifier.value;
                  final endTime = endTimeNotifier.value;
                  if (!updateRequired) return const SizedBox.shrink();

                  if (widget.state is BookingLoading) {
                    return const AdaptiveLoader();
                  }
                  return ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      widget.onUpdate(
                        (widget.booking as BookingModel).copyWith(
                          startTime: DateTime.now().copyWith(
                            hour: startTime.hour,
                            minute: startTime.minute,
                          ),
                          endTime: DateTime.now().copyWith(
                            hour: endTime.hour,
                            minute: endTime.minute,
                          ),
                        ),
                      );
                    },
                    child: const Text('Update'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
