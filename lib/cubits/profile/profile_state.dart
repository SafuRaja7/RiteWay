// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  final ProfileModel? data;
  final String? message;

  const ProfileState({
    this.data,
    this.message,
  });

  @override
  List<Object> get props => [
        data!,
        message!,
      ];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading() : super();
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess(ProfileModel? data) : super(data: data);
}

class ProfileFailed extends ProfileState {
  const ProfileFailed(String? message) : super(message: message);
}

class ProfileAddLoading extends ProfileState {
  const ProfileAddLoading() : super();
}

class ProfileAddSuccess extends ProfileState {
  const ProfileAddSuccess() : super();
}

class ProfileAddFailed extends ProfileState {
  const ProfileAddFailed(String? message) : super(message: message);
}
