import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/theme.dart';

class EditInfoPage extends StatefulWidget {
  EditInfoPage({required this.saEmail, required this.saNom, required this.saRole});
  final saEmail;
  final saNom;
  final saRole;

  @override
  _EditInfoPageState createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {

  Future<void> saveInfo(context) async {
    EasyLoading.show(status: 'Enregistrement...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection.query(
        "SELECT sa_email, sa_password FROM staff_admin WHERE sa_email = '${widget.saEmail}' AND sa_password = crypt('${oldPass}', staff_admin.sa_password)");

    print(result);

    if (result.isEmpty) {
      await connection.close();
      EasyLoading.dismiss();
      Flushbar(
        title: 'Error',
        message: "Ancien Mot de passe est Incorrecte",
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

      await connection.query(
          "UPDATE staff_admin SET sa_password = crypt('${newPass}', gen_salt('bf')) WHERE sa_email = '${widget.saEmail}'",
      );

      await connection.close();


      EasyLoading.showSuccess("Enregistre!");
      EasyLoading.dismiss();
      Navigator.pop(context);
    }
  }

  var oldPass = '',newPass= '', reNewPass = '';
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
          icon: Icon(
            FontAwesomeIcons.arrowAltCircleLeft,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    child: widget.saRole == "P" ? Image.asset('images/mayor.png', width: 70,) : (widget.saRole == "S" ? Image.asset('images/sp.png', width: 70,) : (widget.saRole == "A" ? Image.asset('images/admin.png', width: 70,) : Image.asset('images/est.png', width: 70,))),
                    radius: 50,
                    backgroundColor: Colors.white,
                    // foregroundImage: widget.saRole == "P" ? AssetImage('images/mayor.png') : (widget.saRole == "S" ? AssetImage('images/sp.png') : (widget.saRole == "A" ? AssetImage('images/admin.png') : AssetImage('images/est.png'))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.saNom,
                  style: GoogleFonts.balooBhaijaan(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (e) {
                    oldPass = e;
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
                      labelText: 'Ancien Mot de passe'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (e) {
                    newPass = e;
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
                      labelText: 'Nouveau Mot de passe'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  onChanged: (e) {
                    reNewPass = e;
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
                      labelText: 'Rentrer le nouveau Mot de passe'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                MaterialButton(
                  onPressed: () {
                    if (oldPass.isEmpty || newPass.isEmpty || reNewPass.isEmpty) {
                      Flushbar(
                        title: 'Invalid Credentials',
                        message: 'Please enter a valid Password',
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
                      saveInfo(context);
                    }
                  },
                  color: Colors.black,
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
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
