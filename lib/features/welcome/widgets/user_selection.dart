import 'package:flutter/material.dart';
import 'package:diaguard1/core/theme/app_color.dart';
import 'package:diaguard1/core/theme/text_styles.dart';

Widget buildUserButton(
  BuildContext context,
  String imagePath,
  String text,
  VoidCallback onPressed,
) {
  return SizedBox(
    width: 160,
    height: 200,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        elevation: 2.0,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.zero,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyles.headline1.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
