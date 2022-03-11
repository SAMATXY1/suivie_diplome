import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/etudDbModel.dart';
import 'package:suivie_diplome/pages/edit_info_page.dart';
import 'package:suivie_diplome/pages/etablissement/edit_diplome_page.dart';
import 'package:suivie_diplome/pages/etablissement/edit_etud_page.dart';
import 'package:suivie_diplome/pages/etablissement/import_data.dart';
import 'package:suivie_diplome/pages/president/check_student_by_stats.dart';
import 'package:suivie_diplome/pages/service_diplome/edit_diplome_sp.dart';

import '../../login_page_admin.dart';
import '../../theme.dart';

List<EtudModel> etudList = [];
String saRoleF = "";
String saNomF = '';
String saEmail = '';

class EtabDashboard extends StatefulWidget {
  EtabDashboard(
      {required this.saRole, required this.saNom, required this.saEmail});
  final String saRole, saNom, saEmail;
  @override
  _EtabDashboardState createState() => _EtabDashboardState();
}

class _EtabDashboardState extends State<EtabDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getEtudData() async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection
        .query("select et_cne, et_firstname, et_lastname from etudiant");

    for (var row in result) {
      setState(() {
        etudList.add(EtudModel(
            et_cne: row[0], et_firstName: row[1], et_lastName: row[2]));
      });
    }
    await connection.close();
  }

  Future<void> getStatsData() async {
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }
    var dColumn = saRoleF == "E" ? "dp_edition" : "dp_verification";

    var result = await connection
        .query("select count( $dColumn ) from diplome where $dColumn = true;");

    setState(() {
      dipTraite = result[0][0];
    });

    result = await connection
        .query("select count( $dColumn ) from diplome where $dColumn = false;");

    setState(() {
      dipNonTrailte = result[0][0];
    });

    await connection.close();
  }

  Future openDialog(String etName, String cne) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              '$etName :',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            content: SizedBox(
              height: 110,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditStudentPage(
                              cneEtudiant: cne,
                              saRole: widget.saRole,
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
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
                            "Editer les informations de l'etudiant",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (widget.saRole == 'S') {
                                return EditDiplomeService(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: widget.saRole,
                                );
                              } else {
                                return EditDiplomePage(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: widget.saRole,
                                  saNom: saNomF,
                                  saEmail: widget.saEmail,
                                );
                              }
                            },
                          ),
                        );
                      },
                      child: Row(
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
                            child: Text("Editer les informations du diplome",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annuler'),
              ),
            ]),
      );

  @override
  void initState() {
    saNomF = widget.saNom;
    saRoleF = widget.saRole;
    saEmail = widget.saEmail;
    getStatsData();
    getEtudData();
    super.initState();
  }

  @override
  void dispose() {
    etudList = [];
    super.dispose();
  }

  int dipTraite = 0;
  int dipNonTrailte = 0;
  int _currentSortColumn = 0;
  bool _isAscending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditInfoPage(
                      saEmail: "saEmail", saNom: saNomF, saRole: saRoleF);
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
                          child: Image.asset(
                            'images/est.png',
                            width: 70,
                          ),
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
                        saNomF,
                        style: GoogleFonts.balooBhaijaan(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  saRoleF == "E"
                      ? Column(
                          children: [
                            ListTile(
                              title: const Text('Importer les etudiants'),
                              leading: Icon(Icons.upload_rounded),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ImportData();
                                }));
                              },
                            ),
                            Divider(),
                          ],
                        )
                      : SizedBox(),
                  ListTile(
                    title: Text(saRoleF == "E"
                        ? 'Afficher les diplômes édités'
                        : 'Afficher les diplômes vérifié'),
                    leading: Icon(saRoleF == "E"
                        ? Icons.edit
                        : Icons.thumb_up_alt_rounded),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckStudentsByStats(
                          saRole: saRoleF,
                          column:
                              saRoleF == "E" ? "dp_edition" : "dp_verification",
                          tf: true,
                          saNom: widget.saNom,
                          saEmail: widget.saEmail,
                        );
                      }));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text(saRoleF == "E"
                        ? 'Afficher les diplômes Non édités'
                        : 'Afficher les diplômes Non vérifié'),
                    leading: Icon(saRoleF == "E"
                        ? Icons.edit_off
                        : Icons.thumb_down_rounded),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckStudentsByStats(
                          saRole: saRoleF,
                          column:
                              saRoleF == "E" ? "dp_edition" : "dp_verification",
                          tf: false,
                          saNom: widget.saNom,
                          saEmail: widget.saEmail,
                        );
                      }));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: saRoleF == "E"
                    ? MediaQuery.of(context).size.height * 0.4
                    : MediaQuery.of(context).size.height * 0.5,
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
                            return LogInPageAdmin();
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
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.4,
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  dipTraite.toString(),
                                  style: GoogleFonts.redressed(
                                      fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  "Diplomes Traite",
                                  style: GoogleFonts.redressed(
                                      fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.1,
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  dipNonTrailte.toString(),
                                  style: GoogleFonts.redressed(
                                      fontWeight: FontWeight.bold, fontSize: 20, color: primaryColor),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  "Diplomes Non Traite",
                                  style: GoogleFonts.redressed(
                                      fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Voici la liste de toutes les étudiante(s)", style: GoogleFonts.redressed(
                      fontWeight: FontWeight.bold, fontSize: 19, color: Colors.grey),),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    sortAscending: _isAscending,
                    sortColumnIndex: _currentSortColumn,
                    columns: <DataColumn>[
                      DataColumn(
                        onSort: (columnIndex, _) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            if (_isAscending == true) {
                              _isAscending = false;
// sort the product list in Ascending, order by Price
                              etudList.sort((etudA, etudB) =>
                                  etudA.et_cne.compareTo(etudB.et_cne));
                            } else {
                              _isAscending = true;
// sort the product list in Descending, order by Price
                              etudList.sort((etudB, etudA) =>
                                  etudA.et_cne.compareTo(etudB.et_cne));
                            }
                          });
                        },
                        label: Text(
                          'CNE',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        onSort: (columnIndex, _) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            if (_isAscending == true) {
                              _isAscending = false;
// sort the product list in Ascending, order by Price
                              etudList.sort((etudA, etudB) => etudA.et_firstName
                                  .compareTo(etudB.et_firstName));
                            } else {
                              _isAscending = true;
// sort the product list in Descending, order by Price
                              etudList.sort((etudB, etudA) => etudA.et_firstName
                                  .compareTo(etudB.et_firstName));
                            }
                          });
                        },
                        label: Text(
                          'Prenom',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        onSort: (columnIndex, _) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            if (_isAscending == true) {
                              _isAscending = false;
// sort the product list in Ascending, order by Price
                              etudList.sort((etudA, etudB) => etudA.et_lastName
                                  .compareTo(etudB.et_lastName));
                            } else {
                              _isAscending = true;
// sort the product list in Descending, order by Price
                              etudList.sort((etudB, etudA) => etudA.et_lastName
                                  .compareTo(etudB.et_lastName));
                            }
                          });
                        },
                        label: Text(
                          'Nom',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: etudList
                        .map(
                          (e) => DataRow(cells: [
                            DataCell(
                              Text(e.et_cne),
                              onTap: () {
                                setState(() {
                                  openDialog(
                                      "${e.et_firstName} ${e.et_lastName}",
                                      e.et_cne);
                                });
                              },
                            ),
                            DataCell(
                              Text(
                                e.et_firstName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                openDialog("${e.et_firstName} ${e.et_lastName}",
                                    e.et_cne);
                              },
                            ),
                            DataCell(
                              Text(
                                e.et_lastName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                openDialog("${e.et_firstName} ${e.et_lastName}",
                                    e.et_cne);
                              },
                            ),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  Future openDialog(String etName, String cne, BuildContext context, saRole) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              '$etName :',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            content: SizedBox(
              height: 110,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditStudentPage(
                              cneEtudiant: cne,
                              saRole: saRole,
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
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
                            "Editer les informations de l'etudiant",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if (saRole == 'S' || saRole == 'P') {
                                return EditDiplomeService(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: saRole,
                                );
                              } else {
                                return EditDiplomePage(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: saRole,
                                  saNom: saNomF,
                                  saEmail: saEmail,
                                );
                              }
                            },
                          ),
                        );
                      },
                      child: Row(
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
                            child: Text("Editer les informations du diplome",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annuler'),
              ),
            ]),
      );

  List<EtudModel> searchTerms = etudList;
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<EtudModel> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.et_cne.toLowerCase().contains(query.toLowerCase()) ||
          ("${fruit.et_firstName.toLowerCase()} ${fruit.et_lastName.toLowerCase()}"
                  .contains(query.toLowerCase()) ||
              "${fruit.et_lastName.toLowerCase()} ${fruit.et_firstName.toLowerCase()}"
                  .contains(query.toLowerCase()))) {
        matchQuery.add(fruit);
      }
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  'CNE',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Prenom',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Nom',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: matchQuery
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Text(e.et_cne),
                      onTap: () {
                        openDialog("${e.et_firstName} ${e.et_lastName}",
                            e.et_cne, context, saRoleF);
                      },
                    ),
                    DataCell(
                      Text(
                        e.et_firstName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        openDialog("${e.et_firstName} ${e.et_lastName}",
                            e.et_cne, context, saRoleF);
                      },
                    ),
                    DataCell(
                      Text(
                        e.et_lastName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        openDialog("${e.et_firstName} ${e.et_lastName}",
                            e.et_cne, context, saRoleF);
                      },
                    ),
                  ]),
                )
                .toList(),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<EtudModel> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.et_cne.toLowerCase().contains(query.toLowerCase()) ||
          ("${fruit.et_firstName.toLowerCase()} ${fruit.et_lastName.toLowerCase()}"
                  .contains(query.toLowerCase()) ||
              "${fruit.et_lastName.toLowerCase()} ${fruit.et_firstName.toLowerCase()}"
                  .contains(query.toLowerCase()))) {
        matchQuery.add(fruit);
      }
    }
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'CNE',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Prenom',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Nom',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows: matchQuery
          .map(
            (e) => DataRow(cells: [
              DataCell(
                Text(e.et_cne),
                onTap: () {
                  openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                      context, saRoleF);
                },
              ),
              DataCell(
                Text(
                  e.et_firstName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                      context, saRoleF);
                },
              ),
              DataCell(
                Text(
                  e.et_lastName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                      context, saRoleF);
                },
              ),
            ]),
          )
          .toList(),
    );
    throw UnimplementedError();
  }
}
