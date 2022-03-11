import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:suivie_diplome/models/roles_class.dart';
import 'package:suivie_diplome/models/staff_admin_class.dart';
import 'package:suivie_diplome/pages/admin/edit.dart';
import 'package:suivie_diplome/theme.dart';

class AdminControlPanel extends StatefulWidget {
  const AdminControlPanel({Key? key}) : super(key: key);

  @override
  _AdminControlPanelState createState() => _AdminControlPanelState();
}

class _AdminControlPanelState extends State<AdminControlPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<StaffAdmin> staffList = [];

  Future<void> getStaffData() async {
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
        "SELECT sa_id, role_id, sa_firstname, sa_lastname, sa_email FROM staff_admin");

    for (var row in result) {
      setState(() {
        staffList.add(StaffAdmin(
            sa_id: row[0],
            sa_role: Role.rolesMap[row[1]],
            sa_firstName: row[2],
            sa_lastName: row[3],
            sa_email: row[4]));
      });
    }
    await connection.close();
    staffList.sort((staffA, staffB) =>
        staffA.sa_nom.compareTo(staffB.sa_nom));
  }

  String newData = '';
  String? newRoleDataG = 'Admin';
  String newRoleDataFinal = 'A';

  List dataColumnList = ['Id', 'Nom', 'E-mail'];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  @override
  void initState() {
    // TODO: implement initState
    getStaffData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    staffList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      drawer: const Drawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            sortAscending: _isAscending,
            sortColumnIndex: _currentSortColumn,
            columns: <DataColumn>[
              DataColumn(
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == false) {
                      _isAscending = true;
                      staffList.sort((staffA, staffB) =>
                          staffA.sa_nom.compareTo(staffB.sa_nom));
                    } else {
                      _isAscending = false;
                      staffList.sort((staffB, staffA) =>
                          staffA.sa_nom.compareTo(staffB.sa_nom));
                    }
                  });
                },
                label: Text(
                  'Nom',
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
                      staffList.sort((staffA, staffB) => staffA
                          .sa_role.role_name
                          .compareTo(staffB.sa_role.role_name));
                    } else {
                      _isAscending = true;
                      staffList.sort((staffB, staffA) => staffA
                          .sa_role.role_name
                          .compareTo(staffB.sa_role.role_name));
                    }
                  });
                },
                label: Text(
                  'Role',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: staffList
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '${e.sa_firstName} ${e.sa_lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditSaInfo(
                              saID: e.sa_id,
                              email: e.sa_email,
                              saNom: e.sa_firstName,
                              saRole: e.sa_role.role_id,
                              sarenom: e.sa_lastName,
                            );
                          }));
                        },
                      ),
                      DataCell(
                        Text(e.sa_role.role_name),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditSaInfo(
                              saID: e.sa_id,
                              email: e.sa_email,
                              saNom: e.sa_firstName,
                              saRole: e.sa_role.role_id,
                              sarenom: e.sa_lastName,
                            );
                          }));
                        },
                      ),
                    ],
                  ),
                )
                .toList()),
      )),
    );
  }
}
