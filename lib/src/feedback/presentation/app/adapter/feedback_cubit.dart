import 'package:available/core/errors/failure.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:available/src/feedback/domain/usecases/leave_feedback.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit({
    required LeaveFeedback leaveFeedback,
  })  : _leaveFeedback = leaveFeedback,
        super(const FeedbackInitial());

  final LeaveFeedback _leaveFeedback;

  Future<void> leaveFeedback(Feedback feedback) async {
    emit(const FeedbackLoading());

    final result = await _leaveFeedback(feedback);

    result.fold(
      (failure) => emit(FeedbackError.fromFailure(failure)),
      (feedback) => emit(FeedbackLeft(feedback)),
    );
  }
}
