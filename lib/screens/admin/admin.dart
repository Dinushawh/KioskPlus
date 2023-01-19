import 'package:flutter/material.dart';
import 'package:kioskplus/screens/admin/addnewoffer.dart';
import 'package:kioskplus/screens/admin/chart.dart';
import 'package:kioskplus/screens/admin/offers.dart';
import 'package:kioskplus/screens/admin/statistics.dart';

class Admin extends StatefulWidget {
  const Admin({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const SizedBox(
                  height: 100,
                  child: Statistics(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Statistics on each category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  child: Chart(
                    userDocumentID: widget.userDocumentID,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Offers',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 3, 0, 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddNewOffer()),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      label: const Text('Add offer'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 400,
                  child: Offers(
                    userDocumentID: widget.userDocumentID,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
