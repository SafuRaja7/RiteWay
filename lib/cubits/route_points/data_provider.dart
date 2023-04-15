import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riteway/models/routes_points.dart';

class RoutePointsDataProvider {
  static final routeCollection =
      FirebaseFirestore.instance.collection('routePoints');

  static Future<List<RoutePoints>> fetch() async {
    try {
      final data = await routeCollection.get();

      final List<RoutePoints> raw =
          data.docs.map((e) => RoutePoints.fromMap(e.data())).toList();

      return raw;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
