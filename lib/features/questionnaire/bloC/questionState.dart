import 'package:equatable/equatable.dart';

class QuestionState extends Equatable {
  final Map<int, String> answers;
  final int currentQuestionIndex;

  const QuestionState({
    required this.answers,
    required this.currentQuestionIndex,
  });

  factory QuestionState.initial() {
    return const QuestionState(answers: {}, currentQuestionIndex: 0);
  }

  QuestionState copyWith({
    Map<int, String>? answers,
    int? currentQuestionIndex,
  }) {
    return QuestionState(
      answers: answers ?? this.answers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  @override
  List<Object?> get props => [answers, currentQuestionIndex];
}
