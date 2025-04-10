import 'package:ai_studio/model/get_profile_model.dart';
import 'package:ai_studio/services/post_services/post_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class ProfileEvent {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
      ProfileRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final response = await PostServices().getProfile();
    if (response != null) {
      emit(ProfileSuccess(response));
    } else {
      emit(
        ProfileFailure(
          response!.message.toString(),
        ),
      );
    }
  }
}

class ProfileRequested extends ProfileEvent {
  ProfileRequested();
}

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final GetProfileModel response;
  const ProfileSuccess(this.response);
}

class ProfileFailure extends ProfileState {
  final String error;
  const ProfileFailure(this.error);
}
