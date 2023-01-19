// ignore_for_file: unused_field, prefer_final_fields, avoid_print, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';

class UpdateOffer extends StatefulWidget {
  const UpdateOffer({super.key, required this.productDocument});

  final String productDocument;
  @override
  State<UpdateOffer> createState() => _UpdateOfferState();
}

class _UpdateOfferState extends State<UpdateOffer> {
  late String _offertitle;
  TextEditingController _offertitleController = TextEditingController();

  Map data = {};
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Offers')
            .doc(widget.productDocument)
            .get()
            .then((value) => value),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            data = snapshot.data!.data() as Map<String, dynamic>;
            return UpdatePage(
              availability: data['OfferAvailability'],
              category: data['Category'],
              discount: data['OfferDiscount'],
              imageUrl: data['OfferImage'],
              productDocument: widget.productDocument,
              quntity: data['OfferQuntity'],
              title: data['OfferName'],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  checkChanges() {
    _offertitleController.text == _offertitle
        ? print('same')
        : print('different');
  }
}

class UpdatePage extends StatefulWidget {
  const UpdatePage(
      {super.key,
      required this.imageUrl,
      required this.productDocument,
      required this.title,
      required this.quntity,
      required this.discount,
      required this.availability,
      required this.category});

  final imageUrl;
  final String productDocument;
  final String title;
  final String quntity;
  final String discount;
  final String availability;
  final String category;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late String _snackbarContent;
  late Color _snackbarColor;

  bool isLoading = false;
  // bool updatestatus = false;
  bool state = false;
  final _formKey = GlobalKey<FormState>();
  // late String _offertitle = widget.title;
  TextEditingController _offertitleController = TextEditingController();
  TextEditingController _offerquantityController = TextEditingController();
  TextEditingController _offerdiscountController = TextEditingController();

  final List<String> _items = ["Available", "Not Available"];
  final List<String> _categories = [
    'Fashion',
    'Food',
    'Tegnology',
    'Education',
    'Sports',
    'Automobile',
  ];

  late int _selectedValue;
  late String positon = _items[_selectedValue];

  late int _selectedValue2;
  late String positon2 = _categories[_selectedValue2];

  var newimageUrl;

  late String title;
  late String quntity;
  late String discount;
  late String availability;
  late String category;
  var image;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    _offertitleController = TextEditingController(text: title);

    quntity = widget.quntity;
    _offerquantityController = TextEditingController(text: widget.quntity);

    discount = widget.discount;
    _offerdiscountController = TextEditingController(text: widget.discount);

    availability = widget.availability;
    _selectedValue = (_items.indexOf(widget.availability));

    category = widget.category;
    print(widget.category);
    _selectedValue2 = (_categories.indexOf(widget.category));

    image = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _offertitleController.text == title &&
                _offerquantityController.text == quntity &&
                _offerdiscountController.text == discount &&
                positon2 == category &&
                positon == availability &&
                newimageUrl == null
            ? Navigator.pop(context)
            : showDialogBox();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Update and delete Offer',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Do you want to delete this offer from the Kiosk?',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                  const Text(
                      'Here you can mmake changes to the offer delete from the Kiosk'),
                  const SizedBox(
                    height: 7,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 243, 16, 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        checkChanges();
                        // updatestatus = true;
                        setState(() {
                          isLoading = true;
                          deleteOffer();
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
                        : const Text('Delete this Offer'),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Update offer information',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  ),
                  const Text(
                      'Here you can make changes to your product\'s information and settings. '),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Offer Image',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        productImage(),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Offer Title',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        TextFormField(
                          controller: _offertitleController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Your offer title',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // updatestatus = true;
                            });
                          },
                          validator: ((value) =>
                              value!.isEmpty ? 'Enter valid title' : null),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Quntity',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        TextFormField(
                          controller: _offerquantityController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Your offer title',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // updatestatus = true;
                            });
                          },
                          validator: ((value) =>
                              value!.isEmpty ? 'Enter valid title' : null),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Discount',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        TextFormField(
                          controller: _offerdiscountController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: OutlineInputBorder(),
                            hintText: 'Your offer title',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 66, 103, 178),
                                  width: 2.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // updatestatus = true;
                            });
                          },
                          validator: ((value) =>
                              value!.isEmpty ? 'Enter valid title' : null),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Offer Availability',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        DropdownButton<String>(
                          value: positon,
                          items: _items.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              // updatestatus = true;
                              positon = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Offer Category',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                        const SizedBox(height: 7.0),
                        DropdownButton<String>(
                          value: positon2,
                          items: _categories.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              // updatestatus = true;
                              positon2 = value!;
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
                        checkChanges();
                        // updatestatus = true;
                        updateInformations();
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
                        : const Text('Update Offer Details'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  productImage() {
    return widget.imageUrl != null
        ? Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CachedNetworkImage(
                height: 200,
                width: MediaQuery.of(context).size.width * 1.5,
                imageUrl: newimageUrl ?? widget.imageUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
        : Container(
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
          );
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  openSpecification() {
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
      var uploadimg = await _storage.ref('OfferImages/$fileName').putFile(file);
      String url = await (uploadimg).ref.getDownloadURL();
      setState(() {
        newimageUrl = url;
      });
      print(url);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  checkChanges() {
    _offertitleController.text == widget.title &&
            _offerquantityController.text == widget.quntity &&
            _offerdiscountController.text == widget.discount &&
            positon2 == widget.category &&
            positon == widget.availability &&
            newimageUrl == null
        ? print('same')
        : print('different');
  }

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

  deleteandback() async {
    if (newimageUrl != null) {
      await _storage.refFromURL(newimageUrl).delete();
      setState(() {
        newimageUrl = null;
      });
    }
    Navigator.of(context).pop();
  }

  Future updateInformations() async {
    await FirebaseFirestore.instance
        .collection('Offers')
        .doc(widget.productDocument)
        .update({
      'OfferName': _offertitleController.text,
      'OfferQuntity': _offerquantityController.text,
      'OfferDiscount': _offerdiscountController.text,
      'Category': positon2,
      'OfferAvailability': positon,
      'OfferImage': newimageUrl,
    });

    title = _offertitleController.text;
    quntity = _offerquantityController.text;
    discount = _offerdiscountController.text;
    category = positon2;
    availability = positon;
    image = newimageUrl;
    newimageUrl = null;

    snackBar('Offer Updated');
  }

  Future deleteOffer() async {
    await FirebaseFirestore.instance
        .collection('Offers')
        .doc(widget.productDocument)
        .delete();
    snackBar('Offer Deleted');

    Navigator.of(context).pop();
  }

  showSnackbar(String content, Color color) {
    setState(() {
      _snackbarContent = content;
      _snackbarColor = color;
    });
  }

  snackBar(String snackBartype) {
    if (snackBartype == 'Offer Deleted') {
      showSnackbar('Offer successfully deleted from the server', Colors.green);
    } else if (snackBartype == 'Offer Updated') {
      showSnackbar('Offer successfully updated', Colors.green);
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
}
