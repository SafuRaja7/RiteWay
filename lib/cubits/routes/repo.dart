import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riteway/cubits/routes/data_provider.dart';

class RoutesRepo {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetch() =>
      RoutesDataProvider.fetch();
}
