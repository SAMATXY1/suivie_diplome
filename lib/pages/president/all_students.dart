import 'package:flutter/material.dart';
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

class ShowAllStudents extends StatefulWidget {
  ShowAllStudents(
      {required this.saRole, required this.saNom, required this.saEmail});
  final String saRole, saNom, saEmail;
  @override
  _ShowAllStudentsState createState() => _ShowAllStudentsState();
}

class _ShowAllStudentsState extends State<ShowAllStudents> {
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

    print(result);

    for (var row in result) {
      setState(() {
        etudList.add(EtudModel(
            et_cne: row[0], et_firstName: row[1], et_lastName: row[2]));
      });
    }
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
                                  saNom: widget.saNom,
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
    getEtudData();
    super.initState();
  }

  @override
  void dispose(){
    etudList = [];
    super.dispose();
  }

  List<EtudModel> etudList = [];

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
            icon: const Icon(
              FontAwesomeIcons.gripHorizontal,
              color: Colors.black,
            ),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
            ),
          ],
        ),
        drawer: Drawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
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
        )));
  }
}
