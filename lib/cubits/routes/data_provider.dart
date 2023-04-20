import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesDataProvider {
  static final routeCollection =
      FirebaseFirestore.instance.collection('routes');

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetch() {
    try {
      return routeCollection.snapshots().asBroadcastStream();
    } catch (e) {
      throw Exception("Internal Server Error");
    }
  }
}
