import 'package:diaguard1/features/patient/patientScreens/questions.dart';
import 'package:flutter/material.dart';
import 'infopage_patient.dart';
import 'package:diaguard1/features/patient/menu/twasel.dart';

class BarHome extends StatefulWidget {
  final String token; // Add token parameter
  final String name; // Add name parameter
  const BarHome({Key? key, required this.token, required this.name})
    : super(key: key);

  @override
  _BarHomeState createState() => _BarHomeState();
}

class _BarHomeState extends State<BarHome> {
  final PageController _pageController = PageController();
  late List<Widget> _screens; // Initialize dynamically
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize screens with required parameters
    _screens = [
      PatientInformation(), // Pass token and name
      QuestionScreen(),
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
          const SizedBox(width: 10), // Added spacing
          Text(
            widget.name, // Use the name passed from the constructor
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ],
      ),
      accountEmail: Text(''), // Empty email
    );

    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
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
              MaterialPageRoute(builder: (context) => QuestionScreen()),
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
                style: TextStyle(color: Colors.white, fontSize: 20),
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
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(53, 91, 93, 1),
          size: 30,
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
        physics: NeverScrollableScrollPhysics(), // Disable swiping
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
          currentIndex: _selectedIndex, // Added currentIndex
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
