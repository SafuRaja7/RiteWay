import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riteway/models/routes.dart';

class RoutesDataProvider {
  static final routeCollection =
      FirebaseFirestore.instance.collection('routes');

  static Future<List<Routes>> fetch() async {
    try {
      final data = await routeCollection.get();

      final List<Routes> raw =
          data.docs.map((e) => Routes.fromMap(e.data())).toList();

      return raw;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
