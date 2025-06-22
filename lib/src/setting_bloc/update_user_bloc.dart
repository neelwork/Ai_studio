import 'package:silver_ai/model/update_user_model.dart';
import 'package:silver_ai/services/post_services/post_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class UpdateUserEvent {}

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  UpdateUserBloc() : super(UpdateUserInitial()) {
    on<UpdateUserRequested>(_onUpdateUserRequested);
  }

  Future<void> _onUpdateUserRequested(
      UpdateUserRequested event, Emitter<UpdateUserState> emit) async {
    emit(UpdateUserLoading());
    final response = await PostServices()
        .updateUser(event.name, event.email, event.password);
    if (response != null) {
      emit(UpdateUserSuccess(response));
    } else {
      emit(
        UpdateUserFailure(
          response!.message.toString(),
        ),
      );
    }
  }
}

class UpdateUserRequested extends UpdateUserEvent {
  final String email;
  final String password;
  final String name;

  UpdateUserRequested(this.email, this.password, this.name);
}

abstract class UpdateUserState {
  const UpdateUserState();
}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  final UpdateUserModel response;
  const UpdateUserSuccess(this.response);
}

class UpdateUserFailure extends UpdateUserState {
  final String error;
  const UpdateUserFailure(this.error);
}
