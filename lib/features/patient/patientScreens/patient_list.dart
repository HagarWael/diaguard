import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;   
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:diaguard1/core/theme/app_color.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/glucose_service.dart';

import 'package:diaguard1/features/patient/patientScreens/profile.dart';
import 'package:diaguard1/features/patient/patientScreens/infopage_patient.dart';
import 'package:diaguard1/features/patient/menu/edit_patientpage.dart';

import 'package:diaguard1/features/patient/chartPatient/chart_patient.dart';
import 'package:diaguard1/features/patient/menu/twasel.dart';
import 'package:diaguard1/features/welcome/screens/usertype.dart';
import 'package:diaguard1/features/patient/menu/edit_patientpage.dart';
import 'package:diaguard1/features/patient/patientScreens/calorie_calc.dart';
import 'package:diaguard1/features/patient/patientScreens/insuline_calc.dart';
import 'package:diaguard1/features/patient/patientScreens/chatbot.dart';
import 'package:diaguard1/features/patient/patientScreens/pdf_upload_screen.dart';
import 'package:diaguard1/features/patient/patientScreens/pdf_upload_screen.dart';


class BarHome extends StatefulWidget {
  final String userName;
  final AuthService authService;
  final Map<int, String>? answers;

  const BarHome({
    Key? key,
    required this.userName,
    required this.authService,
    this.answers,
  }) : super(key: key);

  @override
  _BarHomeState createState() => _BarHomeState();
}

class _BarHomeState extends State<BarHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  late List<Widget> _screens;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      PatientInformation(
        userName: widget.userName,
        authService: widget.authService,
      ),
      ChartLabsPage(
        glucoseService: GlucoseService(authService: widget.authService),
      ),
    ];
  }

  void _onPageChanged(int index) => setState(() => _selectedIndex = index);
  void _onItemTapped(int index) => _pageController.jumpToPage(index);

  Future<bool> _testToken() async {
    try {
      final token = await widget.authService.getToken();
      if (token == null) return false;
      final res = await http.get(
        Uri.parse('${widget.authService.baseUrl}/users/test-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(52, 91, 99, 0.81),
      ),
      accountName: Row(
        children: [
          const ImageIcon(AssetImage('assets/images/profile.png'),
              color: Colors.white, size: 68),
          const SizedBox(width: 10),
          Text(widget.userName,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
      accountEmail: const Text(''),
    );

    final drawerItems = ListView(
      children: [
        drawerHeader,

        ListTile(
          title: Row(
            children:  [
              Icon(Icons.person, color: Colors.white),
              SizedBox(width: 15),
              Text(
                context.locale.languageCode == 'ar'
                    ? 'الملف الشخصي'
                    : 'Profile',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  userName: widget.userName,
                  authService: widget.authService,
                  answers: widget.answers,
                ),
              ),
            );
          },
        ),
/*
        // 2) Edit Data
        ListTile(
          title: Row(
            children: const [
              ImageIcon(AssetImage('assets/images/info.png'),
                  color: Colors.white),
              SizedBox(width: 15),
              Text('تعديل البيانات',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditPatientPage(
                  userName: widget.userName,
                  authService: widget.authService,
                ),
              ),
            );
          },
        ),
*/
        // 3) Charts
        ListTile(
          title: Row(
            children:  [
              ImageIcon(AssetImage('assets/images/chart.png'),
                  color: Colors.white),
              SizedBox(width: 15),
               Text(
                context.locale.languageCode == 'ar'
                    ? 'التحاليل والرسوم'
                    : 'Charts and Labs',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChartLabsPage(
                  glucoseService:
                      GlucoseService(authService: widget.authService),
                ),
              ),
            );
          },
        ),

        // 4) Contact Us
        ListTile(
          title: Row( 
            children:  [
              ImageIcon(AssetImage('assets/images/call.png'),
                  color: Colors.white),
              SizedBox(width: 15),
               Text( 
                context.locale.languageCode == 'ar'
                    ? 'تواصل معنا'
                    : 'contact us',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
             
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => twasel()),
            );
          },
        ),

        // 5) Nutritional Chatbot
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.white),
          title: Text(
            context.locale.languageCode == 'ar'
                ? 'مساعد التغذية'
                : 'Nutritional Chatbot',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatbotPatientPage(),
              ),
            );
          },
        ),

        // Calorie Calculator
        ListTile(
          leading: const Icon(Icons.local_fire_department, color: Colors.white),
          title: Text(
            context.locale.languageCode == 'ar'
                ? 'حاسبة السعرات'
                : 'Calorie Calculator',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CalorieCalculatorScreen(),
              ),
            );
          },
        ),

        // Insulin Calculator
        ListTile(
          leading: const Icon(Icons.calculate, color: Colors.white),
          title: Text(
            context.locale.languageCode == 'ar'
                ? 'حاسبة الإنسولين'
                : 'Insulin Calculator',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InsulinCalculatorScreen(),
              ),
            );
          },
        ),

        const Divider(
            thickness: 1, color: Colors.white, indent: 30, endIndent: 30),

        // 6) Logout
        ListTile(
          title: Row(
            children: const [
              SizedBox(width: 10),
              Text('تسجيل الخروج',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
          onTap: () async {
            await widget.authService.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => AppUser()),
              (_) => false,
            );
          },
        ),
           ListTile(
      leading: Icon(Icons.picture_as_pdf, color: Colors.white),
      title: Text(
        context.locale.languageCode == 'ar'
            ? 'رفع تقارير التحاليل'
            : 'Upload Medical Reports',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfUploadScreen(),
          ),
        );
      },
    ),
    
    // ... rest of the drawer items ...
  ],
);
   
    /*// Main patient list with PDF upload as a list item
    final mainListItems = [
      // ... other list items if needed ...
      ListTile(
        leading: Icon(Icons.picture_as_pdf, color: Colors.deepPurple),
        title: Text('رفع و تحميل تقارير التحاليل الطبية'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfUploadScreen(),
            ),
          );
        },
      ),
    ];*/

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(53, 91, 93, 1), size: 30),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),

      // Drawer obeys locale direction
      endDrawer: Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? flutter.TextDirection.rtl
            : flutter.TextDirection.ltr,
        child: Drawer(
          backgroundColor: const Color.fromRGBO(52, 91, 99, 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
          child: drawerItems,
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        /*  Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.picture_as_pdf),
                label: Text('رفع وتحميل تقارير التحاليل الطبية'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfUploadScreen(),
                    ),
                  );
                },
              ),
            ),
          ),*/
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color.fromRGBO(52, 91, 99, 1),
          selectedIconTheme:
              const IconThemeData(color: Color.fromRGBO(52, 91, 99, 1)),
          unselectedItemColor: const Color.fromRGBO(194, 218, 203, 1),
          unselectedIconTheme:
              const IconThemeData(color: Color.fromRGBO(194, 218, 203, 1)),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: const Color.fromRGBO(242, 244, 241, 1),
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/home.png"), size: 30),
                label: ''),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/chart.png"), size: 30),
                label: ''),
          ],
        ),
      ),
    );
  }
}
