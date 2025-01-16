part of 'feedback_cubit.dart';

sealed class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

final class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

final class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

final class FeedbackLeft extends FeedbackState {
  const FeedbackLeft(this.feedback);

  final Feedback feedback;

  @override
  List<Object> get props => [feedback];
}

final class FeedbackError extends FeedbackState {
  const FeedbackError({required this.title, required this.message});

  FeedbackError.fromFailure(Failure failure)
      : this(title: failure.title, message: failure.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}
