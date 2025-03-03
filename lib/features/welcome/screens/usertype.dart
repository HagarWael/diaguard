import 'package:flutter/material.dart';
import 'package:diaguard1/core/theme/app_color.dart';
import 'package:diaguard1/core/theme/text_styles.dart';
import 'package:diaguard1/features/patient/patientScreens/loginscreen.dart';
import 'package:diaguard1/features/doctor/drScreens/loginscreen_d.dart';
import 'package:diaguard1/features/welcome/widgets/user_selection.dart';
import 'package:diaguard1/widgets/gradientContainer.dart';
import 'package:diaguard1/widgets/logo_widget.dart';

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
          appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const LogoWidget(),
              GradientContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildUserButton(
                            context,
                            "images/Doctor.png",
                            "دكتور",
                            () {
                              choice = true;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const loginscreenD(),
                                ),
                              );
                            },
                          ),
                          buildUserButton(
                            context,
                            "images/patient.png",
                            "مريض",
                            () {
                              choice = false;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('صحتك تهمنا', style: TextStyles.headline1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
