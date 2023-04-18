import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/app_dimensions.dart';
import 'package:riteway/configs/app_typography.dart';
import 'package:riteway/configs/space.dart';

class ConfirmRideScreen extends StatelessWidget {
  const ConfirmRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/car.json',
            height: AppDimensions.normalize(80),
          ),
          Space.y2!,
          Center(
            child: Text(
              'Ride is Starting...',
              style: AppText.h1,
            ),
          ),
        ],
      ),
    );
  }
}
