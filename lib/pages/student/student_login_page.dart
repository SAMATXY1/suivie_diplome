import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:postgres/postgres.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/login_page_admin.dart';
import 'package:suivie_diplome/models/staff_admin_class.dart';
import 'package:suivie_diplome/models/student_class.dart';
import 'package:suivie_diplome/pages/admin/admin_home_page.dart';
import 'package:suivie_diplome/pages/etablissement/etab_cpanel.dart';
import 'package:suivie_diplome/pages/president/president_home_final.dart';
import 'package:suivie_diplome/pages/student/student_home_page.dart';
import 'package:suivie_diplome/theme.dart';

class LogInPageStudent extends StatefulWidget {
  const LogInPageStudent({Key? key}) : super(key: key);

  @override
  _LogInPageStudentState createState() => _LogInPageStudentState();
}

class _LogInPageStudentState extends State<LogInPageStudent> {
  static late Etudiant etudCon;
  var studCne;
  var studDateNaisance;
  var promotion;

  Future<void> logInP(context) async {
    EasyLoading.show(status: 'Signing in...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection.query(
        "SELECT * FROM etudiant WHERE etudiant.et_cne = '$studCne' AND etudiant.et_date_naissance = '$studDateNaisance' AND et_promotion = '$promotion'");
    print(result);

    if (result.isEmpty) {
      await connection.close();
      EasyLoading.dismiss();
      Flushbar(
        title: 'Error',
        message: "Invalid Username or Password",
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
    } else {
      etudCon = Etudiant(
          et_cne: result[0][0],
          et_firstName: result[0][1],
          et_lastName: result[0][2],
          et_firstNameAr: result[0][3],
          et_lastNameAr: result[0][4],
          et_cin: result[0][5],
          et_date_naissance: result[0][6],
          et_date_inscription: result[0][7],
          et_type_diplome: result[0][8],
          et_filiere: result[0][9],
          et_filiereAr: result[0][10],
          et_promotion: result[0][11],
          et_etablissement: result[0][12],
          et_etablissementAr: result[0][13]);

      print(etudCon.et_cne);

      await connection.query(
          "UPDATE staff_admin SET sa_last_login = @lDate WHERE sa_email = @uEmail",
          substitutionValues: {"lDate": DateTime.now(), "uEmail": studCne});

      await connection.close();

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AfficheEtatPage(
          eEtudiant: etudCon,
        );
      }));

      EasyLoading.showSuccess("You're logged in!");
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Image.asset('images/stlogin.png'),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Se Connecter",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 32),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        studCne = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'C.N.E'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        studDateNaisance = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Date Naissance (ex: 2002-07-23)'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        promotion = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Promotion'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (studCne.isEmpty ||
                            studDateNaisance.isEmpty ||
                            promotion.isEmpty) {
                          Flushbar(
                            title: 'Invalid Credentials',
                            message: 'Please enter a valid informations',
                            duration: Duration(seconds: 3),
                            icon: const Icon(
                              Icons.info_outline,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            margin: EdgeInsets.all(8.0),
                            borderRadius: BorderRadius.circular(8),
                            flushbarStyle: FlushbarStyle.FLOATING,
                          ).show(context);
                        } else {
                          print(studCne);
                          setState(() {
                            logInP(context);
                          });
                        }
                      },
                      color: primaryColor,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Ou, se connecter en tant que...',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LogInPageAdmin();
                        }));
                      },
                      color: Colors.white,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Administrateur',
                        style: TextStyle(color: primaryColor),
                      ),
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
