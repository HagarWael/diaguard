import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diaguard1/core/screens/loginscreen.dart';
import 'package:diaguard1/core/screens/loginscreen_d.dart';

late bool choice;

class AppUser extends StatefulWidget {
  const AppUser({super.key});

  @override
  _AppUserState createState() => _AppUserState();
}

class _AppUserState extends State<AppUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 231, 229, 229),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  "images/logo.jpg",
                  width: 200, // Adjust width as needed
                  height: 150, // Adjust height as needed
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF126A71), Color(0xFF50D6D6)],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildButton(
                              context,
                              "images/Doctor.png",
                              "دكتور",
                              () {
                                choice = true;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => loginscreenD(),
                                  ),
                                );
                              },
                            ),
                            _buildButton(
                              context,
                              "images/patient.png",
                              "مريض",
                              () {
                                choice = false;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'صحتك تهمنا',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF126A71),
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
    );
  }

  Widget _buildButton(
    BuildContext context,
    String imagePath,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 158,
      height: 198,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(241, 245, 241, 1),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset(imagePath, width: 80, height: 80),
            ),
            const SizedBox(height: 15),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(91, 122, 128, 1),
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
