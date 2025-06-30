import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/question_service.dart';
import 'package:diaguard1/features/questionnaire/data/question_data.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final AuthService authService;
  final Map<int, String>? answers;

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.authService,
    this.answers,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late QuestionService questionService;
  List<Map<String, String>> answers = [];
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
      if (widget.answers != null && widget.answers!.isNotEmpty) {
        print('Using passed answers: \\${widget.answers}');
        answers = widget.answers!.entries.map((entry) {
          return {
            'questionText': questions[entry.key],
            'answer': entry.value,
          };
        }).toList();
      } else {
        print('Fetching answers from backend...');
        final loadedAnswers = await questionService.getAnswers();
        print('Loaded answers: \\${loadedAnswers}');
        setState(() => answers = loadedAnswers);
      }
    } catch (e) {
      print('Error loading answers: \\${e}');
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
        title: Text('الملف الشخصي', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(52, 91, 99, 1),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white), 
            onPressed: _loadAnswers
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : answers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد إجابات متاحة',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final answer = answers[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(52, 91, 99, 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.quiz,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'السؤال ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color.fromRGBO(52, 91, 99, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              answer['questionText'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(52, 91, 99, 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromRGBO(52, 91, 99, 0.2),
                                ),
                              ),
                              child: Text(
                                answer['answer'] ?? '',
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Color.fromRGBO(52, 91, 99, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
