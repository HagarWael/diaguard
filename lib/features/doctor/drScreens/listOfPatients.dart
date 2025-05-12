import 'package:flutter/material.dart';

class Patient {
  final String name;
  final String status;
  final String imageUrl;

  Patient({required this.name, required this.status, required this.imageUrl});
}

class DoctorPatientListScreen extends StatelessWidget {
  final List<Patient> patients = [
    Patient(name: 'عمر يوسف', status: 'مرتفع', imageUrl: 'assets/omr.png'),
    Patient(
      name: 'خليل خالد عبدالفتاح',
      status: 'طبيعي',
      imageUrl: 'assets/khalil.png',
    ),
    Patient(name: 'عمر يوسف', status: 'طبيعي', imageUrl: 'assets/omr.png'),
    Patient(name: 'عمر يوسف', status: 'منخفض', imageUrl: 'assets/omr.png'),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'مرتفع':
        return Colors.red.shade400;
      case 'منخفض':
        return Colors.amber.shade700;
      case 'طبيعي':
        return Colors.cyan.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة المرضى'),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
        body: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/doctor.png'),
              ),
              title: Text(
                'مرحباً د. محمد سمير',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: getStatusColor(patient.status),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                patient.status,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: AssetImage(patient.imageUrl),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
