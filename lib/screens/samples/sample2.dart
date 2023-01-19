// ignore_for_file: prefer_final_fields, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sample2 extends StatefulWidget {
  const Sample2({super.key, required this.productDocument});
  final String productDocument;
  @override
  State<Sample2> createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  late String _fieldValue;
  late String namess;
  TextEditingController _fieldController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Offers")
        .doc(widget.productDocument)
        .get()
        .then((doc) {
      if (doc.exists) {
        _fieldValue = doc.data()!["Category"];
        namess = doc.data()!["OfferName"];
        _fieldController.text = _fieldValue;
        _nameController.text = namess;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _fieldController,
              onChanged: (value) {
                // if (value != _fieldValue) {
                //   // FirebaseFirestore.instance
                //   //     .collection("my_collection")
                //   //     .doc("doc_id")
                //   //     .update({"field_name": value});
                //   // _fieldValue = value;
                // }
                // _fieldController.text == _fieldValue
                //     ? print("No change")
                //     : print("Change");
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                // if (value != _fieldValue) {
                //   // FirebaseFirestore.instance
                //   //     .collection("my_collection")
                //   //     .doc("doc_id")
                //   //     .update({"field_name": value});
                //   // _fieldValue = value;
                // }
                // _fieldController.text == _fieldValue
                //     ? print("No change")
                //     : print("Change");
              },
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                (_fieldController.text != _fieldValue ||
                        _nameController.text != namess)
                    ? print("change")
                    : print("No Change");
              },
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
