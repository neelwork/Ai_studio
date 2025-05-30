import 'package:ai_studio/model/login_model.dart';
import 'package:ai_studio/services/post_services/post_services.dart';
import 'package:ai_studio/services/shared_preference/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class LoginEvent {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final response = await PostServices().login(event.phone, event.password);
    if (response != null) {
      if (response.status == 'true') {
        await StorageService.write(
          StorageService.authToken,
          response.token.toString(),
        );
      }
      emit(LoginSuccess(response));
    } else {
      emit(
        LoginFailure(
          'Failed to login. Please try again.',
        ),
      );
    }
  }
}

class LoginRequested extends LoginEvent {
  final String phone;
  final String password;

  LoginRequested({required this.phone, required this.password});
}

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel response;
  const LoginSuccess(this.response);
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);
}
