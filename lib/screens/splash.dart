import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riteway/animations/bottom_animation.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(
        milliseconds: 3,
      ),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WidgetAnimator(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/applogo.png'),
                ),
                Text(
                  'RiteWay',
                  style: AppText.h2b,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
