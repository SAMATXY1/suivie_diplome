import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:postgres/postgres.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/pages/admin/admin_home_page.dart';
import 'package:suivie_diplome/theme.dart';

class AddAccounts extends StatefulWidget {
  const AddAccounts({required this.saEmail, required this.saNom});
  final String saEmail, saNom;
  @override
  _AddAccountsState createState() => _AddAccountsState();
}

class _AddAccountsState extends State<AddAccounts> {
  Future<void> signUpUser() async {
    var connection = PostgresConnection.getDBconnection();

    Future<void> setData(PostgreSQLConnection connection, String table,
        Map<String, dynamic> data) async {
      await connection.execute(
          "INSERT INTO $table (${data.keys.join(", ")}) VALUES ('${data["role_id"]}','${data["sa_firstname"]}','${data["sa_lastname"]}',crypt('${data["sa_password"]}', gen_salt('bf')),'${data["sa_email"]}')");
    }

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

    var result = await connection.query(
        "SELECT * FROM staff_admin WHERE staff_admin.sa_email = @uEmail",
        substitutionValues: {"uEmail": email});

    if (result.isEmpty) {
      final data = <String, dynamic>{
        "role_id": userRole,
        "sa_firstname": firstName,
        "sa_lastname": lastName,
        "sa_password": passWord,
        "sa_email": email
      };

      EasyLoading.show(status: 'Ajout en cours...');

      await setData(connection, "staff_admin", data);

      await connection.close();
      EasyLoading.showSuccess("Ajoutè avec succès!");
      EasyLoading.dismiss();

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return AdminHomePage(saEmail: widget.saEmail, saNom: widget.saNom);
      }), (route) => false);
    } else {
      await connection.close();

      Flushbar(
        title: 'Error',
        message: "Adresse E-mail deja utilisé!",
        duration: const Duration(seconds: 3),
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
  }

  late var firstName = '', lastName = '', email = '', passWord = '', confPassword = '';
  List<String> rolesList = ['A', 'E', 'P', 'S'];
  var userRole = 'A';
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ajouter un Utilisateur',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const Text(
                      "Merci de ne pas utiliser des caractères spéciaux (e.g: ' , \" , ;)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        firstName = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Nom'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        lastName = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Prenom'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (e) {
                        email = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'E-mail'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (e) {
                        passWord = e;
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
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Mots de passe'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (e) {
                        confPassword = e;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'Confirmer le Mot de passe'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Rôle: ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GroupButton(
                      unselectedShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 25.0,
                          spreadRadius: 1.0,
                          offset: Offset(
                            0.0,
                            2.0,
                          ),
                        )
                      ],
                      selectedButton: 0,
                      elevation: 1,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      selectedColor: primaryColor,
                      groupingType: GroupingType.wrap,
                      direction: Axis.horizontal,
                      isRadio: true,
                      spacing: 10,
                      onSelected: (index, isSelected) {
                        setState(() {
                          userRole = rolesList[index];
                        });
                      },
                      buttons: const [
                        "Admin",
                        "Établissement",
                        "Mr. Président",
                        "Service des diplôme du présidence"
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (passWord == confPassword && passWord.isNotEmpty) {
                          signUpUser();
                        } else {
                          Flushbar(
                            title: 'Invalid Credentials',
                            message: 'Please enter a valid E-mail and Password',
                            duration: const Duration(seconds: 3),
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
                      },
                      color: primaryColor,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        'Ajouter un utilisateur',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
