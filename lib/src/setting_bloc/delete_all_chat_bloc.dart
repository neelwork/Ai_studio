import 'package:silver_ai/model/delete_all_chat_model.dart';
import 'package:silver_ai/services/post_services/post_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class DeleteAllChatEvent {}

class DeleteAllChatBloc extends Bloc<DeleteAllChatEvent, DeleteAllChatState> {
  DeleteAllChatBloc() : super(DeleteAllChatInitial()) {
    on<DeleteAllChatRequested>(_onDeleteAllChatRequested);
  }

  Future<void> _onDeleteAllChatRequested(
      DeleteAllChatRequested event, Emitter<DeleteAllChatState> emit) async {
    print('Calling this... ');
    emit(DeleteAllChatLoading());
    final response = await PostServices().deleteAllChats();
    if (response != null) {
      emit(DeleteAllChatSuccess(response));
    } else {
      emit(
        DeleteAllChatFailure(
          response!.message.toString(),
        ),
      );
    }
  }
}

class DeleteAllChatRequested extends DeleteAllChatEvent {}

abstract class DeleteAllChatState {
  const DeleteAllChatState();
}

class DeleteAllChatInitial extends DeleteAllChatState {}

class DeleteAllChatLoading extends DeleteAllChatState {}

class DeleteAllChatSuccess extends DeleteAllChatState {
  final DeleteAllChatModel response;
  const DeleteAllChatSuccess(this.response);
}

class DeleteAllChatFailure extends DeleteAllChatState {
  final String error;
  const DeleteAllChatFailure(this.error);
}
