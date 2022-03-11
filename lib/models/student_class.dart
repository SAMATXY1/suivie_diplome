import 'package:flutter/material.dart';

class Etudiant {
  Etudiant(
      {required this.et_cne,
      required this.et_firstName,
      required this.et_firstNameAr,
      required this.et_lastName,
      required this.et_lastNameAr,
      required this.et_cin,
      required this.et_date_naissance,
      required this.et_date_inscription,
      required this.et_promotion,
      required this.et_type_diplome,
      required this.et_filiere,
      required this.et_filiereAr,
      required this.et_etablissement,
      required this.et_etablissementAr});
  String et_cne,
      et_firstName,
      et_firstNameAr,
      et_lastName,
      et_lastNameAr,
      et_cin,
      et_type_diplome,
      et_filiere,
      et_filiereAr,
      et_etablissement,
      et_etablissementAr;
  var et_date_naissance, et_date_inscription, et_promotion;
}
