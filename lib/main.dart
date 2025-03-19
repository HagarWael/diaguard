import 'package:diaguard1/features/patient/menu/edit_patientpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:diaguard1/features/welcome/screens/usertype.dart';
import 'package:diaguard1/features/patient/patientScreens/questions.dart';
import 'package:diaguard1/features/questionnaire/bloC/questionBloC.dart';
import 'package:diaguard1/features/patient/patientScreens/infopage_patient.dart';
import 'package:diaguard1/features/patient/patientScreens/patient_list.dart';
import 'package:diaguard1/features/patient/menu/patient_page.dart';
import 'package:diaguard1/features/patient/chartPatient/chart_patient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/language',
      fallbackLocale: Locale('en'),
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => QuestionBloc())],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diaguard App',
      theme: ThemeData(primarySwatch: Colors.teal),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: AppUser(),
    );
  }
}

//usertype: choose=>patientlogin 
//                   
//loginpatient => patient profile =>
//                   | |
//                    V
//        glugose, gamifications,labs
// request to specific doc

//loginDoctor => options patient
            // choose on of them 
            //see userprofile(important information)
