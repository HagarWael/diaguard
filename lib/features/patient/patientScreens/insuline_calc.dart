import 'package:flutter/material.dart';

class InsulinCalculatorScreen extends StatefulWidget {
  @override
  _InsulinCalculatorScreenState createState() =>
      _InsulinCalculatorScreenState();
}

class _InsulinCalculatorScreenState extends State<InsulinCalculatorScreen> {
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController ratioController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  double? result;
  bool isCalculated = false;

  void calculateInsulin() {
    final double? carbs = double.tryParse(carbsController.text);
    final double? ratio = double.tryParse(ratioController.text);
    final double? sugar = double.tryParse(sugarController.text);

    if (carbs != null && ratio != null && ratio > 0) {
      setState(() {
        result = carbs / ratio;
        isCalculated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى إدخال قيم صحيحة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void resetCalculator() {
    setState(() {
      carbsController.clear();
      ratioController.clear();
      sugarController.clear();
      result = null;
      isCalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(52, 91, 99, 1),
              Color.fromRGBO(187, 214, 197, 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'حاسبة الإنسولين',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon and Title
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(52, 91, 99, 1),
                                Color.fromRGBO(187, 214, 197, 0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calculate,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'احسب جرعة الإنسولين',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Input Fields
                        _buildInputField(
                          controller: carbsController,
                          label: 'كمية الكربوهيدرات',
                          hint: 'أدخل الكمية بالجرام',
                          icon: Icons.grain,
                        ),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: ratioController,
                          label: 'نسبة الإنسولين للكربوهيدرات',
                          hint: 'مثال: 15 (1 وحدة لكل 15 جرام)',
                          icon: Icons.tune,
                        ),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: sugarController,
                          label: 'مستوى السكر الحالي (اختياري)',
                          hint: 'أدخل مستوى السكر',
                          icon: Icons.monitor_heart,
                        ),

                        SizedBox(height: 30),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateInsulin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(52, 91, 99, 1),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate_outlined),
                              SizedBox(width: 10),
                              Text(
                                'احسب الجرعة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Reset Button
                        OutlinedButton(
                          onPressed: resetCalculator,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color.fromRGBO(52, 91, 99, 1),
                            side: BorderSide(
                              color: Color.fromRGBO(52, 91, 99, 1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 10),
                              Text(
                                'إعادة تعيين',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Result Card
                        if (isCalculated && result != null)
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(187, 214, 197, 0.9),
                                  Color.fromRGBO(52, 91, 99, 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Color.fromRGBO(52, 91, 99, 0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.medication,
                                  size: 40,
                                  color: Color.fromRGBO(52, 91, 99, 1),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'الجرعة المقترحة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${result!.toStringAsFixed(2)} وحدة',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'ملاحظة: استشر طبيبك قبل تناول أي جرعة',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color.fromRGBO(52, 91, 99, 1)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: Color.fromRGBO(52, 91, 99, 1),
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
