import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:diaguard1/core/service/glucose_service.dart'; // adjust this import based on your structure

class ChartLabsPage extends StatefulWidget {
  final GlucoseService glucoseService;

  ChartLabsPage({required this.glucoseService});

  @override
  _ChartLabsPageState createState() => _ChartLabsPageState();
}

class _ChartLabsPageState extends State<ChartLabsPage> {
  List<FlSpot> _spots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    try {
      final readings = await widget.glucoseService.getReadings();

      List<FlSpot> spots = [];
      for (int i = 0; i < readings.length; i++) {
        final value = readings[i]['value'];
        if (value != null) {
          spots.add(FlSpot(i.toDouble(), (value as num).toDouble()));
        }
      }

      setState(() {
        _spots = spots;
        _loading = false;
      });
    } catch (e) {
      print("Error loading readings: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Glucose Chart")),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _spots.isEmpty
              ? Center(child: Text("No data available"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: _spots,
                        isCurved: true,
                        color: Colors.green,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
    );
  }
}
