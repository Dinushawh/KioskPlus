// ignore_for_file: unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/login/login.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount(
      {super.key, required this.userDocumentID, required this.emailAddress});

  final String userDocumentID;
  final String emailAddress;
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

final _accountPasswordController = TextEditingController();
final _accountEmailController = TextEditingController();
final _feedbackController = TextEditingController();

final _formKey = GlobalKey<FormState>();
var session = 'inactive';

List<Map> reasonList = [
  {
    'reason': 'I don\'t like the app',
  },
  {
    'reason': 'I don\'t like the content',
  },
  {
    'reason': 'I don\'t like the ads',
  },
  {
    'reason': 'I don\'t want to use the app anymore',
  },
  {
    'reason': 'I have another account',
  },
  {
    'reason': 'The app is not working properly',
  },
];

bool isLoading = false;
bool _isObscure = false;

class _DeleteAccountState extends State<DeleteAccount> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        session == 'active' ? showDialogBox2() : Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => session == 'active'
                ? showDialogBox2()
                : Navigator.of(context).pop(),
          ),
          title: const Text(
            'Delete your account',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select the reason for deleting your account',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
                            });
                          },
                          child: Center(
                            child: AnimatedContainer(
                              width: i == selectedIndex
                                  ? MediaQuery.of(context).size.width
                                  : i == selectedIndex
                                      ? 50
                                      : MediaQuery.of(context).size.width,
                              height: i == selectedIndex ? 40 : 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: i == selectedIndex
                                      ? Colors.red
                                      : const Color.fromARGB(0, 255, 255, 255),
                                ),
                                color: i == selectedIndex
                                    ? const Color.fromARGB(86, 178, 66, 66)
                                    : const Color.fromARGB(255, 238, 238, 238),
                              ),
                              duration: const Duration(seconds: 1),
                              curve: Curves.linear,
                              child: Center(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    i == selectedIndex
                                        ? const Icon(
                                            Icons.check_circle_rounded,
                                            size: 20,
                                            color: Colors.red,
                                          )
                                        : const SizedBox(
                                            width: 0,
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      reasonList[i]['reason'],
                                      style: TextStyle(
                                        fontSize: i == selectedIndex ? 18 : 16,
                                        fontWeight: i == selectedIndex
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                        color: i == selectedIndex
                                            ? Colors.red
                                            : const Color.fromARGB(
                                                255, 99, 98, 98),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Anything else you want to tell us?',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(34, 158, 158, 158), //

                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(34, 158, 158, 158),
                          ),
                        ),
                        hintText:
                            'Write somthing/suggest someting to improve our app',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(34, 158, 158, 158),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(34, 158, 158, 158),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '*All the data will be deleted permanently from our server including your profile, information, photos and collected data. You can\'t recover your account after deleting it.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Account email",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _accountEmailController,
                      cursorColor: Colors.redAccent,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                      ),
                      validator: ((value) => value!.isEmpty
                          ? 'Please enter your email address'
                          : null),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Account password:",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    TextFormField(
                      controller: _accountPasswordController,
                      cursorColor: Colors.redAccent,
                      keyboardType: TextInputType.text,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        hintText: 'Account password',
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 1.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      validator: ((value) =>
                          value!.isEmpty ? 'Please enter your password' : null),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(7000, 40),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          getfeedback();
                          deleteuserinterests();
                          deleteuserdata();
                          deletedAccountInformations();
                          showDialogBox();
                          clearfeilds();

                          setState(() {
                            session = 'active';
                            isLoading = false;
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
                          : const Text('Delete my account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late String _imageUrl;
  late String _name;
  late String _accounttype;
  late String _email;

  Future getfeedback() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userDocumentID)
        .get()
        .then((value) {
      setState(() {
        _imageUrl = value['Profile Picture'];
        _name = value['Full Name'];
        _accounttype = value['Account Type'];
        _email = value['Email'];

        print(_imageUrl + _name + _accounttype + _email);
      });
    });
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'reason': reasonList[selectedIndex]['reason'],
      'feedback': _feedbackController.text == ''
          ? 'No feedback'
          : _feedbackController.text,
      'userdocument': widget.userDocumentID,
      'name': _name,
      'email': _email,
      'accounttype': _accounttype,
      'profilepicture': _imageUrl,
      'date': DateTime.now(),
    });
  }

  Future deletedAccountInformations() async {
    try {
      setState(() {
        isLoading = true;
      });
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _accountEmailController.text,
              password: _accountPasswordController.text)
          .then((userCredential) {
        userCredential.user!.delete();
        print('Account deleted');
      });
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future deleteuserdata() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userDocumentID)
        .delete();
  }

  Future deleteuserinterests() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionRef = firestore.collection('interests');
    Query query =
        collectionRef.where('User Name', isEqualTo: widget.userDocumentID);
    QuerySnapshot querySnapshot = await query.get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    WriteBatch batch = firestore.batch();

    for (DocumentSnapshot document in documents) {
      batch.delete(document.reference);
    }

    await batch.commit();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Your account has been deleted. We are sorry to see you go! We hope you will come back soon!'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Ok');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
  showDialogBox2() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Expired'),
          content: const Text(
              'Your session has expired. Please login again to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Ok');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );

  clearfeilds() {
    _accountEmailController.clear();
    _accountPasswordController.clear();
    _feedbackController.clear();
  }
}
