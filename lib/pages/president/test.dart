import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:suivie_diplome/logic/postgres_brain.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final data = [
  DipData('Edite', 190),
  DipData('Accepte', 230),
  DipData('Signe', 150),
  DipData('Errone', 31),
  DipData('Remis', 73),
];

_getSeriesData() {
  List<charts.Series<DipData, String>> series = [
    charts.Series(
        id: "Grades",
        data: data,
        labelAccessorFn: (DipData row, _) =>
            '${row.diplomaSymbol}: ${row.numberOfDiplomes}',
        domainFn: (DipData grades, _) => grades.diplomaSymbol,
        measureFn: (DipData grades, _) => grades.numberOfDiplomes)
  ];
  return series;
}

class Test123 extends StatefulWidget {
  @override
  State<Test123> createState() => _Test123State();
}

class _Test123State extends State<Test123> {
  late List<DipData> _chartData;
  late List<DipData> _chartDataNonSuccess;
  late TooltipBehavior _tooltipBehavior;

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Oceania', 1600),
      GDPData('Africa', 2490),
      GDPData('S America', 2900),
      GDPData('Europe', 23050),
      GDPData('N America', 24880),
      GDPData('Asia', 34390),
    ];
    return chartData;
  }

  List<DipData> getDipNonChartData (){
    List<DipData> chartDataNonSucces = [];

    Future<void> getEtudData() async {
      var connection = PostgresConnection.getDBconnection();
      try {
        await connection.open();
      } catch (e) {
        print(e);
      }


      var result = await connection.query(
          "select count( dp_edition ) from diplome where dp_edition = false");

      var dipNonEdite = result[0][0];

      chartDataNonSucces.add(DipData("Non Edite", dipNonEdite));

      result = await connection.query(
          "select count( dp_verification ) from diplome where dp_verification = false");

      var dipNonAccepte = result[0][0];

      chartDataNonSucces.add(DipData("Non Accepte", dipNonAccepte));


      result = await connection.query(
          "select count( dp_presid_signa ) from diplome where dp_presid_signa = false");

      var dipNonSigne = result[0][0];

      chartDataNonSucces.add(DipData("Non Signe", dipNonSigne));


      result = await connection.query(
          "select count( dp_remis ) from diplome where dp_remis = false");

      var dipNonRemis = result[0][0];

      chartDataNonSucces.add(DipData("Remis", dipNonRemis));



      print(result);

      await connection.close();
    }

    getEtudData();

    return chartDataNonSucces;
  }


  List<DipData> getDipChartData() {
    List<DipData> chartData = [];

    Future<void> getEtudData() async {
      var connection = PostgresConnection.getDBconnection();
      try {
        await connection.open();
      } catch (e) {
        print(e);
      }

      var result = await connection.query(
          "select count( dp_edition ) from diplome where dp_edition = true");

      var dipEdite = result[0][0];

      chartData.add(DipData("Edite", dipEdite));


      result = await connection.query(
          "select count( dp_verification ) from diplome where dp_verification = true");

      var dipAccepte = result[0][0];

      chartData.add(DipData("Accepte", dipAccepte));


      result = await connection.query(
          "select count( dp_presid_signa ) from diplome where dp_presid_signa = true");

      var dipSigne = result[0][0];

      chartData.add(DipData("Signe", dipSigne));


      result = await connection.query(
          "select count( dp_remis ) from diplome where dp_remis = true");

      var dipRemis = result[0][0];

      chartData.add(DipData("Remis", dipRemis));

      print(result);

      await connection.close();
    }

    getEtudData();


    return chartData;
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = getDipChartData();
    _chartDataNonSuccess = getDipNonChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCircularChart(
          tooltipBehavior: _tooltipBehavior,
          title: ChartTitle(text: "Hada title"),
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            PieSeries<DipData, String>(
              dataSource: _chartData,
              xValueMapper: (DipData data, _) => data.diplomaSymbol,
              yValueMapper: (DipData data, _) => data.numberOfDiplomes,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
              ),
              enableTooltip: true,
            )
          ],
        ),
      ),
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final int gdp;
  final String continent;
}

class DipData {
  final String diplomaSymbol;
  final int numberOfDiplomes;

  DipData(this.diplomaSymbol, this.numberOfDiplomes);
}

// series : RadialBarSeries (t9dar dir l max value li ratkoun hia number of students bax it9ad) - DoughnutSeries

// SafeArea(
// child: Scaffold(
// body: SfCircularChart(
// tooltipBehavior: _tooltipBehavior,
// title: ChartTitle(text: "Hada title"),
// legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
// series: <CircularSeries>[PieSeries<GDPData, String>(
// dataSource: _chartData,
// xValueMapper: (GDPData data,_) => data.continent,
// yValueMapper: (GDPData data,_) => data.gdp,
// dataLabelSettings: DataLabelSettings(isVisible: true,),
// enableTooltip: true,
// )],),
// ),
// )
