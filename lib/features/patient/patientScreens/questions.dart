import 'package:flutter/material.dart';
import 'package:diaguard1/features/questionnaire/data/question_data.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/question_service.dart';
import 'package:diaguard1/core/theme/app_color.dart';
import 'patient_list.dart';

class QuestionScreen extends StatefulWidget {
  final AuthService authService;
  final String userName;

  const QuestionScreen({
    Key? key,
    required this.authService,
    required this.userName,
  }) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Map<int, String> answers = {};

  late AnimationController _controller;
  late Animation<Offset> _offsetAnim;
  late QuestionService questionService;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    questionService = QuestionService(authService: widget.authService);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offsetAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.04),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveAnswers() async {
    setState(() => isSaving = true);
    try {
      await questionService.saveAnswers(answers);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answers saved successfully!')),
      );
      _navigateToNextScreen();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save answers: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => BarHome(
              userName: widget.userName,
              authService: widget.authService,
              answers: answers,
            ),
      ),
    );
  }

  void _onAnswerSelected(String answer) async {
    setState(() {
      answers[currentIndex] = answer;
    });

    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 60));
    await _controller.reverse();

    if (currentIndex == questions.length - 1) {
      await _saveAnswers();
    } else {
      setState(() {
        currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentIndex + 1) / questions.length;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SlideTransition(
                      position: _offsetAnim,
                      child: Card(
                        key: ValueKey(currentIndex),
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Question ${currentIndex + 1} of ${questions.length}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                questions[currentIndex],
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ...options[currentIndex]!.map(
                                (option) => AnimatedOptionButton(
                                  text: option,
                                  onTap: () => _onAnswerSelected(option),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            if (isSaving) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class AnimatedOptionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const AnimatedOptionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedOptionButton> createState() => _AnimatedOptionButtonState();
}

class _AnimatedOptionButtonState extends State<AnimatedOptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) =>
                Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.secondary, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
