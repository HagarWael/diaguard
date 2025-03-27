import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionBloC.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionEvent.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionState.dart';
import 'package:diaguard1/features/questionnaire/widgets/question_widget.dart';
import 'package:diaguard1/features/questionnaire/data/question_data.dart';
import 'package:diaguard1/features/patient/patientScreens/infopage_patient.dart';
import 'package:diaguard1/core/service/auth.dart'; // Import AuthService

class QuestionScreen extends StatelessWidget {
  final AuthService authService; // Add AuthService parameter

  const QuestionScreen({
    Key? key,
    required this.authService, // Make it required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionBloc(),
      child: Scaffold(
        body: BlocBuilder<QuestionBloc, QuestionState>(
          builder: (context, state) {
            int currentIndex = state.currentQuestionIndex;

            return Center(
              child: QuestionWidget(
                question: questions[currentIndex],
                options: options[currentIndex]!,
                selectedAnswer: state.answers[currentIndex] ?? "",
                onAnswerSelected: (answer) {
                  context.read<QuestionBloc>().add(
                    AnswerSelected(questionIndex: currentIndex, answer: answer),
                  );

                  if (currentIndex == questions.length - 1) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PatientInformation(
                                userName: answer,
                                authService: authService, // Pass authService
                              ),
                        ),
                      );
                    });
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
