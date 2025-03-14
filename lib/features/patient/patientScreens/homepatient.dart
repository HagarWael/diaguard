import 'package:flutter/material.dart';

class HomePatientScreen extends StatefulWidget {
  @override
  _HomePatientScreenState createState() => _HomePatientScreenState();
}

class _HomePatientScreenState extends State<HomePatientScreen> {
  final List<Map<String, dynamic>> questions = [
    {'question': 'How often do you check your glucose levels?', 'type': 'text'},
    {
      'question': 'Do you experience dizziness frequently?',
      'type': 'dropdown',
      'options': ['Yes', 'No'],
    },
  ];

  final Map<String, dynamic> answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Questions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question'],
                        style: TextStyle(fontSize: 18),
                      ),
                      if (question['type'] == 'text')
                        TextField(
                          onChanged:
                              (value) => answers[question['question']] = value,
                          decoration: InputDecoration(
                            hintText: "Enter your answer",
                          ),
                        ),
                      if (question['type'] == 'dropdown')
                        DropdownButton<String>(
                          value:
                              answers[question['question']] ??
                              question['options'][0],
                          items:
                              question['options'].map<DropdownMenuItem<String>>(
                                (option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                },
                              ).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              answers[question['question']] = newValue;
                            });
                          },
                        ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(
                  "User Answers: $answers",
                ); // Next: Save to Firebase via BLoC
              },
              child: Text('Submit Answers'),
            ),
          ],
        ),
      ),
    );
  }
}
