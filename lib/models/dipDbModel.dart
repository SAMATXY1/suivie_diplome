class DiplomeModel {
  DiplomeModel(
      {required this.et_cne,
      required this.dp_edition,
      required this.dp_date_verification,
      required this.dp_verification,
      required this.dp_etab_signa,
      required this.dp_presid_signa,
      required this.dp_remis_cause,
      required this.dp_date_remis,
      required this.dp_remis,
      required this.dp_edition_cause,
      required this.dp_date_edition,
      required this.dp_verification_cause});
  String et_cne,
      dp_edition_cause,
      dp_date_edition,
      dp_verification_cause,
      dp_date_verification,
      dp_remis_cause,
      dp_date_remis;

  bool dp_edition, dp_etab_signa, dp_verification, dp_presid_signa, dp_remis;
}
