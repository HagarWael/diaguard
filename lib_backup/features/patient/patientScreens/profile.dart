import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/question_service.dart';
import 'package:diaguard1/features/questionnaire/data/question_data.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final AuthService authService;

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.authService,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late QuestionService questionService;
  Map<int, String> answers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    questionService = QuestionService(authService: widget.authService);
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    setState(() => isLoading = true);
    try {
      final loadedAnswersList = await questionService.getAnswers();
      // Convert List<Map<String, String>> to Map<int, String>
      final loadedAnswers = <int, String>{};
      for (int i = 0; i < loadedAnswersList.length; i++) {
        final map = loadedAnswersList[i];
        map.forEach((key, value) {
          loadedAnswers[i] = value;
        });
      }
      setState(() => answers = loadedAnswers);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load answers: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadAnswers),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : answers.isEmpty
              ? Center(child: Text('No answers available'))
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];
                  if (answer == null) return SizedBox();

                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        answer,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
