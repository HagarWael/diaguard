import 'package:flutter/material.dart';
import 'package:diaguard1/core/service/doctor_service.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:diaguard1/features/doctor/drScreens/chat_screen.dart';
import 'package:diaguard1/features/doctor/drScreens/patient_pdfs_screen.dart';
import 'package:http/http.dart' as http;

class PatientDetailScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const PatientDetailScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late DoctorService _doctorService;
  Map<String, dynamic>? _patientDetails;
  List<Map<String, dynamic>> _glucoseReadings = [];
  List<Map<String, String>> _questionAnswers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService(authService: AuthService());
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load patient details and glucose readings in parallel
      final results = await Future.wait([
        _doctorService.getPatientDetails(widget.patientId),
        _doctorService.getPatientGlucoseReadings(widget.patientId),
        _fetchQuestionAnswers(widget.patientId),
      ]);

      setState(() {
        _patientDetails = results[0] as Map<String, dynamic>;
        _glucoseReadings = results[1] as List<Map<String, dynamic>>;
        _questionAnswers = results[2] as List<Map<String, String>>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, String>>> _fetchQuestionAnswers(String patientId) async {
    // Get the token from the doctor's AuthService
    final token = await _doctorService.authService.getToken();
    final response = await http.get(
      Uri.parse('http://localhost:3000/questions/get-answers?userId=$patientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Fetching answers for patientId: $patientId');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final questionList = data['question'] ?? data['patient']?['question'];
      if (questionList != null) {
        print('Parsed question answers: $questionList');
        return (questionList as List)
            .map<Map<String, String>>((q) => {
                  'questionText': q['questionText'].toString(),
                  'answer': q['answer'].toString(),
                })
            .toList();
      }
    }
    return [];
  }

  String? _getAnswerByIndex(int index) {
    if (_questionAnswers.length > index) {
      return _questionAnswers[index]['answer'];
    }
    return null;
  }

  List<FlSpot> _prepareChartData() {
    final spots = <FlSpot>[];
    
    for (int i = 0; i < _glucoseReadings.length; i++) {
      final reading = _glucoseReadings[i];
      final value = reading['value']?.toDouble() ?? 0.0;
      final date = DateTime.tryParse(reading['date'] ?? '') ?? DateTime.now();
      
      // Convert date to days ago (0 = today, 1 = yesterday, etc.)
      final daysAgo = DateTime.now().difference(date).inDays;
      spots.add(FlSpot(daysAgo.toDouble(), value));
    }
    
    // Sort by days ago (most recent first)
    spots.sort((a, b) => a.x.compareTo(b.x));
    
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatientData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.chat),
        label: Text('محادثة المريض'),
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorChatScreen(
                patientId: widget.patientId,
                patientName: widget.patientName,
              ),
            ),
          );
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPatientData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Information Card
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Patient Information',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Name', _patientDetails?['fullname'] ?? widget.patientName),
                              _buildInfoRow('Email', _patientDetails?['email'] ?? 'N/A'),
                              _buildInfoRow('Age', _getAnswerByIndex(0) ?? 'N/A'),
                              _buildInfoRow('Diabetes Type', _getAnswerByIndex(1) ?? 'N/A'),
                              _buildInfoRow('Weight Category', _getAnswerByIndex(10) ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text('عرض ملفات التحاليل الطبية'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientPdfsScreen(
                                  patientId: widget.patientId,
                                  patientName: widget.patientName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Glucose Readings Graph
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Glucose Readings (Last 7 Days)',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_glucoseReadings.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Text(
                                      'No glucose readings available for the last 7 days',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 300,
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(show: true),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toInt().toString(),
                                                style: const TextStyle(fontSize: 12),
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            getTitlesWidget: (value, meta) {
                                              final daysAgo = value.toInt();
                                              if (daysAgo == 0) return const Text('Today');
                                              if (daysAgo == 1) return const Text('Yesterday');
                                              return Text('$daysAgo days ago');
                                            },
                                          ),
                                        ),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: true),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _prepareChartData(),
                                          isCurved: true,
                                          color: Colors.teal,
                                          barWidth: 3,
                                          dotData: FlDotData(show: true),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.teal.withOpacity(0.1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Recent Readings List
                      if (_glucoseReadings.isNotEmpty) ...[
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Readings',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._glucoseReadings.take(10).map((reading) {
                                  final value = reading['value']?.toString() ?? 'N/A';
                                  final type = reading['type'] ?? 'N/A';
                                  final date = DateTime.tryParse(reading['date'] ?? '') ?? DateTime.now();
                                  
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Text(
                                        value,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text('$value mg/dL'),
                                    subtitle: Text('${type.toUpperCase()} • ${_formatDate(date)}'),
                                    trailing: Icon(
                                      _getGlucoseIcon(double.tryParse(value) ?? 0),
                                      color: _getGlucoseColor(double.tryParse(value) ?? 0),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getGlucoseIcon(double value) {
    if (value < 70) return Icons.trending_down;
    if (value > 180) return Icons.trending_up;
    return Icons.check_circle;
  }

  Color _getGlucoseColor(double value) {
    if (value < 70) return Colors.red;
    if (value > 180) return Colors.orange;
    return Colors.green;
  }
} 