import 'package:diaguard1/features/patient/patientScreens/questions.dart';
import 'package:flutter/material.dart';
import 'infopage_patient.dart';
import 'package:diaguard1/features/patient/menu/twasel.dart';
import 'package:diaguard1/core/theme/app_color.dart';
import 'package:diaguard1/features/patient/menu/edit_patientpage.dart';
import 'package:diaguard1/features/patient/chartPatient/chart_patient.dart';
import 'package:diaguard1/core/service/auth.dart';
import 'package:diaguard1/core/service/glucose_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:diaguard1/features/patient/patientScreens/profile.dart';
import 'package:diaguard1/features/welcome/screens/usertype.dart';

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

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Color.fromRGBO(52, 91, 99, 0.81)),
      accountName: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageIcon(
            AssetImage('assets/images/profile.png'),
            color: Colors.white,
            size: 68,
          ),
          const SizedBox(width: 10),
          Text(
            widget.userName,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
      accountEmail: Text(''),
    );

    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                'الملف الشخصي',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProfileScreen(
                      userName: widget.userName,
                      authService: widget.authService,
                      answers: widget.answers,
                    ),
              ),
            );
          },
        ),
        ListTile(
          title: Row(
            children: [
              ImageIcon(
                AssetImage('assets/images/info.png'),
                color: Colors.white,
              ),
              const SizedBox(width: 15),
              Text(
                'تعديل بيانات',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChartLabsPage(
                      glucoseService: GlucoseService(
                        authService: widget.authService,
                      ),
                    ),
              ),
            );
          },
        ),
        Divider(thickness: 1, color: Colors.white, indent: 30, endIndent: 30),
        ListTile(
          title: Row(
            children: [
              ImageIcon(
                AssetImage('assets/images/call.png'),
                color: Colors.white,
              ),
              const SizedBox(width: 15),
              Text(
                'تواصل معنا',
                style: TextStyle(color: AppColors.background, fontSize: 20),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => twasel()),
            );
          },
        ),
        Divider(thickness: 1, color: Colors.white, indent: 30, endIndent: 30),
        ListTile(
          title: Row(
            children: [
              // ImageIcon(
              // //  AssetImage('assets/images/logout.png'),
              //   color: Colors.white,
              // ),
              const SizedBox(width: 10),
              Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () async {
            try {
              await widget.authService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const AppUser(),
                ),
                (Route<dynamic> route) => false,
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Failed to logout: $e')));
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(53, 91, 93, 1),
          size: 30,
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
          ),
        ],
      ),
      endDrawer: Directionality(
        textDirection: TextDirection.rtl,
        child: Drawer(
          backgroundColor: Color.fromRGBO(52, 91, 99, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
          child: drawerItems,
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Color.fromRGBO(52, 91, 99, 1),
          selectedIconTheme: IconThemeData(
            color: Color.fromRGBO(52, 91, 99, 1),
          ),
          unselectedItemColor: Color.fromRGBO(194, 218, 203, 1),
          unselectedIconTheme: IconThemeData(
            color: Color.fromRGBO(194, 218, 203, 1),
          ),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color.fromRGBO(242, 244, 241, 1),
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/home.png"), size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/chart.png"), size: 30),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
