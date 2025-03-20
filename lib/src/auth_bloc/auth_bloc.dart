import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      // Implement login logic here
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthSuccessState());
    });

    on<AuthSignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      // Implement signup logic here
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthSuccessState());
    });

    on<AuthGoogleLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      // Implement Google login logic here
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthSuccessState());
    });
  }
}
