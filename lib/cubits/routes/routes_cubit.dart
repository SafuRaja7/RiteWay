import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:riteway/cubits/routes/repo.dart';
import 'package:riteway/models/routes.dart';

part 'routes_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  RoutesCubit() : super(const RoutesLoading());

  final repo = RoutesRepo();

  Future<void> fetch() async {
    emit(const RoutesLoading());
    try {
      final data = await repo.fetch();
      emit(
        RoutesSuccess(data),
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
