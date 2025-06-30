import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationService {
  static void changeLocale(BuildContext context, Locale newLocale) {
    context.setLocale(newLocale);
  }
}
