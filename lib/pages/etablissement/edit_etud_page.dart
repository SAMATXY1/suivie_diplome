import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/student_class.dart';
import '../../theme.dart';

class EditStudentPage extends StatefulWidget {
  const EditStudentPage({required this.cneEtudiant, required this.saRole});
  final String cneEtudiant;
  final String saRole;

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getEtudData(String cne) async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 20),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
    }

    var result =
        await connection.query("select * from etudiant where et_cne = '$cne'");
    setState(() {
      e1.et_cne = result[0][0];
      e1.et_firstName = result[0][1];
      e1.et_lastName = result[0][2];
      e1.et_firstNameAr = result[0][3];
      e1.et_lastNameAr = result[0][4];
      e1.et_cin = result[0][5];
      e1.et_date_naissance = result[0][6];
      e1.et_date_inscription = result[0][7];
      e1.et_type_diplome = result[0][8];
      e1.et_filiere = result[0][9];
      e1.et_filiereAr = result[0][10];
      e1.et_promotion = result[0][11];
      e1.et_etablissement = result[0][12];
      e1.et_etablissementAr = result[0][13];
    });

    await connection.close();
  }

  Future<void> saveEtudData(String cne) async {
    DateTime now = DateTime.now();
    EasyLoading.show(status: 'Enregistrement en cours...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 20),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
    }

    await connection.query(
        "UPDATE etudiant set et_cin = '${e1.et_cin}', et_cne = '${e1.et_cne}', et_date_inscription = '${e1.et_date_inscription}', et_date_naissance = '${e1.et_date_naissance}', et_etablissement = '${e1.et_etablissement}', et_etablissementar = '${e1.et_etablissementAr}', et_filiere = '${e1.et_filiere}', et_filierear = '${e1.et_filiereAr}', et_firstname = '${e1.et_firstName}', et_firstnamear = '${e1.et_firstNameAr}', et_lastname = '${e1.et_lastName}', et_lastnamear = '${e1.et_lastNameAr}', et_promotion = '${e1.et_promotion}', et_type_diplome = '${e1.et_type_diplome}') WHERE et_cne = '${e1.et_cne}'");

    await connection.close();
    EasyLoading.showSuccess("L'enregistrement est complete!");
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEtudData(widget.cneEtudiant);
  }

  Etudiant e1 = Etudiant(
      et_cne: "",
      et_firstName: "",
      et_firstNameAr: "",
      et_lastName: "",
      et_lastNameAr: "",
      et_cin: "",
      et_date_naissance: "",
      et_date_inscription: "",
      et_promotion: "",
      et_type_diplome: "",
      et_filiere: "",
      et_filiereAr: "",
      et_etablissement: "",
      et_etablissementAr: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            FontAwesomeIcons.arrowAltCircleLeft,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: TextEditingController()..text = e1.et_cne,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'C.N.E'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 3, color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('images/student1.png'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "Informations Personnel de l'etudiant",
                              style: GoogleFonts.balooBhaijaan(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_firstName,
                                onChanged: (e) {
                                  e1.et_firstName = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Prenom'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_firstNameAr,
                                onChanged: (e) {
                                  e1.et_firstNameAr = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'الإسم'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_lastName,
                                onChanged: (e) {
                                  e1.et_lastName = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Nom'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_lastNameAr,
                                onChanged: (e) {
                                  e1.et_lastNameAr = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'النسب'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                enabled: false,
                                readOnly: true,
                                controller: TextEditingController()
                                  ..text = e1.et_cin,
                                onChanged: (e) {
                                  e1.et_cin = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'C.I.N'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_date_naissance.toString(),
                                onChanged: (e) {
                                  e1.et_date_naissance = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Date de naissance'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 3, color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('images/diploma.png'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "Section pour l'etablissement",
                              style: GoogleFonts.balooBhaijaan(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_date_inscription.toString(),
                                onChanged: (e) {
                                  e1.et_date_inscription = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: "Date d'inscription"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_type_diplome,
                                onChanged: (e) {
                                  e1.et_type_diplome = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Type de Diplome'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_filiere,
                                onChanged: (e) {
                                  e1.et_filiere = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Filiere'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_filiereAr,
                                onChanged: (e) {
                                  e1.et_filiereAr = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'مجال'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_etablissement,
                                onChanged: (e) {
                                  e1.et_etablissement = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Etablissement'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_etablissementAr,
                                onChanged: (e) {
                                  e1.et_etablissementAr = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'مؤسسة'),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = e1.et_promotion.toString(),
                                onChanged: (e) {
                                  e1.et_promotion = e;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    labelText: 'Promotion'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.1),
              //     spreadRadius: 5,
              //     blurRadius: 7,
              //     offset: Offset(0, 3), // changes position of shadow
              //   ),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {
                      saveEtudData(e1.et_cne);
                      Navigator.pop(context);
                    },
                    color: primaryColor,
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Annuler',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
