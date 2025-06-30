// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:diaguard1/features/questionnaire/data/question_data.dart';

// final intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');

// bool selected = false;
// String time = 'اليوم - الشهر - السنة';
// final _time = TextEditingController();

// class RegistrationPatientPage extends StatefulWidget {
//   final String phone;
//   RegistrationPatientPage({required this.phone});

//   @override
//   _RegistrationPatientPageState createState() =>
//       _RegistrationPatientPageState();
// }

// class _RegistrationPatientPageState extends State<RegistrationPatientPage> {
//   final _formKey = GlobalKey<FormState>();
//   late String namePatient;
//   late String heightPatient;
//   late String weightPatient;
//   late String doctorId;
//   late String DateOfPatient;
//   late String nationalNumberPatient;

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("images/gradient.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Align(
//           alignment: Alignment.bottomLeft,
//           child: Scrollbar(
//             child: ListView(
//               shrinkWrap: true,
//               children: [
//                 AnimatedContainer(
//                   duration: Duration(milliseconds: 1000),
//                   curve: Curves.linear,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40.0),
//                       topRight: Radius.circular(40.0),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Form(
//                         key: _formKey,
//                         child: Container(
//                           color: Colors.white,
//                           margin: EdgeInsets.fromLTRB(25, 25, 25, 10),
//                           height:
//                               selected
//                                   ? screenHeight * 0.9
//                                   : screenHeight * 0.75,
//                           child: Directionality(
//                             textDirection: TextDirection.rtl,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               textDirection: TextDirection.rtl,
//                               children: [
//                                 TextFormField(
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'هذه الخانة مطلوبه';
//                                     } else {
//                                       namePatient = value;
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     labelText: 'الاسم',
//                                     hintText: 'الرجاء ادخال الاسم الثلاثي',
//                                     labelStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Color.fromRGBO(178, 178, 178, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 TextFormField(
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'هذه الخانة مطلوبه';
//                                     } else {
//                                       nationalNumberPatient = value;
//                                     }
//                                   },
//                                   maxLength: 10,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     counter: SizedBox.shrink(),
//                                     labelText: 'الرقم الوطني',
//                                     hintText: 'xxxxxxxxxx',
//                                     labelStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Color.fromRGBO(178, 178, 178, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'نوع السكري',
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     // DiabetesType(), // Replace with your own widget
//                                   ],
//                                 ),
//                                 TextFormField(
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'هذه الخانة مطلوبه';
//                                     } else {
//                                       DateOfPatient = value;
//                                     }
//                                   },
//                                   controller: _time,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     focusColor: Color.fromRGBO(
//                                       178,
//                                       178,
//                                       178,
//                                       1,
//                                     ),
//                                     labelText: 'تاريخ الميلاد',
//                                     hintText: 'اليوم - الشهر - السنة',
//                                     labelStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Color.fromRGBO(178, 178, 178, 1),
//                                     ),
//                                     suffixIconColor: Color.fromRGBO(
//                                       178,
//                                       178,
//                                       178,
//                                       1,
//                                     ),
//                                     suffixIcon: IconButton(
//                                       onPressed: () async {
//                                         final myDateTime = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(),
//                                           firstDate: DateTime(1920),
//                                           lastDate: DateTime(2025),
//                                         );
//                                         setState(() {
//                                           time = intl.DateFormat(
//                                             'dd-MM-yyyy',
//                                           ).format(myDateTime!);
//                                           _time.text = time;
//                                         });
//                                       },
//                                       icon: Icon(Icons.calendar_today),
//                                     ),
//                                   ),
//                                   onTap: () async {
//                                     final myDateTime = await showDatePicker(
//                                       context: context,
//                                       initialDate: DateTime.now(),
//                                       firstDate: DateTime(1920),
//                                       lastDate: DateTime(2025),
//                                     );
//                                     setState(() {
//                                       time = intl.DateFormat(
//                                         'dd-MM-yyyy',
//                                       ).format(myDateTime!);
//                                       _time.text = time;
//                                     });
//                                   },
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     SizedBox(
//                                       width: 140,
//                                       child: TextFormField(
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'هذه الخانة مطلوبه';
//                                           } else {
//                                             heightPatient = value;
//                                           }
//                                         },
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                           labelText: 'الطول',
//                                           labelStyle: TextStyle(
//                                             fontSize: 18,
//                                             color: Colors.black,
//                                           ),
//                                           hintStyle: TextStyle(
//                                             fontSize: 18,
//                                             color: Color.fromRGBO(
//                                               178,
//                                               178,
//                                               178,
//                                               1,
//                                             ),
//                                           ),
//                                           hintText: 'م',
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 140,
//                                       child: TextFormField(
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'هذه الخانة مطلوبه';
//                                           } else {
//                                             weightPatient = value;
//                                           }
//                                         },
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                           labelText: 'الوزن',
//                                           labelStyle: TextStyle(
//                                             fontSize: 18,
//                                             color: Colors.black,
//                                           ),
//                                           hintStyle: TextStyle(
//                                             fontSize: 18,
//                                             color: Color.fromRGBO(
//                                               178,
//                                               178,
//                                               178,
//                                               1,
//                                             ),
//                                           ),
//                                           hintText: 'كج',
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 TextFormField(
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'هذه الخانة مطلوبه';
//                                     } else {
//                                       doctorId = value;
//                                     }
//                                   },
//                                   maxLength: 5,
//                                   decoration: InputDecoration(
//                                     counter: SizedBox.shrink(),
//                                     labelText: 'رمز الدكتور',
//                                     hintText: 'xxxxx',
//                                     labelStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       fontSize: 18,
//                                       color: Color.fromRGBO(178, 178, 178, 1),
//                                     ),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Color.fromRGBO(
//                                       189,
//                                       208,
//                                       201,
//                                       1,
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(14.0),
//                                     ),
//                                     minimumSize: Size(308, 35),
//                                   ),
//                                   onPressed: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Processing data'),
//                                         ),
//                                       );

//                                       // Simulate saving data locally
//                                       print('Name: $namePatient');
//                                       print(
//                                         'National Number: $nationalNumberPatient',
//                                       );
//                                       print('Date of Birth: $DateOfPatient');
//                                       print('Height: $heightPatient');
//                                       print('Weight: $weightPatient');
//                                       print('Doctor ID: $doctorId');

//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //     builder:
//                                       //         (context) =>
//                                       //            , // Replace with your next screen
//                                       //   ),
//                                       // );
//                                     }
//                                   },
//                                   child: Text(
//                                     'التالي',
//                                     style: TextStyle(fontSize: 22),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
