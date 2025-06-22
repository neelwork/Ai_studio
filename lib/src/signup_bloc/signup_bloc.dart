import 'package:silver_ai/model/signup_model.dart';
import 'package:silver_ai/services/post_services/post_services.dart';
import 'package:silver_ai/services/shared_preference/shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SignUpEvent {}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    final response = await PostServices().createUser(
      event.email,
      event.password,
      event.userName,
    );
    if (response != null) {
      if (response.status == 'true') {
        await StorageService.write(
          StorageService.authToken,
          response.token.toString(),
        );
      }
      emit(SignUpSuccess(response));
    } else {
      emit(
        SignUpFailure(
          'Failed to create account. Please try again.',
        ),
      );
    }
  }
}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;
  final String userName;

  SignUpRequested(
      {required this.email, required this.password, required this.userName});
}

abstract class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignupModel response;
  const SignUpSuccess(this.response);
}

class SignUpFailure extends SignUpState {
  final String error;
  const SignUpFailure(this.error);
}
