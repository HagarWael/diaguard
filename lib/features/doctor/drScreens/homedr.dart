import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';

class DoctorHomeScreen extends StatelessWidget {
  final String userName;
  final String patientId;
  final String patientHistory;
  final AuthService authService;

  const DoctorHomeScreen({
    super.key,
    required this.userName,
    required this.patientId,
    required this.patientHistory,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 245, 1),
      body: ListView(
        children: [
          // Header with back button and logout/profile icon
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10, 30.0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color.fromRGBO(139, 170, 177, 1),
                ),
                IconButton(
                  onPressed: () async {
                    await authService.logout();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(139, 170, 177, 1),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          // Chart placeholder
          Container(
            height: 300,
            color: Colors.grey[200],
            child: const Center(child: Text('Chart would appear here')),
          ),

          // Week navigation
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color.fromRGBO(52, 91, 99, 1),
                  iconSize: 18,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Text(
                    'Week 1',
                    style: TextStyle(
                      color: Color.fromRGBO(52, 91, 99, 1),
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: const Color.fromRGBO(52, 91, 99, 1),
                  iconSize: 18,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Main content container
          Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 36,
                          color: Color.fromRGBO(139, 170, 177, 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.person,
                        color: Color.fromRGBO(139, 170, 177, 1),
                        size: 40,
                      ),
                    ],
                  ),

                  // History section
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(139, 170, 177, 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      width: 315,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        border: Border.all(
                          color: const Color.fromRGBO(139, 170, 177, 1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(patientHistory),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Labs section
                  Row(
                    children: [
                      const Text(
                        'Labs',
                        style: TextStyle(
                          fontSize: 25,
                          color: Color.fromRGBO(139, 170, 177, 1),
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          // Navigation to labs would go here
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(139, 170, 177, 1),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Lab cards placeholder
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [LabCard(), LabCard(), LabCard()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// LabCard widget
class LabCard extends StatelessWidget {
  const LabCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 141,
      width: 114,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(218, 228, 229, 1),
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        border: Border.all(
          color: const Color.fromRGBO(218, 228, 229, 1),
          width: 2,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 50,
            color: Color.fromRGBO(91, 122, 129, 1),
          ),
          Text(
            'Lab Result',
            style: TextStyle(
              color: Color.fromRGBO(91, 122, 129, 1),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
