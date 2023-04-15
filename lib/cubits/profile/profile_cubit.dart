import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riteway/cubits/profile/data_provider.dart';
import 'package:riteway/cubits/profile/repo.dart';
import 'package:riteway/models/profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileLoading());

  final repo = ProfileRepository();

  Future<void> fetch() async {
    emit(const ProfileLoading());
    try {
      final data = await repo.fetch();

      emit(
        ProfileSuccess(
          data,
        ),
      );
    } catch (e) {
      emit(ProfileFailed(e.toString()));
    }
  }

  Future<void> add(XFile image) async {
    emit(const ProfileAddLoading());
    try {
      await ProfileDataProvider.add(image);

      emit(
        const ProfileAddSuccess(),
      );
    } catch (e) {
      emit(
        ProfileAddFailed(e.toString()),
      );
    }
  }
}
