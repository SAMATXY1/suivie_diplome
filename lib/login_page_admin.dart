import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:postgres/postgres.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/staff_admin_class.dart';
import 'package:suivie_diplome/pages/admin/admin_home_page.dart';
import 'package:suivie_diplome/pages/etablissement/etab_cpanel.dart';
import 'package:suivie_diplome/pages/president/president_home_final.dart';
import 'package:suivie_diplome/pages/student/student_login_page.dart';
import 'package:suivie_diplome/theme.dart';

import 'models/roles_class.dart';

class LogInPageAdmin extends StatefulWidget {
  const LogInPageAdmin({Key? key}) : super(key: key);

  @override
  _LogInPageAdminState createState() => _LogInPageAdminState();
}

class _LogInPageAdminState extends State<LogInPageAdmin> {
  static late StaffAdmin saCon;
  var userEmail = '';
  var userPassPhrase = '';

  Future<void> logInP(context) async {
    EasyLoading.show(status: 'Signing in...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection.query(
        "SELECT * FROM staff_admin WHERE staff_admin.sa_email = '$userEmail' AND staff_admin.sa_password = crypt('$userPassPhrase', staff_admin.sa_password)");
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
      saCon = StaffAdmin(
          sa_id: result[0][0],
          sa_role: Role.rolesMap[result[0][5]],
          sa_firstName: result[0][3],
          sa_lastName: result[0][4],
          sa_email: result[0][1]);

      print(saCon.sa_nom);

      await connection.query(
          "UPDATE staff_admin SET sa_last_login = @lDate WHERE sa_email = @uEmail",
          substitutionValues: {"lDate": DateTime.now(), "uEmail": userEmail});

      await connection.close();
      if (saCon.sa_role.role_id == 'A') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return AdminHomePage(
            saEmail: saCon.sa_email,
            saNom: "${saCon.sa_firstName} ${saCon.sa_lastName}",
          );
        }));
      } else if (saCon.sa_role.role_id == 'E') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return EtabDashboard(
            saRole: 'E',
            saNom: "${saCon.sa_firstName} ${saCon.sa_lastName}",
            saEmail: saCon.sa_email,
          );
        }));
      } else if (saCon.sa_role.role_id == 'S') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return EtabDashboard(
            saRole: 'S',
            saNom: "${saCon.sa_firstName} ${saCon.sa_lastName}",
            saEmail: saCon.sa_email,
          );
        }));
      } else if (saCon.sa_role.role_id == 'P') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return PresidentFinalHomePage(
            saNom: "${saCon.sa_firstName} ${saCon.sa_lastName}",
            saEmail: saCon.sa_email,
          );
        }));
      }

      EasyLoading.showSuccess("Vous êtes connecté !");
      EasyLoading.dismiss();
    }
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Image.asset('images/undraw_Access_account_re_8spm.png'),
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
                        userEmail = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Adresse E-mail'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (e) {
                        userPassPhrase = e;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Mot de passe'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (userEmail.isEmpty || userPassPhrase.isEmpty) {
                          Flushbar(
                            title: 'Les informations d\'identification invalides',
                            message: 'Veuillez saisir un e-mail et un mot de passe valides',
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
                          print(userEmail);
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
                        'Se Connecter',
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
                          return LogInPageStudent();
                        }));
                      },
                      color: Colors.white,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Etudiant',
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
