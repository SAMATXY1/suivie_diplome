import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/student_class.dart';
import 'package:suivie_diplome/pages/student/student_home_page.dart';
import '../../theme.dart';

class StudentInfo extends StatefulWidget {
  StudentInfo({required this.etudiantF});
  final Etudiant etudiantF;
  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> getEtudData(String cne) async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection
        .query("select * from etudiant where et_cne = '$cne'");
    setState(() {
      e1.et_cne = result [0][0];
      e1.et_firstName = result [0][1];
      e1.et_lastName = result [0][2];
      e1.et_firstNameAr = result [0][3];
      e1.et_lastNameAr = result [0][4];
      e1.et_cin = result [0][5];
      e1.et_date_naissance = result [0][6];
      e1.et_date_inscription = result [0][7];
      e1.et_type_diplome = result [0][8];
      e1.et_filiere = result [0][9];
      e1.et_filiereAr = result [0][10];
      e1.et_promotion = result [0][11];
      e1.et_etablissement = result [0][12];
      e1.et_etablissementAr = result [0][13];
    });



    print(result);

    await connection.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      e1 = widget.etudiantF;
    });
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
        centerTitle: true,
        title: Text("${e1.et_firstName} ${e1.et_lastName}", style: GoogleFonts.supermercadoOne(color: Colors.black, fontWeight: FontWeight.bold),),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  controller: TextEditingController()..text = e1.et_cne,
                  decoration: InputDecoration(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          child: Image.asset('images/student1.png'),
                        ),
                        SizedBox(
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
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_firstName,
                              onChanged: (e) {},
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_firstNameAr,
                              onChanged: (e) {},
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_lastName,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_lastNameAr,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_cin,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_date_naissance.toString().split(" ")[0],
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          child: Image.asset('images/diploma.png'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Text(
                            "Informations sur le diplome",
                            style: GoogleFonts.balooBhaijaan(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_date_inscription.toString().split(" ")[0],
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_type_diplome,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_filiere,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_filiereAr,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_etablissement,
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_etablissementAr,
                              onChanged: (e) {},
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  labelText: 'مؤسسة'),
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
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              enabled: false,
                              readOnly: true,
                              controller: TextEditingController()
                                ..text = e1.et_promotion.toString(),
                              onChanged: (e) {},
                              decoration: InputDecoration(
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
            ],
          ),
        ),
      ),
    );
  }
}
