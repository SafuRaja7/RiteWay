import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riteway/cubits/routes/repo.dart';
import 'package:riteway/models/routes.dart';

part 'routes_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  static RoutesCubit cubit(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<RoutesCubit>(context, listen: listen);
  RoutesCubit() : super(const RoutesLoading());

  final repo = RoutesRepo();

  Future<void> fetch() async {
    emit(const RoutesLoading());
    try {
      repo.fetch().listen(
        (event) {
          repo.fetch().listen((event) {
            final data =
                event.docs.map((e) => Routes.fromMap(e.data())).toList();

            emit(
              RoutesSuccess(data),
            );
          });
        },
      );
    } catch (e) {
      emit(
        RoutesFailed(
          e.toString(),
        ),
      );
    }
  }
}
