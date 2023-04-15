import 'package:riteway/cubits/route_points/data_provider.dart';
import 'package:riteway/models/routes_points.dart';

class RoutePointsRepo {
  Future<List<RoutePoints>> fetch() => RoutePointsDataProvider.fetch();
}
