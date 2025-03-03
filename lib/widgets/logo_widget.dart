import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Image.asset(
        "images/logo.jpg",
        width: 200,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}
