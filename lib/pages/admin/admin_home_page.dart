import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/login_page_admin.dart';
import 'package:suivie_diplome/pages/admin/add_accounts_admin.dart';
import 'package:suivie_diplome/pages/admin/admin_cpanel.dart';
import 'package:suivie_diplome/pages/edit_info_page.dart';
import 'package:suivie_diplome/theme.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({required this.saEmail, required this.saNom});
  final String saEmail, saNom;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getStats() async {
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

    var result =
        await connection.query("SELECT * FROM staff_admin WHERE role_id = 'A'");
    setState(() {
      aNum = result.length.toString();
    });

    result =
        await connection.query("SELECT * FROM staff_admin WHERE role_id = 'E'");
    setState(() {
      eNum = result.length.toString();
    });

    result =
        await connection.query("SELECT * FROM staff_admin WHERE role_id = 'S'");
    setState(() {
      sNum = result.length.toString();
    });
    await connection.close();
  }

  Future<void> getActivities() async {
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

    var result = await connection.query(
        "SELECT sa_firstname, sa_lastname, sa_last_login FROM staff_admin");
    setState(() {
      for (var row in result) {
        activitiesSa.add(row);
      }
    });

    activitiesSa.sort((act2, act1) =>
        act1[2].compareTo(act2[2]));

    await connection.close();
  }

  String aNum = '0', eNum = '0', sNum = '0';
  List activitiesSa = [];

  @override
  void initState() {
    getActivities();
    getStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F8FA),
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
                return EditInfoPage(saEmail: widget.saEmail, saNom: widget.saNom, saRole: "A");
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      child: CircleAvatar(
                        child: Image.asset('images/admin.png', width: 70,),
                        radius: 50,
                        backgroundColor: Colors.white,
                        // foregroundImage: AssetImage('images/admin.png'),
                      ),
                      backgroundColor: primaryColor,
                      radius: 52,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Mr. Administrateur',
                      style: GoogleFonts.balooBhaijaan(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Ajouter un utilisateur'),
                  leading: const Icon(FontAwesomeIcons.userPlus),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddAccounts(saEmail: widget.saEmail, saNom: widget.saNom, );
                    }));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Gérer les comptes utilisateur'),
                  leading: const Icon(FontAwesomeIcons.tools),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AdminControlPanel();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
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
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return const LogInPageAdmin();
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
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('images/admin.png'),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Text(
                                '$aNum compte(s) Admin',
                                style: GoogleFonts.balooBhaijaan(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('images/est.png'),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Text(
                                '$eNum compte(s) Etablissement',
                                style: GoogleFonts.balooBhaijaan(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('images/sp.png'),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Text(
                                '$sNum compte(s) service deplome presidence',
                                style: GoogleFonts.balooBhaijaan(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Activités',
                            style: GoogleFonts.balooBhaijaan(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: primaryColor),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: activitiesSa.isEmpty
                              ? Column(
                                  children: [
                                    Image.asset('images/pasmsg.png'),
                                    Text(
                                      "Pas d'activite pour l'instant",
                                      style: GoogleFonts.balooBhaijaan(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: DataTable(
                                      sortAscending: true,
                                      sortColumnIndex: 2,
                                      columns: <DataColumn>[
                                        const DataColumn(label: Text("Prenom")),
                                        const DataColumn(label: Text("Nom")),
                                        DataColumn(
                                            onSort: (columnIndex, _) {
                                              setState(() {
                                                activitiesSa.sort((act2, act1) =>
                                                    act1[2].compareTo(act2[2]));
                                              });
                                            },
                                            label: const Flexible(
                                                child:
                                                    Text("Derniere\nconnexion")))
                                      ],
                                      rows: activitiesSa
                                          .map(
                                            (e) => DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(e[0].toString()),
                                                ),
                                                DataCell(
                                                  Text(e[1].toString()),
                                                ),
                                                DataCell(
                                                  Text(e[2].toString().split(".")[0]),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList()),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
