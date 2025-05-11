import 'package:flutter/material.dart';
import 'package:diaguard1/core/theme/app_color.dart';
import 'package:diaguard1/core/theme/text_styles.dart';
import 'package:diaguard1/features/patient/patientScreens/loginscreen.dart';
import 'package:diaguard1/features/doctor/drScreens/loginscreen_d.dart';
import 'package:diaguard1/widgets/gradientContainer.dart';
import 'package:diaguard1/widgets/logo_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:diaguard1/features/welcome/widgets/user_selection.dart';

class AppUser extends StatefulWidget {
  const AppUser({super.key});

  @override
  _AppUserState createState() => _AppUserState();
}

class _AppUserState extends State<AppUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              setState(() {
                if (context.locale == const Locale('en')) {
                  context.setLocale(const Locale('ar'));
                } else {
                  context.setLocale(const Locale('en'));
                }
              });
            },
          ),
        ],
      ),
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
                        "assets/images/Doctor.png",
                        tr("doctor"),
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const LoginscreenD(
                                    role: 'doctor',
                                  ), // Pass role
                            ),
                          );
                        },
                      ),
                      buildUserButton(
                        context,
                        "assets/images/patient.png",
                        tr("patient"),
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const LoginScreen(
                                    role: 'patient',
                                  ), // Pass role
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(tr("your_health_matters"), style: TextStyles.headline1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
