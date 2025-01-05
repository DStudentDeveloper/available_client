import 'package:available/core/common/app/state/user_provider.dart';
import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/booking/presentation/app/adapter/booking_cubit.dart';
import 'package:available/src/booking/presentation/views/booking_confirmed_screen.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BookRoomScreen extends StatelessWidget {
  const BookRoomScreen(this.room, {super.key});

  final Room room;

  static const path = '/book-room';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (_, state) {
        if (state case BookingError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state is RoomBooked) {
          Navigator.pushReplacementNamed(
            context,
            BookingConfirmedScreen.path,
            arguments: {
              'room': room,
              'startTime': TimeOfDay.fromDateTime(state.booking.startTime),
              'endTime': TimeOfDay.fromDateTime(state.booking.endTime),
            },
          );
        }
      },
      builder: (_, state) => BookRoomView(
        state: state,
        onBookRoom: (booking) {
          final user = UserProvider.instance.user!;
          context.read<BookingCubit>().bookRoom(
                booking.copyWith(
                  room: room,
                  representativeId: user.id,
                  course: user.courseName,
                  level: user.levelName,
                ),
              );
        },
      ),
    );
  }
}

class BookRoomView extends StatefulWidget {
  const BookRoomView({
    required this.state,
    required this.onBookRoom,
    super.key,
  });

  final BookingState state;
  final void Function(BookingModel) onBookRoom;

  @override
  State<BookRoomView> createState() => _BookRoomViewState();
}

class _BookRoomViewState extends State<BookRoomView> {
  final startTimeNotifier = ValueNotifier<TimeOfDay?>(null);
  final endTimeNotifier = ValueNotifier<TimeOfDay?>(null);

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colours.primary,
    );
    final buttonStyle =
        ElevatedButton.styleFrom(minimumSize: const Size(0, 41));
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        if (startTime == null) return const SizedBox.shrink();
                        return Text(
                          startTime.format(context),
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
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime ?? TimeOfDay.now(),
                        );
                        if (time != null && time.isBefore(TimeOfDay.now())) {
                          if (context.mounted) {
                            CoreUtils.showSnackBar(
                              context,
                              title: 'Invalid Time',
                              message: 'Please select a time after now',
                            );
                          }
                          return;
                        }
                        startTimeNotifier.value = time;
                        if (time == null) {
                          endTimeNotifier.value = null;
                        } else if (endTimeNotifier.value == null ||
                            endTimeNotifier.value!.isBefore(time)) {
                          endTimeNotifier.value = time.replacing(
                            hour: time.hour + 1,
                          );
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
                        if (endTime == null) return const SizedBox.shrink();
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
                        if (startTime == null) {
                          CoreUtils.showSnackBar(
                            context,
                            title: 'Invalid Time',
                            message: 'Please select a start time first',
                          );
                          return;
                        }
                        final endTime = endTimeNotifier.value;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime ?? startTime,
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
                valueListenable: startTimeNotifier,
                builder: (_, startTime, __) {
                  if (startTime == null) return const SizedBox.shrink();

                  if (widget.state is BookingLoading) {
                    return const AdaptiveLoader();
                  }
                  return ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      widget.onBookRoom(
                        BookingModel.empty().copyWith(
                          startTime: DateTime.now().copyWith(
                            hour: startTime.hour,
                            minute: startTime.minute,
                          ),
                          endTime: DateTime.now().copyWith(
                            hour: endTimeNotifier.value!.hour,
                            minute: endTimeNotifier.value!.minute,
                          ),
                        ),
                      );
                    },
                    child: const Text('SET'),
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
