// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:riteway/configs/configs.dart';
import 'package:riteway/models/routes.dart';

class SearchedRouteCard extends StatefulWidget {
  final Routes route;
  const SearchedRouteCard({
    Key? key,
    required this.route,
  }) : super(key: key);

  @override
  State<SearchedRouteCard> createState() => _SearchedRouteCardState();
}

class _SearchedRouteCardState extends State<SearchedRouteCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.route.name!,
        style: AppText.b1,
      ),
    );
  }
}
