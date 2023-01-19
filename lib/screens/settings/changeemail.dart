// ignore_for_file: unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

List<String> reasonList = [
  'Assign all of your data to new email',
  'Old email is removed from the system and the servers and cannt be reused again within 6 months',
];

bool _isObscure = false;
bool isLoading = false;

final _currentEmailController = TextEditingController();
final _newEmailController = TextEditingController();
final _currentPasswordController = TextEditingController();

late String _snackbarContent;
late Color _snackbarColor;

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
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
          'Change your email',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Note: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Changing your email address will change your accounts email address.After changing your email address, you will be automatically logged out of your account.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: reasonList.map((strone) {
                      return Row(children: [
                        const Text(
                          '•',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            strone,
                          ),
                        )
                      ]);
                    }).toList(),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Current email address:",
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _currentEmailController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(),
                          hintText: 'Current email address',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 1),
                          ),
                        ),
                        validator: ((value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "New email address:",
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _newEmailController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(),
                          hintText: 'New email address',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 1.0),
                          ),
                        ),
                        validator: ((value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Account password:",
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _currentPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          border: const OutlineInputBorder(),
                          hintText: 'Account password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 1.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 66, 103, 178),
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        validator: ((value) => value!.isEmpty
                            ? 'Please enter your password'
                            : null),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 103, 178),
                  ),
                  onPressed: () async {
                    // chnageEmail();
                    if (_formKey.currentState!.validate()) {
                      chnageEmail();
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Chnage account email'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future chnageEmail() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _currentEmailController.text,
              password: _currentPasswordController.text)
          .then((userCredential) {
        userCredential.user?.updateEmail(_newEmailController.text);

        if (userCredential.user != null) {
          snackBar('Email Changed');
          updateInformations();
          clearAll();
        } else {
          snackBar('Email change failed');
        }
        clearAll();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future updateInformations() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userDocumentID)
        .update({'Email': _newEmailController.text}).then(
            (value) => print("User Updated"));
  }

  clearAll() {
    _currentEmailController.clear();
    _newEmailController.clear();
    _currentPasswordController.clear();
  }

  snackBar(String snackBartype) {
    if (snackBartype == 'Email Changed') {
      showSnackbar('Email Changed Successfully', Colors.green);
    } else if (snackBartype == 'Email change failed') {
      showSnackbar('Something went during the email changing process!',
          Colors.redAccent);
    } else if (snackBartype == 'Password do not match') {
      showSnackbar('Password do not match', Colors.orangeAccent);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _snackbarColor,
        content: Text(_snackbarContent),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  showSnackbar(String content, Color color) {
    setState(() {
      _snackbarContent = content;
      _snackbarColor = color;
    });
  }
}
