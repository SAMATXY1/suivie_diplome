import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:postgres/postgres.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/student_class.dart';

import '../../theme.dart';

class ImportData extends StatefulWidget {
  const ImportData({Key? key}) : super(key: key);

  @override
  _ImportDataState createState() => _ImportDataState();
}

List etEro = [];

class _ImportDataState extends State<ImportData> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String filePath = '';
  int nbrTotal = 0, nbrSuccsse = 0, nbrEronne = 0;
  String lastImp = '';
  @override
  void dispose() {
    // TODO: implement dispose
    etEro = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.arrowAltCircleLeft,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(),
      backgroundColor: themeBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_pin_rounded, color: primaryColor,size: 35,),
                            SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                "Nombre total d'étudiants : $nbrTotal",
                                style: GoogleFonts.cabin(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.green,size: 35,),
                            SizedBox(width: 5,),
                            Flexible(
                              child: Text("Étudiants importés : $nbrSuccsse",
                                style: GoogleFonts.cabin(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear, color: Colors.red,size: 35,),
                            SizedBox(width: 5,),
                            Flexible(
                              child: Text("Étudiants non importés : $nbrEronne",
                                style: GoogleFonts.cabin(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Les étudiants Non importé (C.N.E):",
                          style: GoogleFonts.cabin(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,),
                      ),
                      Text("$etEro",style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, fontSize: 15),
                        textAlign: TextAlign.center,),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(15)
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    primaryColor
                  ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: primaryColor),
                        )
                    )
                ),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    if (result.files.single.path!.contains("xlsx") ||
                        result.files.single.path!.contains("xls")) {
                      print(result.files.single.path);
                      var file = result.files.single.path;
                      var bytes = File(file!).readAsBytesSync();
                      var excel = Excel.decodeBytes(bytes);
                      int j = 0;
                      EasyLoading.show(status: 'Importation en cours...');
                      var connection = PostgresConnection.getDBconnection();
                      try {
                        await connection.open();
                      } catch (e) {
                        print(e);
                      }
                      for (var table in excel.tables.keys) {
                        Map<int, List<Data?>> mp = Map();
                        for (var row in excel.tables[table]!.rows) {
                          mp[++j] = row;
                        }
                        for (int i = 2; i < mp.length; i++) {
                          List<String> et = [];
                          for (int j = 0; j < 14; j++) {
                            // print(mp[i]![j]!.value);
                            et.add(mp[i]![j]!.value.toString());
                          }

                          var result = await connection.query(
                              "select et_cne from etudiant where et_cne = '${et[1]}'");

                          if (result.isEmpty) {
                            try {
                              Etudiant e1 = Etudiant(
                                  et_cne: et[1],
                                  et_firstName: et[8].contains("'")
                                      ? "${et[8].split("'")[0]} ${et[8].split("'")[1]}"
                                      : et[8],
                                  et_firstNameAr: et[9].contains("'")
                                      ? "${et[9].split("'")[0]} ${et[9].split("'")[1]}"
                                      : et[9],
                                  et_lastName: et[10].contains("'")
                                      ? "${et[10].split("'")[0]} ${et[10].split("'")[1]}"
                                      : et[10],
                                  et_lastNameAr: et[11].contains("'")
                                      ? "${et[11].split("'")[0]} ${et[11].split("'")[1]}"
                                      : et[11],
                                  et_cin: et[0],
                                  et_date_naissance: et[3],
                                  et_date_inscription: et[2],
                                  et_promotion: et[12],
                                  et_type_diplome: et[13],
                                  et_filiere: et[6].contains("'")
                                      ? "${et[6].split("'")[0]} ${et[6].split("'")[1]}"
                                      : et[6],
                                  et_filiereAr: et[7].contains("'")
                                      ? "${et[7].split("'")[0]} ${et[7].split("'")[1]}"
                                      : et[7],
                                  et_etablissement: et[4].contains("'")
                                      ? "${et[4].split("'")[0]} ${et[4].split("'")[1]}"
                                      : et[4],
                                  et_etablissementAr: et[5].contains("'")
                                      ? "${et[5].split("'")[0]} ${et[5].split("'")[1]}"
                                      : et[5]);

                              await connection.query(
                                  "INSERT INTO etudiant (et_cin, et_cne, et_date_inscription, et_date_naissance, et_etablissement, et_etablissementar, et_filiere, et_filierear, et_firstname, et_firstnamear, et_lastname, et_lastnamear, et_promotion, et_type_diplome) VALUES ('${e1.et_cin}', '${e1.et_cne}', '${e1.et_date_inscription}', '${e1.et_date_naissance}', '${e1.et_etablissement}', '${e1.et_etablissementAr}', '${e1.et_filiere}', '${e1.et_filiereAr}', '${e1.et_firstName}', '${e1.et_firstNameAr}', '${e1.et_lastName}', '${e1.et_lastNameAr}', '${e1.et_promotion}', '${e1.et_type_diplome}')");
                              await connection.query(
                                  "insert into diplome (et_cne, dp_libelle, dp_libellear, dp_lieu_edition, dp_lieu_editionar) VALUES ('${et[1]}', '${et[13]} ${et[6]}', '${et[13]} ${et[7]}', '${et[4]}', '${et[5]}')");
                              setState(() {
                                nbrSuccsse++;
                              });
                            } catch (e) {
                              setState(() {
                                nbrEronne++;
                                etEro.add(et[1]);
                              });
                              Flushbar(
                                title: 'Error',
                                message: e.toString(),
                                duration: Duration(seconds: 60),
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 28.0,
                                  color: Colors.red,
                                ),
                                margin: EdgeInsets.all(8.0),
                                borderRadius: BorderRadius.circular(8),
                                flushbarStyle: FlushbarStyle.FLOATING,
                              ).show(context);
                            }
                          }

                          print(et);
                          setState(() {
                            lastImp = et.toString();
                          });

                          et = [];
                        }
                        setState(() {
                          nbrTotal = nbrSuccsse + nbrEronne;
                        });
                        await connection.close();
                        EasyLoading.showSuccess("L'importation est complete!");
                        EasyLoading.dismiss();
                      }
                    } else {
                      Flushbar(
                        title: 'Error',
                        message: "Veuillez sélectionner un document excel",
                        duration: Duration(seconds: 3),
                        icon: Icon(
                          Icons.info_outline,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        margin: EdgeInsets.all(8.0),
                        borderRadius: BorderRadius.circular(8),
                        flushbarStyle: FlushbarStyle.FLOATING,
                      ).show(context);
                    }

                    //
                    //   // print(table); //sheet Name
                    //   // print(excel.tables[table]!.maxCols);
                    //   // print(excel.tables[table]!.maxRows);
                    //   // for (var row in excel.tables[table]!.rows) {
                    //   //   print("$row");
                    //   // }
                    // }
                  } else {
                    // User canceled the picker
                  }
                },
                child: Text(
                  "Importer le fichier Excel",
                  style: GoogleFonts.cabin(
                    color: Colors.white,
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
