import 'package:available/core/common/app/state/user_provider.dart';
import 'package:available/core/common/widgets/adaptive_loader.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/feedback/data/models/feedback_model.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:available/src/feedback/presentation/app/adapter/feedback_cubit.dart';
import 'package:available/src/feedback/presentation/views/feedback_confirmed_screen.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveFeedbackScreen extends StatelessWidget {
  const LeaveFeedbackScreen({super.key});

  static const path = '/feedback';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedbackCubit, FeedbackState>(
      listener: (_, state) {
        if (state case FeedbackError(:final title, :final message)) {
          CoreUtils.showSnackBar(context, title: title, message: message);
        } else if (state case FeedbackLeft(:final feedback)) {
          Navigator.pushReplacementNamed(
            context,
            FeedbackConfirmedScreen.path,
            arguments: feedback,
          );
        }
      },
      builder: (_, state) => LeaveFeedbackView(
        state: state,
        onLeaveFeedback: (feedback) {
          context.read<FeedbackCubit>().leaveFeedback(feedback);
        },
      ),
    );
  }
}

class LeaveFeedbackView extends StatefulWidget {
  const LeaveFeedbackView({
    required this.state,
    required this.onLeaveFeedback,
    super.key,
  });

  final FeedbackState state;
  final ValueChanged<Feedback> onLeaveFeedback;

  @override
  State<LeaveFeedbackView> createState() => _LeaveFeedbackViewState();
}

class _LeaveFeedbackViewState extends State<LeaveFeedbackView> {
  final _feedbackController = TextEditingController();
  final _focusNode = FocusNode();
  final privacyNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _feedbackController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
              'Leave Feedback',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 5,
            minLines: 1,
            controller: _feedbackController,
            focusNode: _focusNode,
            decoration: const InputDecoration(labelText: 'Feedback'),
            onTapOutside: (_) {
              _focusNode.unfocus();
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: privacyNotifier,
            builder: (_, isAnonymous, __) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  privacyNotifier.value = !isAnonymous;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isAnonymous,
                      onChanged: (value) {
                        privacyNotifier.value = value!;
                      },
                    ),
                    const Text('Anonymously submit feedback'),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (widget.state) {
              FeedbackLoading() => const AdaptiveLoader(),
              _ => ElevatedButton(
                  onPressed: () {
                    final text = _feedbackController.text.trim();
                    final isAnonymous = privacyNotifier.value;
                    final user =
                        isAnonymous ? null : UserProvider.instance.user;
                    if (text.isNotEmpty && (isAnonymous || user != null)) {
                      widget.onLeaveFeedback(
                        FeedbackModel(
                          id: 'id',
                          message: text,
                          representativeCourse: user?.courseName ?? 'Anonymous',
                          representativeName: user?.name ?? 'Anonymous',
                          representativeLevel: user?.levelName ?? 'Anonymous',
                          representativeId: user?.id ?? 'Anonymous',
                        ),
                      );
                    }
                  },
                  child: const Text('Submit Feedback'),
                ),
            },
          ),
        ],
      ),
    );
  }
}
