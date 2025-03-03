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
    width: 158,
    height: 198,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Image.asset(imagePath, width: 80, height: 80),
          ),
          const SizedBox(height: 15),
          Text(text, style: TextStyles.headline1),
        ],
      ),
    ),
  );
}
