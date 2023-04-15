import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/screens/routes/route_points_screen.dart';
import 'package:riteway/screens/routes/search_route_Screen.dart';

class RoutesNameScreen extends StatefulWidget {
  const RoutesNameScreen({super.key});

  @override
  State<RoutesNameScreen> createState() => _RoutesNameScreenState();
}

class _RoutesNameScreenState extends State<RoutesNameScreen> {
  @override
  void initState() {
    final routeCubit = BlocProvider.of<RoutesCubit>(context);
    super.initState();
    routeCubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SearchRouteScreen();
                  },
                ),
              ),
              child: Container(
                height: AppDimensions.normalize(22),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: Space.h,
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    Space.x!,
                    Text(
                      'Search Route...',
                      style: AppText.b2!.copyWith(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Space.y1!,
            BlocBuilder<RoutesCubit, RoutesState>(
              builder: (context, state) {
                if (state is RoutesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is RoutesSuccess) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Space.y1!,
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RoutePointsScreen(
                                        route: state.data![index],
                                      );
                                    },
                                  ),
                                ),
                                child: ListTile(
                                  leading: Text(
                                    "${index + 1}",
                                  ),
                                  title: Text(
                                    state.data![index].name!,
                                    style: AppText.b1!,
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text('Failed to load data'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
