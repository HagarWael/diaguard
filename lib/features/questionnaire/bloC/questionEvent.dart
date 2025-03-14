import 'package:equatable/equatable.dart';

abstract class QuestionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AnswerSelected extends QuestionEvent {
  final int questionIndex;
  final String answer;

  AnswerSelected({required this.questionIndex, required this.answer});

  @override
  List<Object> get props => [questionIndex, answer];
}

class SubmitAnswers extends QuestionEvent {}
