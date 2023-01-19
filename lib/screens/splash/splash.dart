import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kioskplus/screens/login/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late final Timer _runsplash;
  Timer getTimer() {
    return Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _runsplash = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    _runsplash.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 103, 178),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage('assets/logo/Logo-02.png'),
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
