// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late List statistics = [
    {'category': 'Fashion', 'count': 0, 'color': Colors.red},
    {'category': 'Food', 'count': 0, 'color': Colors.blue},
    {'category': 'Technology', 'count': 0, 'color': Colors.green},
    {'category': 'Education', 'count': 0, 'color': Colors.yellow},
    {'category': 'Sports', 'count': 0, 'color': Colors.purple},
    {'category': 'Automobile', 'count': 0, 'color': Colors.orange},
  ];
  // List<double> categoryCount = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('interests')
          .where('User Name', isEqualTo: widget.userDocumentID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          int? sum = snapshot.data?.docs.length;
          print(sum);
          for (int i = 0; i < statistics.length; i++) {
            var count = statistics[i]['count'] = snapshot.data?.docs
                .where((element) =>
                    element['Interest'] == statistics[i]['category'] &&
                    element['User Name'] == widget.userDocumentID)
                .length;

            // statistics[i]['count'] = count;
            double presentage = (count! / sum!) * 100;
            presentage = double.parse(presentage.toStringAsFixed(2));
            presentage == double.nan
                ? statistics[i]['count'] = 0
                : statistics[i]['count'] = presentage;
          }
          print(widget.userDocumentID);
          final List<GDPData> chartData = [
            for (int i = 0; i < statistics.length; i++)
              GDPData(
                statistics[i]['category'],
                statistics[i]['count'],
                color: statistics[i]['color'],
              )
          ];
          Map data = {};
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.userDocumentID)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 218, 216, 216),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            120),
                                                  ),
                                                ),
                                                CachedNetworkImage(
                                                  height: 100,
                                                  width: 100,
                                                  imageUrl:
                                                      data['Profile Picture'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          data['Full Name'],
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          ('intersets'),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        const Text(
                                          'This statics shows the percentage of your activity in each category. ',
                                          style: TextStyle(),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    const Text(
                                      "Your Activity",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Center(
                                      child: SfCircularChart(
                                        legend: Legend(
                                            isVisible: true,
                                            overflowMode:
                                                LegendItemOverflowMode.wrap),
                                        series: <CircularSeries>[
                                          DoughnutSeries<GDPData, String>(
                                            dataSource: chartData,
                                            pointColorMapper:
                                                (GDPData data, _) => data.color,
                                            xValueMapper: (GDPData data, _) =>
                                                data.continent,
                                            yValueMapper: (GDPData data, _) =>
                                                data.gdp,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: true),
                                            enableTooltip: true,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }
}

class GDPData {
  GDPData(this.continent, this.gdp, {this.color});
  String continent;
  double gdp;
  Color? color;
}
