// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Offers").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    child:
                        Lottie.asset('assets/lottie/empty-box-animation.json'),
                  ),
                  const Text(
                    'No offers available',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
              ),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document =
                    snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10, top: 10, right: 10, bottom: 10),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(68, 253, 114, 71),
                                borderRadius: BorderRadius.circular(2),
                                border: const Border.symmetric(),
                                boxShadow: const [],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 2, bottom: 2, left: 8, right: 8),
                                child: Text(
                                  document['OfferDiscount'] + '% Off',
                                  // data['OfferDiscount'] + '% Off',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 230, 100, 14),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            imageUrl: document['OfferImage'],
                            imageBuilder: (context, imageProvider) => Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) => const Center(
                                child: Text(
                              'No offer image available for this item',
                              style: TextStyle(),
                              textAlign: TextAlign.center,
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              height: 25,
                              child: Text(
                                document['OfferName'].toString(),
                                style: const TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Category: ' + document['Category'],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 196, 196, 196),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  document['OfferAvailability'] == 'Available'
                                      ? const Color.fromARGB(20, 76, 175, 79)
                                      : const Color.fromARGB(20, 255, 0, 0),
                              borderRadius: BorderRadius.circular(2),
                              border: const Border.symmetric(),
                              boxShadow: const [],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 2, left: 8, right: 8),
                              child: Text(
                                document['OfferAvailability'],
                                style: TextStyle(
                                  color: document['OfferAvailability'] ==
                                          'Available'
                                      ? Colors.green
                                      : const Color.fromARGB(255, 255, 0, 0),
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                // return Text(
                //   document['OfferName'].toString(),
                //   style: const TextStyle(
                //     fontSize: 20,
                //   ),
                // );
              },
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
