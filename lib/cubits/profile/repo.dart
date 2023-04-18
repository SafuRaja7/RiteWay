import 'package:riteway/cubits/profile/data_provider.dart';
import 'package:riteway/models/profile.dart';

class ProfileRepository {
  Future<ProfileModel> fetch() => ProfileDataProvider.fetch();

  
}
