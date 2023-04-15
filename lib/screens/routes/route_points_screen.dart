// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';

import 'package:riteway/models/routes.dart';

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
    int count = 1;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: Space.all(1),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 5),
                blurRadius: 1,
                spreadRadius: 1.5,
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                "${count++}",
                style: AppText.l1b,
              ),
              Space.x1!,
              Text(widget.route.routePoints!.name!, style: AppText.b1!),
              Text(widget.route.routePoints!.fare!.toString(),
                  style: AppText.b1!),
              Text(widget.route.routePoints!.routeId!, style: AppText.b1!),
              Text(widget.route.routePoints!.stop!.toString(),
                  style: AppText.b1!),
            ],
          ),
          
        ),
      ),
    );
  }
}
