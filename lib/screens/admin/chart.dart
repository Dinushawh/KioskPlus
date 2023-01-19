// ignore_for_file: avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List statistics = [
    {'category': 'Fashion', 'count': 0, 'color': Colors.red},
    {'category': 'Food', 'count': 0, 'color': Colors.blue},
    {'category': 'Technology', 'count': 0, 'color': Colors.green},
    {'category': 'Education', 'count': 0, 'color': Colors.yellow},
    {'category': 'Sports', 'count': 0, 'color': Colors.purple},
    {'category': 'Automobile', 'count': 0, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('interests').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          int? sum = snapshot.data?.docs.length;
          print(sum);
          for (int i = 0; i < statistics.length; i++) {
            var count = statistics[i]['count'] = snapshot.data?.docs
                .where((element) =>
                    element['Interest'] == statistics[i]['category'])
                .length;

            double presentage = (count! / sum!) * 100;
            presentage = double.parse(presentage.toStringAsFixed(2));
            presentage == double.nan
                ? statistics[i]['count'] = 0
                : statistics[i]['count'] = presentage;
          }

          final List<GDPData> chartData = [
            for (int i = 0; i < statistics.length; i++)
              GDPData(
                statistics[i]['category'],
                statistics[i]['count'],
                color: statistics[i]['color'],
              )
          ];

          print(statistics);
          return SfCircularChart(
              legend: Legend(
                  isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              series: <CircularSeries>[
                DoughnutSeries<GDPData, String>(
                  dataSource: chartData,
                  pointColorMapper: (GDPData data, _) => data.color,
                  xValueMapper: (GDPData data, _) => data.continent,
                  yValueMapper: (GDPData data, _) => data.gdp,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                )
              ]);
        });
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, {this.color});
  String continent;
  double gdp;
  Color? color;
}
