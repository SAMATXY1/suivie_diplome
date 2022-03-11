class Boolian {
  Boolian({required this.boolianName, required this.boolianValue});

  String boolianName;
  bool boolianValue;

  static List<Boolian> boolianList = [
    Boolian(boolianName: "Non", boolianValue: false),
    Boolian(boolianName: "Oui", boolianValue: true)
  ];
}
