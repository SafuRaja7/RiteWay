// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/models/routes.dart';
import 'package:riteway/screens/routes/confirm_ride.dart';
import 'package:riteway/widgets/app_button.dart';

class RoutePointsScreen extends StatefulWidget {
  final Routes route;
  final bool isNav;

  const RoutePointsScreen({
    Key? key,
    required this.route,
    required this.isNav,
  }) : super(key: key);

  @override
  State<RoutePointsScreen> createState() => _RoutePointsScreenState();
}

class _RoutePointsScreenState extends State<RoutePointsScreen> {
  bool refreshing = false;
  @override
  void initState() {
    final routeCubit = BlocProvider.of<RoutesCubit>(context);
    super.initState();
    routeCubit.fetch();
  }

  final ScrollController scrollController = ScrollController();

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
          onPressed: () async {
            await routeCubit.fetch();
            setState(() {});
          },
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await routeCubit.fetch();
            setState(() {
              routeCubit.fetch();
            });
          },
          child: SingleChildScrollView(
            child: !widget.isNav
                ? Column(
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
                            return Column(
                              children: [
                                ...List.generate(
                                  widget.route.routePoints!.length,
                                  (index) => Column(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        size: AppDimensions.normalize(10),
                                      ),
                                      Container(
                                        width: AppDimensions.normalize(120),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Space.y!,
                                            Text(
                                              widget.route.routePoints![index]
                                                  .name!,
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
                              ],
                            );
                          }
                          return const Center(
                            child: Text('No data found'),
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
                  )
                : Column(
                    children: [
                      ...List.generate(
                        widget.route.routePoints!.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Space.y1!,
                            ListTile(
                              leading: Text(
                                "${index + 1}",
                              ),
                              title: Text(
                                widget.route.routePoints![index].name!,
                                style: AppText.b1!,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
