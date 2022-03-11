import 'package:flutter/material.dart';
import 'package:suivie_diplome/models/roles_class.dart';

class StaffAdmin {
  StaffAdmin(
      {required this.sa_id,
      required this.sa_role,
      required this.sa_firstName,
      required this.sa_lastName,
      required this.sa_email}) {
    sa_nom = "$sa_firstName $sa_lastName";
  }

  Role sa_role;

  int sa_id;

  String sa_firstName, sa_lastName, sa_email;
  String sa_nom = "";
}
