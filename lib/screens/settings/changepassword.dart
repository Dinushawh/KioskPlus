// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(
      {super.key, required this.userDocumentID, required this.emailAddress});

  final String userDocumentID;
  final String emailAddress;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

late String _snackbarContent;
late Color _snackbarColor;
List<String> str = [
  "Is longer than 7 characters",
  "Does not match or significantly contain your username, eg do not use 'username123' as a password",
];
bool isLoading = false;
bool _isObscure = true;

final _currentPasswordController = TextEditingController();
final _newPasswordController = TextEditingController();
final _renewPasswordController = TextEditingController();

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => {
                  Navigator.of(context).pop(),
                  clearAll(),
                }),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'In order to ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                          text: 'protect your account, ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      TextSpan(
                        text: 'make sure your password:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: str.map((strone) {
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
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Password",
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
                          hintText: 'Current Password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 2.0),
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
                      const Text(
                        "New Password",
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          border: const OutlineInputBorder(),
                          hintText: 'New Password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 2.0),
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
                      const Text(
                        "Confirm New Password",
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      TextFormField(
                        controller: _renewPasswordController,
                        keyboardType: TextInputType.text,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          border: const OutlineInputBorder(),
                          hintText: 'Re-enter New Password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 66, 103, 178),
                                width: 2.0),
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 66, 103, 178),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _changePassword();
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
                            : const Text('Change Password'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _changePassword() async {
    try {
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.emailAddress,
          password: _currentPasswordController.text);
      print('user-loggin-successful');
      print(credential);
      if (_newPasswordController.text != _renewPasswordController.text) {
        snackBar('Password do not match');
      } else {
        print(credential.user);
        await credential.user?.updatePassword(_newPasswordController.text);
        if (credential.user != null) {
          snackBar('Password Changed');
          clearAll();
        } else {
          snackBar('Password change failed');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        snackBar('Incorrect Password');
      }
    }
  }

  clearAll() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _renewPasswordController.clear();
  }

  snackBar(String snackBartype) {
    if (snackBartype == 'Password Changed') {
      showSnackbar('Password Changed', Colors.green);
    } else if (snackBartype == 'Incorrect Password') {
      showSnackbar('Incorrect Password', Colors.redAccent);
    } else if (snackBartype == 'Password change failed') {
      showSnackbar('Password change failed', Colors.redAccent);
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
