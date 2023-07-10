// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:riteway/app_routes.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/models/routes.dart';
import 'package:riteway/screens/routes/confirm_ride.dart';
import 'package:riteway/widgets/app_button.dart';

class RoutePointsScreen extends StatefulWidget {
  final bool isNav;
  final int index;
  final String id;

  const RoutePointsScreen({
    Key? key,
    required this.isNav,
    required this.index,
    required this.id,
  }) : super(key: key);

  @override
  State<RoutePointsScreen> createState() => _RoutePointsScreenState();
}

class _RoutePointsScreenState extends State<RoutePointsScreen> {
  @override
  Widget build(BuildContext context) {
    App.init(context);
    final routeCubit = RoutesCubit.cubit(context, true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await routeCubit.fetch();
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              BlocBuilder<RoutesCubit, RoutesState>(
                builder: (context, state) {
                  if (state is RoutesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is RoutesSuccess) {
                    Routes routee = state.data!.firstWhere(
                        (element) => element.createdAt == widget.id);
                    return Column(
                      children: [
                        ...List.generate(
                          routee.routePoints!.length,
                          (index) => Column(
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
                                      routee.routePoints![index].name!,
                                      style: AppText.b2,
                                      textAlign: TextAlign.center,
                                    ),
                                    Space.y!,
                                  ],
                                ),
                              ),
                              Space.y!,
                            ],
                          ),
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
                                return ConfirmRideScreen(
                                  drivers: routee.drivers!,
                                  routes: routee,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Text('No data found'),
                  );
                },
              ),
              Space.y2!,
            ],
          ),
        ),
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
              Navigator.pushNamed(context, AppRoutes.usersList);
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
