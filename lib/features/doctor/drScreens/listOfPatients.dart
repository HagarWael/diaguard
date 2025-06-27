import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/doctor_service.dart';
import 'package:diaguard1/features/doctor/drScreens/patient_detail_screen.dart';

class ListOfPatients extends StatefulWidget {
  const ListOfPatients({super.key});

  @override
  State<ListOfPatients> createState() => _ListOfPatientsState();
}

class _ListOfPatientsState extends State<ListOfPatients> {
  late final DoctorService _doctorService;
  late Future<List<Map<String, dynamic>>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService(authService: AuthService());
    _patientsFuture = _doctorService.getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final patients = snapshot.data ?? [];

          if (patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];

              // Safe extraction with null checks & fallback values
              final id = patient['_id']?.toString() ?? 'No ID';
              final rawName = patient['name'];
              final name =
                  (rawName is String && rawName.trim().isNotEmpty)
                      ? rawName.trim()
                      : 'Unnamed';

              final lastReading = patient['lastReading'];
              final readingValue =
                  lastReading != null ? lastReading['value']?.toString() : null;
              final readingType =
                  lastReading != null ? lastReading['type']?.toString() : null;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        (readingValue != null && readingType != null)
                            ? 'Last Reading: $readingValue ($readingType)'
                            : 'No readings yet',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientDetailScreen(
                          patientId: id,
                          patientName: name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
