// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:open_file/open_file.dart';
// import 'dart:io';

// class ChartData {
//   ChartData(this.x, this.y);
//   final String x;
//   final double y;
// }

// class ChartLabsPage extends StatefulWidget {
//   @override
//   _ChartLabsPageState createState() => _ChartLabsPageState();
// }

// class _ChartLabsPageState extends State<ChartLabsPage> {
//   late File? file;
//   late TooltipBehavior _tooltipBehavior;
//   bool isSwitched = false;

//   final List<ChartData> chartDataBefore = [];
//   final List<ChartData> chartDataAfter = [];

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     getLabs();
//     super.initState();
//   }

//   void getLabs() {
//     // lsa msh dlw2ty 3shan bsimulate fetching lab data locally
//     setState(() {
//       _cardListFiles.add(createCardFile("path/to/lab1.pdf"));
//       _cardListFiles.add(createCardFile("path/to/lab2.pdf"));
//     });
//   }

//   late double screenHeight;
//   late double screenWidth;
//   late double textScale;

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     textScale = MediaQuery.of(context).textScaleFactor;

//     // Simulated data for the chart
//     final List<ChartData> beforeReadings = [
//       // Marked as final
//       ChartData('Mon', 120),
//       ChartData('Tue', 130),
//       ChartData('Wed', 110),
//       ChartData('Thu', 140),
//       ChartData('Fri', 125),
//       ChartData('Sat', 135),
//       ChartData('Sun', 115),
//     ];

//     final List<ChartData> afterReadings = [
//       // Marked as final
//       ChartData('Mon', 180),
//       ChartData('Tue', 190),
//       ChartData('Wed', 170),
//       ChartData('Thu', 200),
//       ChartData('Fri', 185),
//       ChartData('Sat', 195),
//       ChartData('Sun', 175),
//     ];

//     return SafeArea(
//       child: Scaffold(
//         body: Align(
//           alignment: Alignment.center,
//           child: ListView(
//             children: [
//               Container(
//                 height: screenHeight * 0.42,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: SfCartesianChart(
//                       primaryXAxis: CategoryAxis(),
//                       legend: Legend(
//                         isVisible: true,
//                         position: LegendPosition.top,
//                       ),
//                       tooltipBehavior: _tooltipBehavior,
//                       series: <LineSeries>[
//                         LineSeries<ChartData, String>(
//                           name: "صائم",
//                           color: Color.fromRGBO(52, 91, 99, 1),
//                           dataSource: beforeReadings,
//                           xValueMapper: (ChartData data, _) => data.x,
//                           yValueMapper: (ChartData data, _) => data.y,
//                           dataLabelSettings: DataLabelSettings(isVisible: true),
//                         ),
//                         LineSeries<ChartData, String>(
//                           name: "غير صائم",
//                           color: Color.fromRGBO(187, 214, 197, 1),
//                           dataSource: afterReadings,
//                           xValueMapper: (ChartData data, _) => data.x,
//                           yValueMapper: (ChartData data, _) => data.y,
//                           dataLabelSettings: DataLabelSettings(isVisible: true),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: () {},
//                     icon: Icon(Icons.arrow_back_ios),
//                     color: Color.fromRGBO(52, 91, 99, 1),
//                     iconSize: 18,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
//                     child: Text(
//                       'الاسبوع الاول',
//                       style: TextStyle(
//                         color: Color.fromRGBO(52, 91, 99, 1),
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: Icon(Icons.arrow_forward_ios),
//                     color: Color.fromRGBO(52, 91, 99, 1),
//                     iconSize: 18,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 20.0),
//                   child: Text(
//                     "المختبرات",
//                     style: TextStyle(color: Colors.black, fontSize: 30),
//                     textAlign: TextAlign.end,
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 right: 20,
//                                 top: 10,
//                                 left: 0,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(14),
//                                   ),
//                                   border: Border.all(
//                                     color: Color.fromRGBO(218, 228, 229, 1),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 height: screenHeight * 0.22,
//                                 width: screenWidth * 0.30,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 27),
//                                   child: Column(
//                                     children: [
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Color.fromRGBO(
//                                             91,
//                                             122,
//                                             129,
//                                             1,
//                                           ),
//                                           shape: CircleBorder(),
//                                           padding: EdgeInsets.all(10),
//                                         ),
//                                         onPressed: () async {
//                                           final result =
//                                               await FilePicker.platform
//                                                   .pickFiles();
//                                           if (result == null) return;
//                                           final path =
//                                               result.files.single.path!;
//                                           setState(() => file = File(path));
//                                           _cardListFiles.add(
//                                             createCardFile(path),
//                                           );
//                                         },
//                                         child: Icon(
//                                           Icons.add,
//                                           size: 40 * textScale,
//                                         ),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.center,
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                             top: 3.0,
//                                           ),
//                                           child: Text(
//                                             'اضف نتيجة\nجديدة',
//                                             style: TextStyle(
//                                               color: Color.fromRGBO(
//                                                 91,
//                                                 122,
//                                                 129,
//                                                 1,
//                                               ),
//                                               fontSize: 25 * textScale,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(width: 5),
//                         Directionality(
//                           textDirection: TextDirection.rtl,
//                           child: Row(children: _Call_list_files()),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   final List<Widget> _cardListFiles = [];
//   List<Widget> _Call_list_files() {
//     return _cardListFiles;
//   }

//   Widget createCardFile(String path) {
//     return InkWell(
//       onTap: () => OpenFile.open(path),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
//         child: Container(
//           height: screenHeight * 0.22,
//           width: screenWidth * 0.30,
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(218, 228, 229, 1),
//             borderRadius: BorderRadius.all(Radius.circular(14)),
//             border: Border.all(
//               color: Color.fromRGBO(218, 228, 229, 1),
//               width: 2,
//             ),
//           ),
//           child: Card(
//             elevation: 0,
//             color: Color.fromRGBO(218, 228, 229, 1),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(1.0),
//                   child: Image(
//                     image: AssetImage('images/lab.png'),
//                     height: screenHeight * 0.1,
//                     width: screenWidth * 0.1,
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 3.0),
//                     child: Text(
//                       'نتيجة المختبر ',
//                       style: TextStyle(
//                         color: Color.fromRGBO(91, 122, 129, 1),
//                         fontSize: 25 * textScale,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
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
