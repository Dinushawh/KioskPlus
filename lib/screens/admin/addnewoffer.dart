// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class AddNewOffer extends StatefulWidget {
  const AddNewOffer({super.key});

  @override
  State<AddNewOffer> createState() => _AddNewOfferState();
}

class _AddNewOfferState extends State<AddNewOffer> {
  final _formKey = GlobalKey<FormState>();
  final _titelController = TextEditingController();
  final _quntityController = TextEditingController();
  final _discountController = TextEditingController();

  bool isLoading = false;

  final List<String> _items = ["Available", "Not Available"];
  final List<String> _categories = [
    'Fashion',
    'Food',
    'Tegnology',
    'Education',
    'Sports',
    'Automobile',
  ];
  late String _selectedValue = _items[0];
  late String _selectedValue2 = _categories[0];
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String _imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('object');
        showDialogBox2();
        _imageUrl != ''
            ? _storage
                .refFromURL(_imageUrl)
                .delete()
                .then((value) => _imageUrl = '')
                .whenComplete(() => Navigator.pop(context))
            : Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _imageUrl != ''
                  ? _storage
                      .refFromURL(_imageUrl)
                      .delete()
                      .then((value) => _imageUrl = '')
                      .whenComplete(() => Navigator.pop(context))
                  : Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Offer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Add a new offer to your kiosk',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Offer Image',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        if (_imageUrl != '')
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CachedNetworkImage(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 1.5,
                                imageUrl: _imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                ),
                              ),
                            ],
                          )
                        else
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 1.5,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  openSpecification();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Color.fromARGB(255, 133, 133, 133),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        const Text(
                          'Offer Title',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _titelController,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Ultra-Lightweight Laptop Backpack',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          validator: ((value) =>
                              value!.isEmpty ? 'Enter a title ' : null),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Quntity',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _quntityController,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: '10',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          validator: ((value) => value!.isEmpty
                              ? 'Enter a quntity that on the store'
                              : null),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Discount',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _discountController,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: '10% off',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          validator: ((value) => value!.isEmpty
                              ? 'Enter a discount to offer'
                              : null),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Availability',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          // isExpanded: true,
                          value: _selectedValue,
                          items: _items.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Category',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          // isExpanded: true,
                          value: _selectedValue2,
                          items: _categories.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedValue2 = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 3, 0, 20),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          // _createAccount();
                          addEntry();
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
                        : const Text('Add now'),
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
        });
  }

  clearParameters() {
    _imageUrl = '';
  }

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

    final path = image.path;
    final filename = image.name;
    uploadFile(path, filename).then((value) => print("Done"));
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

    final path = image.path;
    final filename = image.name;
    uploadFile(path, filename).then((value) => print("Done"));
  }

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      var uploadimg = await _storage.ref('OfferImages/$fileName').putFile(file);
      String url = await (uploadimg).ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
      print(url);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future addEntry() async {
    final CollectionReference offerCollection =
        FirebaseFirestore.instance.collection('Offers');
    await offerCollection.add({
      'OfferName': _titelController.text,
      'OfferDiscount': _discountController.text,
      'OfferQuntity': _quntityController.text,
      'OfferImage': _imageUrl,
      'OfferAvailability': _selectedValue,
      'Category': _selectedValue2,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Offer Added Successfully"),
      ),
    );
    _imageUrl = '';
    _titelController.clear();
    _discountController.clear();
    _quntityController.clear();
    _selectedValue = _items[0];
  }

  showDialogBox2() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('ALERT'),
          content: const Text(
              'You have made some changes do you want to exit without saving?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                setState(() {});
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
