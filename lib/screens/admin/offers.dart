// ignore_for_file: avoid_print, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/admin/updateoffer.dart';

class Offers extends StatefulWidget {
  const Offers({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Offers").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Column(
                children: const [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'No offers available please add some',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document =
                    snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                return Container(
                  height: 75,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 75,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(240, 94, 94, 94),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  document['OfferName'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: -10,
                          child: RawMaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateOffer(
                                    productDocument: document.id,
                                  ),
                                ),
                              );
                            },
                            fillColor: Colors.red,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return const Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()));
      },
    );
  }
}
