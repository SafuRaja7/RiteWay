import 'package:flutter/material.dart';
import 'package:riteway/app_routes.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/widgets/app_button.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Driver',
          style: AppText.b1!.cl(Colors.black),
        ),
      ),
      bottomSheet: const BottomSheet(),
      body: Column(
        children: const [
          Image(
            image: AssetImage(
              'assets/map.png',
            ),
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            thickness: 2,
            color: Colors.grey,
            indent: 165,
            endIndent: 165,
          ),
          Space.y!,
          AppButton(
            width: AppDimensions.normalize(100),
            child: Text(
              'View Students',
              style: AppText.l1b!.cl(Colors.white),
            ),
            onPressed: () {
              // Navigator.pushNamed(context, AppRoutes.usersList);
            },
          ),
          Space.y!,
          AppButton(
            width: AppDimensions.normalize(100),
            child: Text(
              'View Routes',
              style: AppText.l1b!.cl(Colors.white),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.routesNameScreen,
              );
            },
          ),
          Space.y1!,
        ],
      ),
    );
  }
}
