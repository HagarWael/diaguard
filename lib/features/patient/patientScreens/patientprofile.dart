import 'package:flutter/material.dart';
import 'package:diaguard1/features/patient/chartPatient/chart_patient.dart';
import 'infopage_patient.dart';
import 'package:diaguard1/features/patient/menu/edit_patientpage.dart';
import 'package:diaguard1/features/patient/menu/twasel.dart';

class BarHome extends StatefulWidget {
  const BarHome({Key? key}) : super(key: key);

  @override
  _BarHomeState createState() => _BarHomeState();
}

class _BarHomeState extends State<BarHome> {
  PageController _pageController = PageController();
  List<Widget> _screens = [PatientInformation(), ChartLabsPage()];

  int _selectedIndex = 0;

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
          Text(
            'Patient Name', // Replace this with real data when backend is ready
            style: TextStyle(color: Colors.white, fontSize: 30),
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
              ImageIcon(
                AssetImage('assets/images/info.png'),
                color: Colors.white,
              ),
              SizedBox(width: 15),
              Text(
                'تعديل بيانات',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditPatientPage()),
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
              SizedBox(width: 15),
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
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/home.png"),
                color:
                    _selectedIndex == 0
                        ? Color.fromRGBO(52, 91, 99, 1)
                        : Color.fromRGBO(194, 218, 203, 1),
                size: 30,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/chart.png"),
                color:
                    _selectedIndex == 1
                        ? Color.fromRGBO(52, 91, 99, 1)
                        : Color.fromRGBO(194, 218, 203, 1),
                size: 30,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
