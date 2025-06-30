import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diaguard1/core/service/glucose_service.dart'; // adjust this import based on your structure
import 'package:intl/intl.dart';

class ChartLabsPage extends StatefulWidget {
  final GlucoseService glucoseService;

  ChartLabsPage({required this.glucoseService});

  @override
  _ChartLabsPageState createState() => _ChartLabsPageState();
}

class _ChartLabsPageState extends State<ChartLabsPage> {
  List<FlSpot> _spots = [];
  List<String> _dayLabels = [];
  bool _loading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loading = true;
      });
      await _loadReadings();
    }
  }

  Future<void> _loadReadings() async {
    try {
      final readings = await widget.glucoseService.getReadings();
      final endDate = _selectedDate;
      final lastWeek = List.generate(
        7,
        (i) => endDate.subtract(Duration(days: 6 - i)),
      );
      Map<String, double> dayToValue = {};
      Map<String, DateTime> dayToDate = {};
      DateFormat dayFormat = DateFormat('yyyy-MM-dd');
      // Get the latest reading per day
      for (var reading in readings) {
        if (reading['date'] == null || reading['value'] == null) continue;
        DateTime date = DateTime.tryParse(reading['date']) ?? endDate;
        String dayKey = dayFormat.format(date);
        if (!dayToDate.containsKey(dayKey) ||
            date.isAfter(dayToDate[dayKey]!)) {
          dayToValue[dayKey] = (reading['value'] as num).toDouble();
          dayToDate[dayKey] = date;
        }
      }
      List<FlSpot> spots = [];
      List<String> dayLabels = [];
      for (int i = 0; i < 7; i++) {
        DateTime day = lastWeek[i];
        String dayKey = dayFormat.format(day);
        double? value = dayToValue[dayKey];
        spots.add(FlSpot(i.toDouble(), value ?? 0));
        dayLabels.add(_getArabicDay(day.weekday));
      }
      setState(() {
        _spots = spots;
        _dayLabels = dayLabels;
        _loading = false;
      });
    } catch (e) {
      print("Error loading readings: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  String _getArabicDay(int weekday) {
    switch (weekday) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مخطط الجلوكوز")),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _spots.isEmpty
              ? Center(child: Text("لا توجد بيانات"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickDate,
                          icon: Icon(Icons.calendar_today),
                          label: Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'اختر اليوم لعرض آخر 7 أيام',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 300,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 50,
                            verticalInterval: 1,
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 50,
                                reservedSize: 40,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx < 0 || idx >= _dayLabels.length)
                                    return SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _dayLabels[idx],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _spots,
                              isCurved: true,
                              color: Colors.green[700],
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.2),
                              ),
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
