import 'package:riteway/cubits/routes/data_provider.dart';
import 'package:riteway/models/routes.dart';

class RoutesRepo {
  Future<List<Routes>> fetch() => RoutesDataProvider.fetch();
}
