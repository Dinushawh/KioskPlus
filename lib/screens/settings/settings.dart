import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:kioskplus/screens/settings/changeemail.dart';
import 'package:kioskplus/screens/settings/changepassword.dart';
import 'package:kioskplus/screens/settings/deleteaccount.dart';
import 'package:kioskplus/screens/settings/personalinformation.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String _email = '';
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
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              ListTile(
                minLeadingWidth: 0.0,
                minVerticalPadding: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 90, 90, 90),
                    )
                  ],
                ),
                title: const Text('Personal Information'),
                subtitle: const Text('Communication device'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInformations(
                        userDocumentID: widget.userDocumentID,
                      ),
                    ),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Sample2(
                  //       userDocumentID: widget.userDocumentID,
                  //     ),
                  //   ),
                  // );
                },
              ),
              ListTile(
                minLeadingWidth: 0.0,
                minVerticalPadding: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.email_rounded,
                      color: Color.fromARGB(255, 90, 90, 90),
                    )
                  ],
                ),
                title: const Text('Change Email'),
                subtitle: const Text('Communication device'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeEmail(
                        userDocumentID: widget.userDocumentID,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                minLeadingWidth: 0.0,
                minVerticalPadding: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.password_rounded,
                      color: Color.fromARGB(255, 90, 90, 90),
                    )
                  ],
                ),
                title: const Text('Change Password'),
                subtitle: const Text('Communication device'),
                onTap: () {
                  getEmailAddress(widget.userDocumentID);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(
                        userDocumentID: widget.userDocumentID,
                        emailAddress: _email,
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              ListTile(
                minLeadingWidth: 0.0,
                minVerticalPadding: 0.0,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.redAccent,
                    )
                  ],
                ),
                title: const Text('Delete Account Permanently'),
                subtitle: const Text('Communication device'),
                onTap: () {
                  getEmailAddress(widget.userDocumentID);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteAccount(
                        userDocumentID: widget.userDocumentID,
                        emailAddress: _email,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getEmailAddress(String userDocumentID) async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentID)
        .get();
    _email = documentSnapshot['Email'];
  }
}
