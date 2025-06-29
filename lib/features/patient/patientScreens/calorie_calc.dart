import 'package:flutter/material.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  @override
  _CalorieCalculatorScreenState createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String gender = 'male';
  String activity = 'sedentary';
  double? result;
  bool isCalculated = false;

  void calculateCalories() {
    final int? age = int.tryParse(ageController.text);
    final double? weight = double.tryParse(weightController.text);
    final double? height = double.tryParse(heightController.text);

    if (age != null &&
        weight != null &&
        height != null &&
        age > 0 &&
        weight > 0 &&
        height > 0) {
      double bmr;
      if (gender == 'male') {
        bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }

      double multiplier;
      switch (activity) {
        case 'light':
          multiplier = 1.375;
          break;
        case 'moderate':
          multiplier = 1.55;
          break;
        case 'active':
          multiplier = 1.725;
          break;
        default:
          multiplier = 1.2;
      }

      setState(() {
        result = bmr * multiplier;
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
      ageController.clear();
      weightController.clear();
      heightController.clear();
      gender = 'male';
      activity = 'sedentary';
      result = null;
      isCalculated = false;
    });
  }

  String getActivityText(String activity) {
    switch (activity) {
      case 'sedentary':
        return 'قليل النشاط (جلوس معظم اليوم)';
      case 'light':
        return 'نشاط خفيف (تمارين خفيفة 1-3 مرات أسبوعياً)';
      case 'moderate':
        return 'نشاط متوسط (تمارين معتدلة 3-5 مرات أسبوعياً)';
      case 'active':
        return 'نشاط عالي (تمارين شاقة 6-7 مرات أسبوعياً)';
      default:
        return 'قليل النشاط';
    }
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
                        'حاسبة السعرات الحرارية',
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
                                Icons.local_fire_department,
                                size: 50,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'احسب احتياجك اليومي',
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
                          controller: ageController,
                          label: 'العمر',
                          hint: 'أدخل عمرك بالسنوات',
                          icon: Icons.person,
                        ),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: weightController,
                          label: 'الوزن',
                          hint: 'أدخل وزنك بالكيلوجرام',
                          icon: Icons.monitor_weight,
                        ),

                        SizedBox(height: 20),

                        _buildInputField(
                          controller: heightController,
                          label: 'الطول',
                          hint: 'أدخل طولك بالسنتيمتر',
                          icon: Icons.height,
                        ),

                        SizedBox(height: 20),

                        // Gender Selection
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'الجنس',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(52, 91, 99, 1),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildGenderOption(
                                      'male',
                                      'ذكر',
                                      Icons.male,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: _buildGenderOption(
                                      'female',
                                      'أنثى',
                                      Icons.female,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Activity Level Selection
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'مستوى النشاط',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(52, 91, 99, 1),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              _buildActivityDropdown(),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Calculate Button
                        ElevatedButton(
                          onPressed: calculateCalories,
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
                                'احسب السعرات',
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
                                  Icons.local_fire_department,
                                  size: 40,
                                  color: Color.fromRGBO(52, 91, 99, 1),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'احتياجك اليومي',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${result!.toStringAsFixed(0)} سعر حراري',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(52, 91, 99, 1),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'هذا تقدير تقريبي، استشر أخصائي التغذية للحصول على خطة مخصصة',
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

  Widget _buildGenderOption(String value, String label, IconData icon) {
    bool isSelected = gender == value;
    return GestureDetector(
      onTap: () => setState(() => gender = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromRGBO(52, 91, 99, 1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected ? Color.fromRGBO(52, 91, 99, 1) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color.fromRGBO(52, 91, 99, 1),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Color.fromRGBO(52, 91, 99, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: activity,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Color.fromRGBO(52, 91, 99, 1),
          ),
          style: TextStyle(
            color: Color.fromRGBO(52, 91, 99, 1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (val) => setState(() => activity = val!),
          items: [
            DropdownMenuItem(value: 'sedentary', child: Text('قليل النشاط')),
            DropdownMenuItem(value: 'light', child: Text('نشاط خفيف')),
            DropdownMenuItem(value: 'moderate', child: Text('نشاط متوسط')),
            DropdownMenuItem(value: 'active', child: Text('نشاط عالي')),
          ],
        ),
      ),
    );
  }
}
