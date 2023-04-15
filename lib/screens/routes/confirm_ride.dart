import 'package:flutter/material.dart';
import 'package:riteway/configs/app_typography.dart';

class ConfirmRideScreen extends StatelessWidget {
  const ConfirmRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Text(
          'Ride is Starting...',
          style: AppText.h1,
        ),
      ),
    );
  }
}
