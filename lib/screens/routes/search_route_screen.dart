import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/screens/routes/route_points_screen.dart';
import 'package:riteway/screens/routes/searched_route_card.dart';
import 'package:riteway/widgets/custom_text_field.dart';

class SearchRouteScreen extends StatefulWidget {
  const SearchRouteScreen({super.key});

  @override
  State<SearchRouteScreen> createState() => _SearchRouteScreenState();
}

class _SearchRouteScreenState extends State<SearchRouteScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List searchedRoutes = [];
  List routes = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final routeCubit = BlocProvider.of<RoutesCubit>(context);

        routes = List.from(routes)
          ..addAll(
            routeCubit.state.data!,
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: Space.all(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  BackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Search',
                    style: AppText.h2b,
                  )
                ],
              ),
              Space.y1!,
              FormBuilder(
                key: _formKey,
                child: CustomTextField(
                  name: 'filter',
                  hint: 'Search Route...',
                  textInputType: TextInputType.name,
                  autoFocus: true,
                  prefixIcon: const Icon(Icons.search),
                  onChangeFtn: (String? value) {
                    if (value!.isEmpty) {
                      setState(() {
                        searchedRoutes = [];
                      });
                    }

                    if (value.isNotEmpty) {
                      setState(() {
                        var lowerCaseQuery = value.toLowerCase();

                        searchedRoutes = routes.where((prop) {
                          final charityName = prop!.name!
                              .toLowerCase()
                              .contains(lowerCaseQuery);
                          return charityName;
                        }).toList(growable: false)
                          ..sort(
                            (a, b) => a!.name!
                                .toLowerCase()
                                .indexOf(lowerCaseQuery)
                                .compareTo(
                                  b!.name!
                                      .toLowerCase()
                                      .indexOf(lowerCaseQuery),
                                ),
                          );
                      });
                    }

                    return null;
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: searchedRoutes
                        .map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RoutePointsScreen(
                                        route: e,
                                        isNav: false,
                                      );
                                    },
                                  ),
                                ),
                                child: SearchedRouteCard(route: e),
                              ),
                              const Divider(),
                              Space.y!,
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Space.y!,
            ],
          ),
        ),
      ),
    );
  }
}
