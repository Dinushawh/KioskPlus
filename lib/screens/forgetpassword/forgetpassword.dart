// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

late String _snackbarContent;
late Color _snackbarColor;
bool isLoading = false;

final _emailController = TextEditingController();
String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$";
get regExp => RegExp(pattern);
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Lets rests your account password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const Text(
                  "Please enter your account details to continue this process",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Your Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'dinusha@kioskplus.com',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid email';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Note: We will send you a password reset link to your email please check the inbox and rest your password through the link",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(7000, 50),
                    backgroundColor: const Color.fromARGB(255, 66, 103, 178),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      searchByValue();
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
                      : const Text('Send Password Reset Link'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  // void searchByValue(String collectionName, String field, var value) async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection(collectionName)
  //       .where(field, isEqualTo: value)
  //       .get();
  //   if (querySnapshot.docs.length > 0) {
  //     print('data found');
  //   } else {
  //     print('data not found');
  //   }
  // }
  Future searchByValue() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: _emailController.text)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print('data found');
      _submit();
    } else {
      print('data not found');
      snackBar('data not found');
    }
  }

  clearfeilds() {
    _emailController.clear();
  }

  Future _submit() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      print("Password reset email sent");
      snackBar('Password reset email sent');
      clearfeilds();
    } catch (e) {
      print("Error: $e");
      snackBar('Error');
    }
  }

  snackBar(String snackBartype) {
    if (snackBartype == 'Password reset email sent') {
      showSnackbar('Password reset email sent', Colors.green);
    } else if (snackBartype == 'Error') {
      showSnackbar(
          'There was an error during the sending of email', Colors.redAccent);
    } else if (snackBartype == 'data not found') {
      showSnackbar('There is no account associated with this email provided',
          Colors.orangeAccent);
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
