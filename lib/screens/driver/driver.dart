import 'package:flutter/material.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/configs/app_typography.dart';
import 'package:riteway/cubits/auth/cubit.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  @override
  void initState() {
    super.initState();
    final authCubit = AuthCubit.cubit(context);
    authCubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.cubit(context, true);

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
              Navigator.pushNamed(
                context,
                AppRoutes.profile,
              );
            },
          ),
        ],
        title: Text(
          'Driver',
          style: AppText.b1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello Driver',
              style: AppText.h1b,
            )
          ],
        ),
      ),
    );
  }
}
