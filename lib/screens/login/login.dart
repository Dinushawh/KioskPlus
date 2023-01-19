// ignore_for_file: unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/forgetpassword/forgetpassword.dart';
import 'package:kioskplus/screens/quiz/quiz.dart';
import 'package:kioskplus/screens/register/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  get regExp => RegExp(pattern);

  bool _isObscure = true;
  bool isChecked = false;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late String emailAddress;

  Future _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _getuserDocumentIDandPush();
      clearText();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar();
        isLoading = false;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        snackBar2();
        isLoading = false;
        print('Wrong password provided for that user.');
      }
    }
  }

  Future _getuserDocumentIDandPush() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('Email', isEqualTo: _emailController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc["Account Type"]);
        print(doc["Full Name"]);
        print(querySnapshot.docs.first.id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Quiz(
              userDocumentID: querySnapshot.docs.first.id,
            ),
          ),
        );

        clearText();
      }
    });
  }

  clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Lets sign you in",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  const Text(
                    "Welcome Back, You have been missed!",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
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
                              return 'Please enter valid Email Address';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Please enter valid Email Address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text(
                              "Password",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forget Password?",
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 66, 103, 178),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            border: const OutlineInputBorder(),
                            hintText: 'Your secret phase 😎',
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
                                // _isObscure = !_isObscure;
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(7000, 50),
                      backgroundColor: const Color.fromARGB(255, 66, 103, 178),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        isLoading = true;
                        _login();
                        Future.delayed(const Duration(seconds: 3), () {
                          isLoading = false;
                          //   setState(() {
                          //     isLoading = false;
                          //   });
                          // });
                          // setState(() {
                          //   isLoading = true;
                          //   _login();
                          //   Future.delayed(const Duration(seconds: 3), () {
                          //     setState(() {
                          //       isLoading = false;
                          //     });
                          //   });
                        });
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
                        : const Text('Login'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            "Dont you have an account?",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ),
                              );
                            },
                            child: const Text('Sign up'),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  snackBar() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('User Not Found'),
          duration: Duration(seconds: 3),
        ),
      );
  snackBar2() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Incorrect Username or Password'),
          duration: Duration(seconds: 3),
        ),
      );
}
