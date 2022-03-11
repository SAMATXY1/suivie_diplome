import 'package:flutter/material.dart';

class Diplome {
  Diplome(
      {required this.et_cne,
      required this.dp_edition,
      required this.dp_edition_cause,
      required this.dp_etab_signa,
      required this.dp_verification,
      required this.dp_verifivation_cause,
      required this.dp_presid_signa,
      required this.dp_date_verification,
      required this.dp_date_remis,
      required this.dp_remis,
      required this.dp_remis_cause,
      required this.dp_libelle,
      required this.dp_lieu_edition,
      required this.dp_date_edition});

  String et_cne,
      dp_edition_cause,
      dp_verifivation_cause,
      dp_remis_cause,
      dp_libelle,
      dp_lieu_edition;

  bool dp_edition, dp_etab_signa, dp_verification, dp_presid_signa, dp_remis;
  var dp_date_remis, dp_date_edition, dp_date_verification;
}
