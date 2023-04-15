// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'route_points_cubit.dart';

abstract class RoutePointsState extends Equatable {
  final List<RoutePoints>? data;
  final String? message;
  const RoutePointsState({
    this.data,
    this.message,
  });

  @override
  List<Object> get props => [data!, message!];
}

class RoutePointsLoading extends RoutePointsState {
  const RoutePointsLoading() : super();
}

class RoutePointsSuccess extends RoutePointsState {
  const RoutePointsSuccess(List<RoutePoints>? data) : super(data: data);
}

class RoutePointsFailed extends RoutePointsState {
  const RoutePointsFailed(String? message) : super(message: message);
}
