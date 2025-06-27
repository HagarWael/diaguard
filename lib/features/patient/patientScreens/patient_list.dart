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
import 'package:diaguard1/features/patient/patientScreens/chat_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

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

  // Add this method to test the token first
Future<bool> _testToken() async {
  try {
    final token = await widget.authService.getToken();
    if (token == null) return false;
    
    print("DEBUG: Testing token...");
    
    final response = await http.get(
      Uri.parse('${widget.authService.baseUrl}/users/test-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print("DEBUG: Test token response status: ${response.statusCode}");
    print("DEBUG: Test token response body: ${response.body}");

    return response.statusCode == 200;
  } catch (e) {
    print("DEBUG: Error testing token: $e");
    return false;
  }
}

  // Updated method to get doctor information with better debugging
  // Updated method to get doctor information with timeout
Future<Map<String, dynamic>?> _getDoctorInfo() async {
  try {
    print("=== DEBUG: Starting _getDoctorInfo ===");
    
    final token = await widget.authService.getToken();
    if (token == null) {
      print("DEBUG: Token is null");
      return null;
    }
    
    print("DEBUG: Token obtained successfully");
    print("DEBUG: Base URL: ${widget.authService.baseUrl}");
    
    final decoded = JwtDecoder.decode(token);
    final role = decoded['role']?.toString();
    final userId = decoded['userId']?.toString();
    
    print("DEBUG: Decoded token - Role: $role, UserId: $userId");
    
    // If the user is a doctor, return their own info
    if (role == 'doctor') {
      print("DEBUG: User is a doctor, returning own info");
      return {
        'doctorId': userId,
        'doctorName': decoded['fullname'] ?? 'الطبيب',
        'doctorEmail': decoded['email'],
      };
    }
    
    // If the user is a patient, fetch their doctor info from the backend
    if (role == 'patient') {
      print("DEBUG: User is a patient, fetching doctor info from backend");
      
      try {
        // Construct the URL properly
        final url = '${widget.authService.baseUrl}/users/doctor-id';
        print("DEBUG: Making request to: $url");
        print("DEBUG: Using token: ${token.substring(0, 20)}...");
        
        // Add timeout to the request
        final response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        ).timeout(
          Duration(seconds: 10), // 10 second timeout
          onTimeout: () {
            print("DEBUG: Request timed out after 10 seconds");
            return http.Response('Request timed out', 504);
          },
        );

        print("DEBUG: Response status code: ${response.statusCode}");
        print("DEBUG: Response body: ${response.body}");

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          print("DEBUG: Parsed response body: $responseBody");
          
          if (responseBody['success'] == true) {
            final data = responseBody['data'];
            print("DEBUG: Response data: $data");
            
            if (data != null && data['doctorId'] != null) {
              return {
                'doctorId': data['doctorId']?.toString(),
                'doctorName': data['doctorName'] ?? 'الطبيب',
                'doctorEmail': data['doctorEmail'],
              };
            } else {
              print("DEBUG: Data or doctorId is null in response");
            }
          } else {
            print("DEBUG: Response success is false: ${responseBody['message']}");
          }
        } else if (response.statusCode == 401) {
          print("DEBUG: Unauthorized - token might be invalid");
        } else if (response.statusCode == 404) {
          print("DEBUG: Doctor not found for this patient");
        } else {
          print("DEBUG: Unexpected status code: ${response.statusCode}");
        }
      } catch (e) {
        print("DEBUG: Error fetching doctor info: $e");
        print("DEBUG: Error type: ${e.runtimeType}");
        return null;
      }
    }
    
    print("DEBUG: No valid role found or other error");
    return null;
  } catch (e) {
    print("DEBUG: Error in _getDoctorInfo: $e");
    print("DEBUG: Error type: ${e.runtimeType}");
    return null;
  }
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
      Icon(Icons.chat, color: Colors.white),
      const SizedBox(width: 15),
      Text(
        'محادثة الطبيب',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ],
  ),
  onTap: () async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(52, 91, 99, 1),
          ),
        );
      },
    );

    try {
      // First test the token
      final tokenValid = await _testToken();
      if (!tokenValid) {
        Navigator.of(context).pop(); // Hide loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Token validation failed'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final doctorInfo = await _getDoctorInfo();
      
      // Hide loading indicator
      Navigator.of(context).pop();
      
      if (doctorInfo != null && doctorInfo['doctorId'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              doctorId: doctorInfo['doctorId']!,
              doctorName: doctorInfo['doctorName'] ?? 'الطبيب',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يوجد طبيب مرتبط بحسابك'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في الاتصال بالطبيب'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
),
        Divider(thickness: 1, color: Colors.white, indent: 30, endIndent: 30),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.chat, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                'محادثة الطبيب',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          onTap: () async {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(52, 91, 99, 1),
                  ),
                );
              },
            );

            try {
              final doctorInfo = await _getDoctorInfo();
              
              // Hide loading indicator
              Navigator.of(context).pop();
              
              if (doctorInfo != null && doctorInfo['doctorId'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      doctorId: doctorInfo['doctorId']!,
                      doctorName: doctorInfo['doctorName'] ?? 'الطبيب',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('لا يوجد طبيب مرتبط بحسابك'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (e) {
              // Hide loading indicator
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('حدث خطأ في الاتصال بالطبيب'),
                  backgroundColor: Colors.red,
                ),
              );
            }
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