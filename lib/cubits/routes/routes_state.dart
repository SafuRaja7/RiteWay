// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'routes_cubit.dart';

abstract class RoutesState extends Equatable {
  final List<Routes>? data;
  final String? message;
  const RoutesState({
    this.data,
    this.message,
  });

  @override
  List<Object> get props => [
        data!,
        message!,
      ];
}

class RoutesLoading extends RoutesState {
  const RoutesLoading() : super();
}

class RoutesSuccess extends RoutesState {
  RoutesSuccess(List<Routes>? data) : super(data: data!);
}

class RoutesFailed extends RoutesState {
  const RoutesFailed(String? message) : super(message: message);
}
