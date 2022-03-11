import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/pages/edit_info_page.dart';
import 'package:suivie_diplome/pages/president/check_student_by_stats.dart';
import 'package:suivie_diplome/pages/president/search_page.dart';
import 'package:suivie_diplome/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../login_page_admin.dart';

class DipData {
  final String diplomaSymbol;
  final int numberOfDiplomes;

  DipData(this.diplomaSymbol, this.numberOfDiplomes);
}

class PresidentFinalHomePage extends StatefulWidget {
  PresidentFinalHomePage({required this.saNom, required this.saEmail});
  final String saNom, saEmail;

  @override
  State<PresidentFinalHomePage> createState() => _PresidentFinalHomePageState();
}

class _PresidentFinalHomePageState extends State<PresidentFinalHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<DipData> _chartData;
  late List<DipData> _chartDataNonSuccess;
  late TooltipBehavior _tooltipBehavior;
  var dipNonEdite;
  var dipNonAccepte;
  var dipNonSigne;
  var dipNonRemis;

  List<DipData> getDipNonChartData() {
    List<DipData> chartDataNonSucces = [];

    Future<void> getEtudData() async {
      var connection = PostgresConnection.getDBconnection();
      try {
        await connection.open();
      } catch (e) {
        print(e);
      }

      var result = await connection.query(
          "select count( dp_edition ) from diplome where dp_edition = false");

      dipNonEdite = result[0][0];

      result = await connection.query(
          "select count( dp_verification ) from diplome where dp_verification = false");

      dipNonAccepte = result[0][0];

      result = await connection.query(
          "select count( dp_presid_signa ) from diplome where dp_presid_signa = false");

      dipNonSigne = result[0][0];

      result = await connection.query(
          "select count( dp_remis ) from diplome where dp_remis = false");

      dipNonRemis = result[0][0];

      setState(() {
        chartDataNonSucces.add(DipData("Non Edite", dipNonEdite));
        chartDataNonSucces.add(DipData("Non Accepte", dipNonAccepte));
        chartDataNonSucces.add(DipData("Non Signe", dipNonSigne));
        chartDataNonSucces.add(DipData("Non Remis", dipNonRemis));
      });

      print(result);

      await connection.close();
    }

    getEtudData();

    return chartDataNonSucces;
  }

  var dipEdite;
  var dipAccepte;
  var dipSigne;
  var dipRemis;

  List<DipData> getDipChartData() {
    List<DipData> chartData = [];

    Future<void> getEtudData() async {
      var connection = PostgresConnection.getDBconnection();
      try {
        await connection.open();
      } catch (e) {
        print(e);
      }

      var result = await connection.query(
          "select count( dp_edition ) from diplome where dp_edition = true");

      dipEdite = result[0][0];

      result = await connection.query(
          "select count( dp_verification ) from diplome where dp_verification = true");

      dipAccepte = result[0][0];

      result = await connection.query(
          "select count( dp_presid_signa ) from diplome where dp_presid_signa = true");

      dipSigne = result[0][0];

      result = await connection
          .query("select count( dp_remis ) from diplome where dp_remis = true");

      dipRemis = result[0][0];

      setState(() {
        chartData.add(DipData("Edite", dipEdite));
        chartData.add(DipData("Accepte", dipAccepte));
        chartData.add(DipData("Signe", dipSigne));
        chartData.add(DipData("Remis", dipRemis));
      });

      print(result);

      await connection.close();
    }

    getEtudData();

    return chartData;
  }

  var _currentIndex = 0;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = getDipChartData();
    _chartDataNonSuccess = getDipNonChartData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xffF7F8FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditInfoPage(saEmail: widget.saEmail, saNom: widget.saNom, saRole: "P");
              }));
            },
            icon: const Icon(
              FontAwesomeIcons.user,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      child: CircleAvatar(
                        child: Image.asset('images/mayor.png',width: 70,),
                        radius: 50,
                        backgroundColor: Colors.white,
                        // foregroundImage: AssetImage('images/mayor.png'),
                      ),
                      backgroundColor: primaryColor,
                      radius: 53,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Mr. President',
                      style: GoogleFonts.balooBhaijaan(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Afficher tout les etudiants'),
                  leading: Icon(Icons.person_search_rounded),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SearchStudentPage(saRole: 'P', saNom: widget.saNom, saEmail: widget.saEmail,);
                    }));
                  },
                ),
                Divider(),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 54,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return LogInPageAdmin();
                        }), (route) => false);
                  },
                  child: Text(
                    'Se déconnecter',
                    style: GoogleFonts.balooBhaijaan(color: primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xffF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                items: [
                  Container(
                    height: 250,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(width: 3, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SfCircularChart(
                      tooltipBehavior: _tooltipBehavior,
                      title: ChartTitle(text: "Diplomes Traite"),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      series: <CircularSeries>[
                        PieSeries<DipData, String>(
                          dataSource: _chartData,
                          xValueMapper: (DipData data, _) =>
                              data.diplomaSymbol,
                          yValueMapper: (DipData data, _) =>
                              data.numberOfDiplomes,
                          dataLabelSettings: DataLabelSettings(
                            showZeroValue: true,
                            isVisible: true,
                          ),
                          enableTooltip: false,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(width: 3, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SfCircularChart(
                      tooltipBehavior: _tooltipBehavior,
                      title: ChartTitle(text: "Diplomes Non Traite"),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      series: <CircularSeries>[
                        PieSeries<DipData, String>(
                          dataSource: _chartDataNonSuccess,
                          xValueMapper: (DipData data, _) =>
                              data.diplomaSymbol,
                          yValueMapper: (DipData data, _) =>
                              data.numberOfDiplomes,
                          dataLabelSettings: DataLabelSettings(
                            showZeroValue: false,
                            isVisible: true,
                          ),
                          enableTooltip: false,
                        )
                      ],
                    ),
                  ),
                ],
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  pauseAutoPlayOnTouch: true,
                  height: 250,
                  initialPage: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Statistics plus detaile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Text(
                  "Pour affiche la liste des etudiant concerne veillez appouer sur la statistic",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_edition",
                                tf: true, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipEdite",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nEdite",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_edition",
                                tf: false, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.edit_off,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipNonEdite",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nNon Edite",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_verification",
                                tf: true, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.thumb_up_alt_rounded,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipAccepte",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nAccepte",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_verification",
                                tf: false, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.thumb_down_rounded,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipNonAccepte",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nNon Accepte",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_presid_signa",
                                tf: true, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.assignment_turned_in,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipSigne",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nSigne",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P",
                                column: "dp_presid_signa",
                                tf: false, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.assignment_late,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipNonSigne",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nNon Signe",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P", column: "dp_remis", tf: true, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipRemis",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nRemis",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckStudentsByStats(
                                saRole: "P", column: "dp_remis", tf: false, saNom: widget.saNom, saEmail: widget.saEmail,);
                          }));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(width: 3, color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xffeeebff),
                                    radius: 23,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: primaryColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "$dipNonRemis",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Diplomes\nNon Remis",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
