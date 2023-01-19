// ignore_for_file: unused_local_variable, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:kioskplus/screens/login/login.dart';
import 'package:kioskplus/screens/success/success.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final _emailController = TextEditingController();
final _nameController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  get regExp => RegExp(pattern);

  bool _isObscure = true;
  bool isChecked = false;
  bool isLoading = false;

  RegExp regexp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  Future _createAccount() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _userProfile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Success(),
        ),
      );
      clearText();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBar();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        snackBar2();
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future _userProfile() async {
    await FirebaseFirestore.instance.collection('users').add({
      'Email': _emailController.text,
      'Full Name': _nameController.text,
      'Account Type': 'user',
      'Profile Picture': _imageUrl,
    });
  }

  clearText() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String _imageUrl = '';

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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
        ),
      ),
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
                    "Lest create Account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  const Text(
                    "A few clicks away from creating your KioskPlus Account",
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
                          "Profile Picture",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        _imageUrl != ''
                            ? Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  CachedNetworkImage(
                                    height: 80,
                                    width: 80,
                                    imageUrl: _imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      openSpecification();
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Color.fromARGB(150, 255, 255, 255),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  fit: StackFit.expand,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor:
                                          Color.fromARGB(255, 219, 219, 219),
                                    ),
                                    Center(
                                      child: IconButton(
                                        onPressed: () {
                                          openSpecification();
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 20),
                        const Text(
                          "Your Full Name",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Dinusha Weerakoon',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          validator: ((value) => value!.isEmpty
                              ? 'Please enter your Full Name'
                              : null),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Your Email",
                          style: TextStyle(fontSize: 18),
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
                              return 'Please enter valid phone number';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(fontSize: 18),
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
                          "Confirm Password",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
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
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            } else if (value != _passwordController.text) {
                              return 'Password does not match';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else if (!regexp.hasMatch(value)) {
                              return 'Password must contain at least one number and one special character';
                            }
                            return null;
                          },
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
                        setState(() {
                          isLoading = true;
                          _createAccount();

                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
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
                        : const Text('Register'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text(
                          "Already Have an Account?",
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
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openSpecification() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xFF737373),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 0),
                  child: Row(
                    children: [
                      const Text(
                        "Select Offer Image",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt_rounded),
                        title: const Text('Camera'),
                        onTap: () {
                          getImageCamara();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Gallery'),
                        onTap: () {
                          getImageGallery();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  snackBar() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('The password provided is too weak.'),
          duration: Duration(seconds: 3),
        ),
      );
  snackBar2() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('The account already exists for that email.'),
          duration: Duration(seconds: 3),
        ),
      );

  Future getImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No image selected"),
        ),
      );
      return null;
    }

    final Path = image.path;
    final filename = image.name;
    uploadFile(Path, filename).then((value) => print("Done"));
  }

  Future getImageCamara() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No image selected"),
        ),
      );
      return null;
    }

    final Path = image.path;
    final filename = image.name;
    uploadFile(Path, filename).then((value) => print("Done"));
  }

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      var uploadimg =
          await _storage.ref('ProfilePictures/$fileName').putFile(file);
      String url = await (uploadimg).ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
      print(url);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
}
