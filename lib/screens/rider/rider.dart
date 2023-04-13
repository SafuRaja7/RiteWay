import 'package:flutter/material.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/configs/app_typography.dart';
import 'package:riteway/cubits/auth/cubit.dart';

class Rider extends StatefulWidget {
  const Rider({super.key});

  @override
  State<Rider> createState() => _RiderState();
}

class _RiderState extends State<Rider> {
  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.cubit(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            authCubit.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
        actions: [
          BackButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
        ],
        title: Text(
          'Rider',
          style: AppText.b1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello Rider',
              style: AppText.h1b,
            )
          ],
        ),
      ),
    );
  }
}
