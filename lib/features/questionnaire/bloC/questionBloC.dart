import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionEvent.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionState.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final int totalQuestions = 11;

  QuestionBloc() : super(QuestionState.initial()) {
    on<AnswerSelected>((event, emit) {
      final newAnswers = Map<int, String>.from(state.answers);
      newAnswers[event.questionIndex] = event.answer;

      if (state.currentQuestionIndex < totalQuestions - 1) {
        emit(
          state.copyWith(
            answers: newAnswers,
            currentQuestionIndex: state.currentQuestionIndex + 1,
          ),
        );
      } else {
        emit(state.copyWith(answers: newAnswers));
      }
    });

    on<SubmitAnswers>((event, emit) {});
  }
}
