import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/splash/splash.dart';

import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  // runApp(
  //    runApp(const MyApp());
  //   // DevicePreview(
  //   //   enabled: true,
  //   //   builder: (context) => const MyApp(),
  //   // ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}
