import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int? documentCount = 0;
  int? documentCount2 = 0;
  List<Map<String, dynamic>> statistics = [];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    final Stream<QuerySnapshot> offerStream =
        FirebaseFirestore.instance.collection('Offers').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        return StreamBuilder<QuerySnapshot>(
          stream: offerStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
            if (snapshot1.hasData) {
              documentCount = snapshot1.data?.docs.length;
              documentCount2 = snapshot2.data?.docs.length;
              statistics = [
                {
                  'title': 'Offers',
                  'value': documentCount2,
                },
                {
                  'title': 'Number of Customers',
                  'value': documentCount,
                },
              ];

              return GridView.builder(
                itemCount: statistics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromARGB(9, 255, 255, 255),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          statistics[index]['value'].toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          statistics[index]['title'],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot1.hasError) {
              return Text("Error: ${snapshot1.error}");
            }
            return const Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()));
          },
        );
      },
    );
  }
}
