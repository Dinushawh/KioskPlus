// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print, prefer_if_null_operators, prefer_typing_uninitialized_variables, unnecessary_late

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class PersonalInformations extends StatefulWidget {
  const PersonalInformations({super.key, required this.userDocumentID});

  final String userDocumentID;
  @override
  State<PersonalInformations> createState() => _PersonalInformationsState();
}

final _formKey = GlobalKey<FormState>();
bool isLoading = false;

final TextEditingController _textController = TextEditingController(text: name);

var oldimageurl;
var newimageUrl;
late String name = '';
late String oldname = '';

Map<String, dynamic> data5 = {};

class _PersonalInformationsState extends State<PersonalInformations> {
  @override
  Widget build(BuildContext context) {
    CollectionReference abcd = FirebaseFirestore.instance.collection('users');
    return WillPopScope(
      onWillPop: () async {
        newimageUrl != null || _textController.text != name
            ? showDialogBox()
            : Navigator.pop(context);
        return Future.value(false);
      },
      child: FutureBuilder<DocumentSnapshot>(
          future: abcd.doc(widget.userDocumentID).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data5 = snapshot.data!.data() as Map<String, dynamic>;
              oldimageurl = data5['Profile Picture'];
              name = oldname = data5['Full Name'];
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black),
                    onPressed: () => deleteandback(),
                  ),
                  title: const Text(
                    'Genaral Account Settings',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text("Genaral Account Settings",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Update profile picture",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 218, 216, 216),
                                    borderRadius: BorderRadius.circular(120),
                                  ),
                                ),
                                CachedNetworkImage(
                                  height: 70,
                                  width: 70,
                                  imageUrl: newimageUrl ?? oldimageurl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
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
                                IconButton(
                                  onPressed: () {
                                    openSpecification();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Full name",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _textController,
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 66, 103, 178),
                                    width: 2.0),
                              ),
                            ),
                            onChanged: (value) {
                              print('Current text: $value');
                            },
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your full name'
                                : _textController.text == name
                                    ? 'Nothing to update'
                                    : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Please note: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text:
                                      'Don\'t add any unusual capitalization, punctuation, characters or random words.',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 66, 103, 178),
                            ),
                            onPressed: () async {
                              updateData();
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
                                : const Text('Save changes'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
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
                        "Select profile picture",
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
                          //
                          getImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Gallery'),
                        onTap: () {
                          getImage(ImageSource.gallery);
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

  final FirebaseStorage _storage = FirebaseStorage.instance;

  getImage(var type) async {
    final image = await ImagePicker().pickImage(source: type);
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No image selected"),
        ),
      );
      return null;
    }
    final path = image.path;
    final filename = image.name;

    newimageUrl == null
        ? uploadFile(path, filename).then((value) => print("Done"))
        : _storage.refFromURL(newimageUrl).delete().then((value) {
            uploadFile(path, filename).then((value) => print("Done"));
          });
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
        newimageUrl = url;
      });
      print(url);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future updateData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userDocumentID)
        .update({
      'Full Name': _textController.text,
      'Profile Picture': newimageUrl == null ? oldimageurl : newimageUrl,
    });
    snackBar();

    newimageUrl = null;
  }

  Future deleteandback() async {
    if (newimageUrl != null) {
      await _storage.refFromURL(newimageUrl).delete();
      setState(() {
        newimageUrl = null;
        name = oldname;
      });
    }
    Navigator.of(context).pop();
  }

  snackBar() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 3),
        ),
      );

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Review changes'),
          content: const Text(
              'You have done some changes. Do you want to exit without save them?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Ok');
                deleteandback();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
