// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/admin/admin.dart';
import 'package:kioskplus/screens/home/items/items.dart';
import 'package:kioskplus/screens/login/login.dart';
import 'package:kioskplus/screens/profile/profile.dart';
import 'package:kioskplus/screens/quiz/quiz.dart';
import 'package:kioskplus/screens/settings/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<Home> createState() => _HomeState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userDocumentID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: scaffoldKey,
              drawer: Drawer(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                    left: 30,
                    right: 30,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data!['Profile Picture'],
                            imageBuilder: (context, imageProvider) => Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['Full Name'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data!['Email'],
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('interests')
                                    .where('User Name',
                                        isEqualTo: widget.userDocumentID)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int? count = snapshot.data?.docs.length;
                                    print(count);
                                    return Text(
                                      'Interests: $count',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    );
                                  }
                                  return const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(),
                          snapshot.data!['Account Type'] == 'admin'
                              ? Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                        Icons.admin_panel_settings_rounded,
                                        color: Colors.black,
                                      ),
                                      title: const Text(
                                        'Manage Kiosks',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Admin(
                                              userDocumentID:
                                                  widget.userDocumentID,
                                            ),
                                          ),
                                        ),
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                )
                              : Container(),
                          ListTile(
                            leading: const Icon(
                              Icons.analytics_outlined,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Take Quiz',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Quiz(
                                    userDocumentID: widget.userDocumentID,
                                  ),
                                ),
                              ),
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Profile',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                    userDocumentID: widget.userDocumentID,
                                  ),
                                ),
                              ),
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.settings_outlined,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Settings and Privacy',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileSettings(
                                    userDocumentID: widget.userDocumentID,
                                  ),
                                ),
                              ),
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.logout_rounded,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Sign Out',
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Login(),
                                ),
                              );
                              await auth.signOut();
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                      Expanded(
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.help_outline_rounded,
                                    color: Colors.black,
                                  ),
                                  title: const Text(
                                    'Help & Feedback',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () => {},
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 0),
                        child: CachedNetworkImage(
                          height: 35,
                          width: 35,
                          imageUrl: snapshot.data!['Profile Picture'],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(38),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.analytics_outlined,
                      color: Color.fromARGB(255, 34, 0, 61),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Quiz(
                            userDocumentID: widget.userDocumentID,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.power_settings_new,
                      color: Color.fromARGB(255, 34, 0, 61),
                    ),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const Login(),
                        ),
                      );
                      await auth.signOut();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              body: const Items(),
            );
          }
          return const SizedBox(
            height: 0,
            width: 0,
          );
        });
  }
}
