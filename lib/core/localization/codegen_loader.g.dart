// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> _en = {
    "doctor": "Doctor",
    "patient": "Patient",
    "your_health_matters": "Your health matters",
    "login_patient": "Patient Login",
    "login_doctor": "Doctor Login",
    "full_name": "Full Name",
    "email": "Email",
    "password": "Password",
    "new_account": "Create a New Account",
    "existing_account": "existing account",
    "create_account": "Create Account",
    "login": "Login",
    "back": "Back",
    "successful": "Login Successful",
    "unsuccessful": "Login Failed",
  };
  static const Map<String, dynamic> _ar = {
    "doctor": "دكتور",
    "patient": "مريض",
    "your_health_matters": "صحتك تهمنا",
    "login_patient": "تسجيل الدخول للمريض",
    "login_doctor": "تسجيل الدخول للطبيب",
    "full_name": "الاسم كامل",
    "email": "حساب البريد",
    "password": "كلمة السر",
    "new_account": "إنشاء حساب جديد",
    "existing_account": "لدي حساب قديم",
    "create_account": "إنشاء الحساب",
    "login": "تسجيل الدخول",
    "back": "رجوع",
    "successful": "تم تسجيل الدخول بنجاح",
    "unsuccessful": "فشل تسجيل الدخول",
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": _en,
    "ar": _ar,
  };
}
