import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:riteway/cubits/route_points/repo.dart';
import 'package:riteway/models/routes_points.dart';

part 'route_points_state.dart';

class RoutePointsCubit extends Cubit<RoutePointsState> {
  RoutePointsCubit() : super(const RoutePointsLoading());

  final repo = RoutePointsRepo();

  Future<void> fetch() async {
    emit(const RoutePointsLoading());
    try {
      final data = await repo.fetch();
      emit(
        RoutePointsSuccess(data),
      );
    } catch (e) {
      emit(
        RoutePointsFailed(
          e.toString(),
        ),
      );
    }
  }
}
