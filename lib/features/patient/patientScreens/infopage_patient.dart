import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui';
import 'package:date_format/date_format.dart';

late double before;
late double after;
late int tag;
late String period;
late String cardDay;
late String amPm;
late String wa2t;
late String arabicDay;
late String englishDay;

class PatientInformation extends StatefulWidget {
  @override
  _PatientInformationState createState() => _PatientInformationState();
}

DateTime dt = DateTime.now();
intl.DateFormat formatter = intl.DateFormat('dd-MM-yyyy');
DateTime day = DateTime.now();
intl.DateFormat ww = intl.DateFormat('EEEE');

class _PatientInformationState extends State<PatientInformation> {
  final _reading = TextEditingController();
  late double screenHeight;
  late double screenWidth;
  late double textScale;
  bool loading = true;

  List<double> beforeReadings = [];
  List<String> beforeReadingsDateArabic = [];
  List<double> afterReadings = [];
  List<String> afterReadingsDateArabic = [];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    textScale = MediaQuery.of(context).textScaleFactor;

    String namePA = "هاجر وائل "; // Replace with actual patient name

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Welcome statement with name of user
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Center(
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage('assets/images/call.png'),
                          size: 80,
                          color: Color.fromRGBO(117, 121, 122, 1),
                        ),
                        Column(
                          children: [
                            Text(
                              'مرحبا',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color.fromRGBO(139, 139, 139, 1),
                              ),
                            ),
                            Text(namePA, style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// Two buttons "before" & "after"
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            'صائم',
                            style: TextStyle(fontSize: 25 * textScale),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: CircleBorder(),
                            ),
                            child: Container(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/afterButton.png',
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(
                                      0,
                                      8,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  expand: true,
                                  builder:
                                      (context) => BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 15,
                                          sigmaY: 15,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: screenHeight * 0.7,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                ),
                                              ),
                                              child: ListView(
                                                children: <Widget>[
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 30.0,
                                                      ),
                                                      child: IconButton(
                                                        onPressed:
                                                            () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(),
                                                        icon: Icon(
                                                          Icons.close,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              bottom: 15.0,
                                                            ),
                                                        child: Text(
                                                          'ادخال القراءة و انت صائم',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            color:
                                                                Color.fromRGBO(
                                                                  52,
                                                                  91,
                                                                  99,
                                                                  1,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      width: 204,
                                                      child: TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: _reading,
                                                        decoration: InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                vertical: 22.0,
                                                              ),
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  Color.fromRGBO(
                                                                    219,
                                                                    228,
                                                                    230,
                                                                    1,
                                                                  ),
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  18.0,
                                                                ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color:
                                                                          Color.fromRGBO(
                                                                            219,
                                                                            228,
                                                                            230,
                                                                            1,
                                                                          ),
                                                                      width:
                                                                          3.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      18.0,
                                                                    ),
                                                              ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                        133,
                                                                        165,
                                                                        171,
                                                                        1,
                                                                      ),
                                                                  width: 3.0,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  18.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 20.0,
                                                      ),
                                                      child: SizedBox(
                                                        height: 54,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            fixedSize: Size(
                                                              204,
                                                              37,
                                                            ),
                                                            textStyle:
                                                                TextStyle(
                                                                  fontSize:
                                                                      20 *
                                                                      textScale,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    52,
                                                                  ),
                                                            ),
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                  52,
                                                                  91,
                                                                  99,
                                                                  1,
                                                                ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              time();
                                                              timeInEnglish();
                                                              tag = 1;
                                                              before =
                                                                  double.parse(
                                                                    _reading
                                                                        .text,
                                                                  );
                                                              if (before <= 0) {
                                                                showDialog<
                                                                  String
                                                                >(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (
                                                                        BuildContextcontext,
                                                                      ) => AlertDialog(
                                                                        title: const Text(
                                                                          'ERROR',
                                                                        ),
                                                                        content:
                                                                            const Text(
                                                                              'الرقم الذي ادخلته خاطئ  , الرجاء اعادة ادخال الرقم ',
                                                                            ),
                                                                        actions: <
                                                                          Widget
                                                                        >[
                                                                          TextButton(
                                                                            onPressed:
                                                                                () => Navigator.pop(
                                                                                  context,
                                                                                  'OK',
                                                                                ),
                                                                            child: const Text(
                                                                              'OK',
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                );
                                                              } else {
                                                                beforeReadings
                                                                    .add(
                                                                      before,
                                                                    );
                                                                beforeReadingsDateArabic
                                                                    .add(
                                                                      cardDay,
                                                                    );
                                                                _reading
                                                                    .clear();
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              }
                                                            });
                                                          },
                                                          child: Text(
                                                            'ادخال القراءة',
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          children: [
                            Text(
                              'غير صائم',
                              style: TextStyle(fontSize: 25 * textScale),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: CircleBorder(),
                              ),
                              child: Container(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/beforeButton.png',
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(
                                        0,
                                        8,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    expand: true,
                                    builder:
                                        (context) => BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 15,
                                            sigmaY: 15,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: screenHeight * 0.7,
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(30),
                                                        topRight:
                                                            Radius.circular(30),
                                                      ),
                                                ),
                                                child: ListView(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 30.0,
                                                            ),
                                                        child: IconButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.of(
                                                                    context,
                                                                  ).pop(),
                                                          icon: Icon(
                                                            Icons.close,
                                                            size: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                bottom: 15.0,
                                                              ),
                                                          child: Text(
                                                            'ادخال القراءة و انت غير صائم ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  30 *
                                                                  textScale,
                                                              color:
                                                                  Color.fromRGBO(
                                                                    52,
                                                                    91,
                                                                    99,
                                                                    .6,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: SizedBox(
                                                        width: 204,
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: _reading,
                                                          decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  vertical:
                                                                      22.0,
                                                                ),
                                                            border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Color.fromRGBO(
                                                                          219,
                                                                          228,
                                                                          230,
                                                                          1,
                                                                        ),
                                                                    width: 1.5,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    18.0,
                                                                  ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Color.fromRGBO(
                                                                          187,
                                                                          214,
                                                                          197,
                                                                          .54,
                                                                        ),
                                                                    width: 1.5,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    18.0,
                                                                  ),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Color.fromRGBO(
                                                                          187,
                                                                          214,
                                                                          197,
                                                                          1,
                                                                        ),
                                                                    width: 3.0,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    18.0,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              top: 20.0,
                                                            ),
                                                        child: SizedBox(
                                                          height: 54,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              fixedSize: Size(
                                                                204,
                                                                37,
                                                              ),
                                                              textStyle:
                                                                  TextStyle(
                                                                    fontSize:
                                                                        20 *
                                                                        textScale,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      52,
                                                                    ),
                                                              ),
                                                              backgroundColor:
                                                                  Color.fromRGBO(
                                                                    187,
                                                                    214,
                                                                    197,
                                                                    1,
                                                                  ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                time();
                                                                timeInEnglish();
                                                                tag = 0;
                                                                after =
                                                                    double.parse(
                                                                      _reading
                                                                          .text,
                                                                    );
                                                                if (after <=
                                                                    0) {
                                                                  showDialog<
                                                                    String
                                                                  >(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (
                                                                          BuildContextcontext,
                                                                        ) => AlertDialog(
                                                                          title: const Text(
                                                                            'ERROR',
                                                                          ),
                                                                          content: const Text(
                                                                            'الرقم الذي ادخلته خاطئ  , الرجاء اعادة ادخال الرقم ',
                                                                          ),
                                                                          actions: <
                                                                            Widget
                                                                          >[
                                                                            TextButton(
                                                                              onPressed:
                                                                                  () => Navigator.pop(
                                                                                    context,
                                                                                    'OK',
                                                                                  ),
                                                                              child: const Text(
                                                                                'OK',
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  );
                                                                } else {
                                                                  afterReadings
                                                                      .add(
                                                                        after,
                                                                      );
                                                                  afterReadingsDateArabic
                                                                      .add(
                                                                        cardDay,
                                                                      );
                                                                  _reading
                                                                      .clear();
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            child: const Text(
                                                              'ادخال القراءة ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Title of readings
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 25),
                        child: Text(
                          'القراءات',
                          style: TextStyle(fontSize: 40 * textScale),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Row of "before readings"
                SingleChildScrollView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: callingListBefore(
                      beforeReadings,
                      beforeReadingsDateArabic,
                    ),
                  ),
                ),

                /// Row of "after readings"
                SingleChildScrollView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: callingListAfter(
                      afterReadings,
                      afterReadingsDateArabic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Before readings list
  List<Widget> callingListBefore(List<double> readings, List<String> dates) {
    cardListBefore.clear();
    fillCardsBefore(readings, dates);
    return cardListBefore;
  }

  void fillCardsBefore(List<double> readings, List<String> dates) {
    for (var i = readings.length - 1; i >= 0; i--) {
      String read = readings[i].toString();
      String date = dates[i].toString();
      cardListBefore.add(beforeCard(read, date));
    }
  }

  Widget beforeCard(final String read, final String dateC) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20),
        child: Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: Color.fromRGBO(52, 91, 99, 0.81),
          elevation: 10.0,
          child: SizedBox(
            height: screenHeight * 0.15,
            width: screenWidth * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'صائم',
                        style: TextStyle(
                          fontSize: 20 * textScale,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        double.parse(read) >= 130.0
                            ? 'مرتفع'
                            : double.parse(read) <= 80.0
                            ? 'منخفض'
                            : 'طبيعي',
                        style: TextStyle(
                          fontSize: 40 * textScale,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$dateC',
                        style: TextStyle(
                          fontSize: 12 * textScale,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$read',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// After readings list
  List<Widget> callingListAfter(List<double> readings, List<String> dates) {
    cardListAfter.clear();
    fillCardsAfter(readings, dates);
    return cardListAfter;
  }

  void fillCardsAfter(List<double> readings, List<String> dates) {
    for (var i = readings.length - 1; i >= 0; i--) {
      String read = readings[i].toString();
      String date = dates[i].toString();
      cardListAfter.add(afterCard(read, date));
    }
  }

  Widget afterCard(final String read, final String dateC) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0, left: 20),
      child: Card(
        margin: const EdgeInsets.only(bottom: 14.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Color.fromRGBO(187, 214, 197, 0.9),
        elevation: 10.0,
        child: SizedBox(
          height: screenHeight * 0.15,
          width: screenWidth * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 15.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'غير صائم',
                      style: TextStyle(
                        fontSize: 20 * textScale,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      //TODO this should be a variable depending on the users reading , compare to baseline thr print the state , normal , high, low
                      double.parse(read) >= 180.0
                          ? 'مرتفع'
                          : double.parse(read) <= 130.0
                          ? 'منخفض'
                          : 'طبيعي',
                      style: TextStyle(
                        fontSize: 40 * textScale,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$dateC',
                      style: TextStyle(
                        fontSize: 12 * textScale,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$read',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Text(formattedDate(
              //     document.data()['data']
              // )
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String time() {
    dt = DateTime.now();
    period = formatDate(dt, [HH, ':', mm]);
    amPm = intl.DateFormat('a').format(dt).toString();

    if (amPm == 'AM')
      wa2t = 'صباحا';
    else
      wa2t = 'مساءا';

    if (dt.weekday == 1)
      arabicDay = 'الاثنين'; //monday
    else if (dt.weekday == 2)
      arabicDay = 'الثلثاء'; //tues
    else if (dt.weekday == 3)
      arabicDay = 'الاربعاء'; //wed
    else if (dt.weekday == 4)
      arabicDay = 'الخميس'; //thurs
    else if (dt.weekday == 5)
      arabicDay = 'الحمعة'; //fri
    else if (dt.weekday == 6)
      arabicDay = 'السبت'; //sat
    else if (dt.weekday == 7)
      arabicDay = 'الاحد';
    //sun
    return cardDay = '$arabicDay' + ' - ' + '$period' + ' - ' + '$wa2t';
  }

  String timeInEnglish() {
    dt = DateTime.now();
    if (dt.weekday == 1)
      englishDay = 'mon'; //monday
    else if (dt.weekday == 2)
      englishDay = 'tues'; //tues
    else if (dt.weekday == 3)
      englishDay = 'wed'; //wed
    else if (dt.weekday == 4)
      englishDay = 'thurs'; //thurs
    else if (dt.weekday == 5)
      englishDay = 'fri'; //fri
    else if (dt.weekday == 6)
      englishDay = 'sat'; //sat
    else if (dt.weekday == 7)
      englishDay = 'sun';
    //sun
    return '$englishDay';
  }

  @override
  void initState() {
    super.initState();
    // checkDate();
    //WidgetsBinding.instance.addPostFrameCallback((_) => checkDate());
    beforeCard;
    afterCard;
    callingListBefore;
    fillCardsAfter;
    callingListAfter;
    fillCardsBefore;
    cardListBefore;
    cardListAfter;
  }

  @override
  void dispose() {
    _reading.clear();
    _reading.dispose();
    super.dispose();
  }
}

List<Widget> cardListBefore = [];
List<Widget> cardListAfter = [];
