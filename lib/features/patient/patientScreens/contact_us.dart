import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:diaguard1/core/theme/app_color.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  final String supportNumber = '+966-555-123-456';
  final String supportEmail = 'support@diaguard.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(52, 91, 99, 1),
              Color.fromRGBO(187, 214, 197, 0.9),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: AppColors.background,
                        child: FlutterLogo(size: 90),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Diaguard Support',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Divider(
                        thickness: 1.2,
                        color: Colors.white.withOpacity(0.25),
                        indent: 30,
                        endIndent: 30,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Icon(Icons.phone_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            supportNumber,
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.email_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              supportEmail,
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'We are here to help you 24/7.\nPlease contact us for any support or inquiries.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
