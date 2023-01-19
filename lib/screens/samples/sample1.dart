// // ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart' as firebase_core;

// class Sample1 extends StatefulWidget {
//   const Sample1({super.key});

//   @override
//   State<Sample1> createState() => _Sample1State();
// }

// Map<String, dynamic> data5 = {};
// var newimageUrl;
// var oldimageurl;

// class _Sample1State extends State<Sample1> {
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference abcd = FirebaseFirestore.instance.collection('users');

//     return WillPopScope(
//       onWillPop: () async {
//         print('object');
//         // showDialogBox2();
//         // _imageUrl != ''
//         //     ? _storage
//         //         .refFromURL(_imageUrl)
//         //         .delete()
//         //         .then((value) => _imageUrl = '')
//         //         .whenComplete(() => Navigator.pop(context))
//         Navigator.pop(context);
//         return Future.value(false);
//       },
//       child: FutureBuilder<DocumentSnapshot>(
//           future: abcd.doc('rrpYQZoN2nrM4UuARWHV').get(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               data5 = snapshot.data!.data() as Map<String, dynamic>;
//               oldimageurl = data5['Profile Picture'];
//               return Scaffold(
//                 appBar: AppBar(
//                   elevation: 0,
//                   backgroundColor: Colors.white,
//                   leading: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black),
//                     onPressed: () => {deleteandback()},
//                   ),
//                   title: const Text(
//                     'Genaral Account Settings',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 body: SafeArea(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(top: 30, left: 30, right: 30),
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: 75,
//                                 height: 75,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 218, 216, 216),
//                                   borderRadius: BorderRadius.circular(120),
//                                 ),
//                               ),
//                               CachedNetworkImage(
//                                 height: 70,
//                                 width: 70,
//                                 imageUrl: newimageUrl ?? oldimageurl,
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                     image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 placeholder: (context, url) =>
//                                     const CircularProgressIndicator(),
//                                 errorWidget: (context, url, error) =>
//                                     const Icon(Icons.error),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   openSpecification();
//                                 },
//                                 icon: Icon(
//                                   Icons.camera_alt_rounded,
//                                   color: Colors.white.withOpacity(0.6),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                           onPressed: () {
//                             print(newimageUrl);
//                             print(oldimageurl);
//                           },
//                           child: Text('click')),
//                       ElevatedButton(
//                           onPressed: () {
//                             // donemet();
//                           },
//                           child: Text('click')),
//                       ElevatedButton(
//                           onPressed: () {
//                             savedata();
//                           },
//                           child: Text('Save'))
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           }),
//     );
//   }

//   void openSpecification() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: const Color(0xFF737373),
//           height: MediaQuery.of(context).size.height * 0.2,
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Theme.of(context).canvasColor,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20.0),
//                   topRight: Radius.circular(20.0),
//                 )),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 0),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Select profile picture",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                           icon: const Icon(
//                             Icons.close,
//                             color: Colors.black,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         leading: const Icon(Icons.camera_alt_rounded),
//                         title: const Text('Camera'),
//                         onTap: () {
//                           //
//                           getImage(ImageSource.camera);
//                         },
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.image),
//                         title: const Text('Gallery'),
//                         onTap: () {
//                           getImage(ImageSource.gallery);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   getImage(var type) async {
//     final image = await ImagePicker().pickImage(source: type);
//     if (image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("No image selected"),
//         ),
//       );
//       return null;
//     }
//     final path = image.path;
//     final filename = image.name;
//     newimageUrl == null ? print('null') : print('not null');

//     newimageUrl == null
//         ? uploadFile(path, filename).then((value) => print("Done"))
//         : _storage.refFromURL(newimageUrl).delete().then((value) {
//             uploadFile(path, filename).then((value) => print("Done"));
//           });
//   }

//   Future<void> uploadFile(String filePath, String fileName) async {
//     File file = File(filePath);
//     try {
//       var uploading =
//           await _storage.ref('ProfilePictures/$fileName').putFile(file);
//       String url = await (uploading).ref.getDownloadURL();
//       setState(() {
//         newimageUrl = url;
//       });
//       print(url);
//     } on firebase_core.FirebaseException catch (e) {
//       print(e);
//     }
//   }

//   Future deleteandback() async {
//     print(newimageUrl);
//     if (newimageUrl != null) {
//       await _storage.refFromURL(newimageUrl).delete();
//       newimageUrl = '';
//       getData();
//     }
//     Navigator.of(context).pop();
//   }

//   savedata() async {
//     await FirebaseFirestore.instance
//         .collection('test')
//         .doc('Uk3V4ulomnYF38794v5p')
//         .update({'abc': newimageUrl});
//   }

//   getData() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc('rrpYQZoN2nrM4UuARWHV')
//         .get()
//         .then((value) {
//       data5 = value.data() as Map<String, dynamic>;
//       oldimageurl = data5['Profile Picture'];
//       setState(() {
//         data5 = {};
//       });
//     });
//   }
// }
