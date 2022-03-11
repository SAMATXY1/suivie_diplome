import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/dipDbModel.dart';
import 'package:suivie_diplome/models/student_class.dart';
import 'package:suivie_diplome/pages/admin/add_accounts_admin.dart';
import 'package:suivie_diplome/pages/student/student_info.dart';
import 'package:suivie_diplome/pages/student/student_login_page.dart';

import '../../login_page_admin.dart';
import '../../theme.dart';

class AfficheEtatPage extends StatefulWidget {
  AfficheEtatPage({required this.eEtudiant});
  final Etudiant eEtudiant;
  @override
  State<AfficheEtatPage> createState() => _AfficheEtatPageState();
}

class _AfficheEtatPageState extends State<AfficheEtatPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    e1 = widget.eEtudiant;
    getDipData(e1.et_cne);
    super.initState();
  }

  Future<void> getDipData(String cne) async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection.query(
        "select dp_edition, dp_etab_signa, dp_verification, dp_presid_signa, dp_remis from diplome WHERE et_cne = '$cne'");
    setState(() {
      if (result[0][3] == true) {
        isActive3 = true;
        _currentStep = 2;
      } else if (result[0][2] == true && !result[0][3]) {
        isActive2 = true;
        _currentStep = 1;
      } else {
        isActive1 = true;
        _currentStep = 0;
      }
    });

    print(result);

    await connection.close();
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

  int _currentStep = 0;

  bool isActive1 = false;
  bool isActive2 = false;
  bool isActive3 = false;

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return StudentInfo(etudiantF: e1);
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
                        child: Image.asset('images/student1.png',width: 70,),
                        radius: 50,
                        backgroundColor: Colors.white,
                      ),
                      backgroundColor: primaryColor,
                      radius: 52,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${e1.et_firstName} ${e1.et_lastName}',
                      style: GoogleFonts.balooBhaijaan(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
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
                          return LogInPageStudent();
                        }), (route) => false);
                  },
                  child: Text(
                    'Se déconnecter',
                    style: GoogleFonts.balooBhaijaan(color: primaryColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/status.png'))
            ),
            child: Stepper(
                type: StepperType.horizontal,
                steps: [
                  Step(
                    isActive: isActive1,
                    title: Text("Etape 1"),
                    content: Center(
                      child: Column(
                        children: [
                          Text(
                            "Votre diplôme est en cours d'édition",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Votre diplôme doit être édité et vérificateur afin que vous puissiez le récupérer.",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Step(
                    isActive: isActive2,
                    title: Text("Etape 2"),
                    content: Center(
                      child: Column(
                        children: [
                          Text(
                            "Votre diplôme est en cours de vérification",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Vous pouvez récupérer votre diplôme afin que la vérification soit terminée",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  Step(
                      isActive: isActive3,
                      title: Text("Etape 3"),
                      content: Container(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Votre diplôme est prêt pour vous",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Vous pouvez maintenant récupérer votre diplôme dans votre établissement !",
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      )),
                ],
                currentStep: _currentStep,
                controlsBuilder: (BuildContext context,
                    {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                  return SizedBox();
                }),
          ),
        ),
      ),
    );
  }
}
