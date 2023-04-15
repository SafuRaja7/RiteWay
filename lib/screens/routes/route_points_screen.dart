// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';

import 'package:riteway/models/routes.dart';
import 'package:riteway/screens/routes/confirm_ride.dart';
import 'package:riteway/widgets/app_button.dart';

class RoutePointsScreen extends StatefulWidget {
  final Routes route;

  const RoutePointsScreen({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  State<RoutePointsScreen> createState() => _RoutePointsScreenState();
}

class _RoutePointsScreenState extends State<RoutePointsScreen> {
  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Space.y1!,
              Center(
                child: Text(
                  'Processing your request',
                  style: AppText.h3,
                ),
              ),
              Space.y2!,
              Icon(
                Icons.location_on_sharp,
                size: AppDimensions.normalize(30),
              ),
              Space.y2!,
              Lottie.asset(
                'assets/loading.json',
                height: AppDimensions.normalize(50),
              ),
              Space.y2!,
              Container(
                width: AppDimensions.normalize(120),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Colors.black54,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Space.y!,
                    Text(
                      'Capital University of Science\nand technology',
                      style: AppText.b2,
                      textAlign: TextAlign.center,
                    ),
                    Space.y!,
                  ],
                ),
              ),
              Space.y!,
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.route.routePoints!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: AppDimensions.normalize(10),
                      ),
                      Container(
                        width: AppDimensions.normalize(120),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.black54,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Space.y!,
                            Text(
                              widget.route.routePoints![index].name!,
                              style: AppText.b2,
                              textAlign: TextAlign.center,
                            ),
                            Space.y!,
                          ],
                        ),
                      ),
                      Space.y!,
                    ],
                  );
                },
              ),
              Space.y1!,
              AppButton(
                width: AppDimensions.normalize(80),
                child: Text(
                  'Confirm Ride',
                  style: AppText.l1!.cl(Colors.white),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ConfirmRideScreen();
                    },
                  ),
                ),
              ),
              Space.y!,
              AppButton(
                width: AppDimensions.normalize(80),
                child: Text(
                  'Cancel',
                  style: AppText.l1!.cl(Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
