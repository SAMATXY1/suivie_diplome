import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/pages/admin/admin_home_page.dart';

import '../../theme.dart';

class EditSaInfo extends StatefulWidget {
  const EditSaInfo({Key? key, required this.saNom, required this.sarenom, required this.saRole, required this.email, required this.saID}) : super(key: key);
  final String saRole,
      saNom,
      sarenom,
      email;
  final int saID;

  @override
  _EditSaInfoState createState() => _EditSaInfoState();
}

class _EditSaInfoState extends State<EditSaInfo> {
  Future<void> updateStaffData(int sid) async {
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
      ).show(context);    }
    try{
      await connection.query(
          "UPDATE staff_admin SET sa_firstname = '$saNom', sa_lastname = '$sarenom', sa_email = '$email', role_id = '$saRole' WHERE sa_id = $sid");
      await connection.close();
      EasyLoading.showSuccess("L'enregistrement est complete!");
      EasyLoading.dismiss();
    }catch(e){
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 40),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
      EasyLoading.dismiss();
    }

  }

  Future<void> removeStaff(int sid) async {
    EasyLoading.show(status: 'Suppression en cours...');
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
      ).show(context);    }
    try{
      await connection.query("DELETE FROM staff_admin WHERE sa_id = $sid");
      await connection.close();
      EasyLoading.showSuccess("Supprimé avec succès!");
      EasyLoading.dismiss();
    }catch(e){
      Flushbar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 40),
        icon: const Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
      EasyLoading.dismiss();
    }
  }
  @override
  void initState(){
    saID = widget.saID;
    saRole = widget.saRole;
    sarenom = widget.sarenom;
    saNom = widget.saNom;
    email = widget.email;
    super.initState();
  }
  late String saRole,
      saNom,
      sarenom,
      email;
  late int saID;
  List<String> rolesList = ['A', 'E', 'P', 'S'];

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: primaryColor,
                  child: CircleAvatar(
                    child: saRole == "P"
                        ? Image.asset(
                            'images/mayor.png',
                            width: 70,
                          )
                        : (saRole == "S"
                            ? Image.asset(
                                'images/sp.png',
                                width: 70,
                              )
                            : (saRole == "A"
                                ? Image.asset(
                                    'images/admin.png',
                                    width: 70,
                                  )
                                : Image.asset(
                                    'images/est.png',
                                    width: 70,
                                  ))),
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '$saNom $sarenom',
                  style: GoogleFonts.balooBhaijaan(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: TextEditingController()..text = saNom,
                  onChanged: (e) {
                    saNom = e;
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
                  controller: TextEditingController()..text = sarenom,
                  onChanged: (e) {
                    sarenom = e;
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
                  controller: TextEditingController()..text = email,
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
                  selectedButton: rolesList.indexOf(saRole),
                  elevation: 1,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  selectedColor: primaryColor,
                  groupingType: GroupingType.wrap,
                  direction: Axis.horizontal,
                  isRadio: true,
                  spacing: 10,
                  onSelected: (index, isSelected) {
                    setState(() {
                      saRole = rolesList[index];
                    });
                  },
                  buttons: const [
                    "Admin",
                    "Etablissement",
                    "Mr. President",
                    "Service diplome presidence"
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (saNom.isNotEmpty || sarenom.isNotEmpty || saRole.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: const Text('Confirmation'),
                            content: const Text(
                                'Enregistrer les modifications ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    updateStaffData(saID);
                                  });
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                    return AdminHomePage(saEmail: widget.email, saNom: '${widget.saNom} ${widget.sarenom}');
                                  }));
                                },
                                child: const Text('Confirmer'),
                              ),
                            ],
                          ));
                    } else {
                      Flushbar(
                        title: 'Les informations sont invalides',
                        message: 'Merci de ne laisser aucun champ vide',
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
                    'Enregistrer les informations',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: const Text('Attention'),
                              content: Text(
                                  'Voulez vous vraiment supprimer le compte $saNom $sarenom ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      removeStaff(saID);
                                    });
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                      return AdminHomePage(saEmail: widget.email, saNom: widget.saNom);
                                    }), (route) => false);

                                  },
                                  child: const Text('Confirmer'),
                                ),
                              ],
                            ));
                  },
                  color: Colors.white,
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'Supprimer l\'utilisateur ',
                    style: TextStyle(color: primaryColor),
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
