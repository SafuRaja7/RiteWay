// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:riteway/configs/app.dart';
import 'package:riteway/configs/configs.dart';
import 'package:riteway/cubits/routes/routes_cubit.dart';
import 'package:riteway/models/suggestion.dart';
import 'package:riteway/screens/routes/route_points_screen.dart';
import 'package:riteway/screens/routes/search_route_Screen.dart';
import 'package:riteway/widgets/app_button.dart';
import 'package:riteway/widgets/multiline_text_field.dart';

class RoutesNameScreen extends StatefulWidget {
  final bool? isNav;
  const RoutesNameScreen({
    Key? key,
    this.isNav = false,
  }) : super(key: key);

  @override
  State<RoutesNameScreen> createState() => _RoutesNameScreenState();
}

class _RoutesNameScreenState extends State<RoutesNameScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    final routeCubit = BlocProvider.of<RoutesCubit>(context);
    super.initState();
    routeCubit.fetch();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final routeCubit = BlocProvider.of<RoutesCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Routes',
          style: AppText.b1!.cl(Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: !widget.isNav!
            ? BackButton(
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          InkWell(
            onTap: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    padding: Space.all(0.75),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Any Suggestions?',
                                style: AppText.b1b,
                              ),
                              IconButton(
                                splashRadius: AppDimensions.normalize(8),
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Give your valuable suggestions and we are for sure going to consider it!',
                            style: AppText.l2,
                          ),
                          Space.y1!,
                          Text(
                            'Anything extra you want to add. Please feel free',
                            style: AppText.l2b,
                          ),
                          Space.y!,
                          FormBuilder(
                            key: _formKey,
                            child: const CustomMultiLineTextField(
                              name: 'suggestion',
                              hint: 'Describe your experience (opt)',
                              textInputAction: TextInputAction.newline,
                            ),
                          ),
                          Space.y!,
                          AppButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              if (_formKey.currentState!.saveAndValidate()) {
                                final form = _formKey.currentState!;
                                final data = form.value;

                                Suggestion newSuggestion = Suggestion(
                                  description: data['suggestion'],
                                );
                                saveSuggestion(newSuggestion);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Suggestion Submitted'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            child: const Icon(
              Icons.reviews_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        RefreshIndicator(
                          onRefresh: () => routeCubit.fetch(),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: state.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Space.y1!,
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return RoutePointsScreen(
                                              isNav: widget.isNav!,
                                              id: state.data![index].createdAt!
                                                  .toString(),
                                              index: index,
                                            );
                                          },
                                        ),
                                      );
                                    },
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
      ),
    );
  }
}
