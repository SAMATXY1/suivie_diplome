import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/diplome_class.dart';
import 'package:suivie_diplome/models/etudDbModel.dart';
import 'package:suivie_diplome/models/staff_admin_class.dart';
import 'package:suivie_diplome/models/student_class.dart';
import 'package:suivie_diplome/pages/admin/admin_home_page.dart';
import 'package:suivie_diplome/pages/etablissement/edit_diplome_page.dart';
import 'package:suivie_diplome/pages/etablissement/edit_etud_page.dart';
import 'package:suivie_diplome/pages/service_diplome/edit_diplome_sp.dart';

import '../../theme.dart';


late String saRole, saNomF, saEmail;
List<EtudModel> etudList = [];
class CheckStudentsByStats extends StatefulWidget {
  CheckStudentsByStats(
      {required this.saRole, required this.column, required this.tf, required this.saNom, required this.saEmail});
  bool tf;
  String column;
  final String saRole, saNom, saEmail;
  @override
  _CheckStudentsByStatsState createState() => _CheckStudentsByStatsState();
}

class _CheckStudentsByStatsState extends State<CheckStudentsByStats> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<void> getEtudData() async {
    EasyLoading.show(status: 'Chargement en cours...');
    var connection = PostgresConnection.getDBconnection();
    try {
      await connection.open();
    } catch (e) {
      print(e);
    }

    var result = await connection.query(
        "select etudiant.et_cne, etudiant.et_firstname, etudiant.et_lastname from etudiant inner join diplome on etudiant.et_cne = diplome.et_cne where etudiant.et_cne in (select et_cne FROM diplome where ${widget.column} = ${widget.tf})");

    print(result);

    for (var row in result) {
      setState(() {
        etudList.add(EtudModel(
            et_cne: row[0], et_firstName: row[1], et_lastName: row[2]));
      });
    }
    await connection.close();
    EasyLoading.dismiss();
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
                              if (widget.saRole == 'S' || widget.saRole == 'P') {
                                return EditDiplomeService(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: widget.saRole,
                                );
                              } else {
                                return EditDiplomePage(
                                  dipCne: cne,
                                  nomComplet: etName,
                                  saRole: widget.saRole, saNom: widget.saNom, saEmail: widget.saEmail,
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
    getEtudData();
    saNomF = widget.saNom;
    saRole = widget.saRole;
    saEmail = widget.saEmail;
    super.initState();
  }

  @override
  void dispose(){
    etudList = [];
    super.dispose();
  }



  int _currentSortColumn = 0;
  bool _isAscending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xffF7F8FA),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FontAwesomeIcons.arrowAltCircleLeft,
              color: Colors.black,
            ),
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
                ))
          ],
        ),
        drawer: Drawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                              etudList.sort((etudA, etudB) =>
                                  etudA.et_lastName.compareTo(etudB.et_lastName));
                            } else {
                              _isAscending = true;
// sort the product list in Descending, order by Price
                              etudList.sort((etudB, etudA) =>
                                  etudA.et_lastName.compareTo(etudB.et_lastName));
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
                                  openDialog("${e.et_firstName} ${e.et_lastName}",
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
  @override
  String get searchFieldLabel => '"Nom Prénom" ou "C.N.E"';
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
                                  saRole: saRole, saNom: saNomF, saEmail: saEmail,
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
                        context, "P");
                  },
                ),
                DataCell(
                  Text(
                    e.et_firstName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                        context, "P");
                  },
                ),
                DataCell(
                  Text(
                    e.et_lastName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                        context, "P");
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
    for (var student in searchTerms) {
      if (student.et_cne.toLowerCase().contains(query.toLowerCase()) ||
          ("${student.et_firstName.toLowerCase()} ${student.et_lastName.toLowerCase()}"
              .contains(query.toLowerCase()) ||
              "${student.et_lastName.toLowerCase()} ${student.et_firstName.toLowerCase()}"
                  .contains(query.toLowerCase()))) {
        if (matchQuery.length <= 100){
          matchQuery.add(student);
        }
      }
    }
    return SingleChildScrollView(
      child: DataTable(
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
                    context, "P");
              },
            ),
            DataCell(
              Text(
                e.et_firstName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                    context, "P");
              },
            ),
            DataCell(
              Text(
                e.et_lastName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                openDialog("${e.et_firstName} ${e.et_lastName}", e.et_cne,
                    context, "P");
              },
            ),
          ]),
        )
            .toList(),
      ),
    );
    // throw UnimplementedError();
  }
}
