import 'package:ai_studio/model/get_chat_history_model.dart';
import 'package:ai_studio/services/post_services/post_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class GetAllChatHistory {}

class GetAllChatHistoryBloc
    extends Bloc<GetAllChatHistory, GetAllChatHistoryState> {
  GetAllChatHistoryBloc() : super(GetAllChatHistoryInitial()) {
    on<GetAllChatHistoryRequested>(_onGetAllChatHistoryRequested);
  }

  Future<void> _onGetAllChatHistoryRequested(GetAllChatHistoryRequested event,
      Emitter<GetAllChatHistoryState> emit) async {
    emit(GetAllChatHistoryLoading());
    final response = await PostServices().getAllChatHistory();
    if (response != null) {
      emit(GetAllChatHistorySuccess(response));
    } else {
      emit(
        GetAllChatHistoryFailure(
          response!.message.toString(),
        ),
      );
    }
  }
}

class GetAllChatHistoryRequested extends GetAllChatHistory {
  GetAllChatHistoryRequested();
}

abstract class GetAllChatHistoryState {
  const GetAllChatHistoryState();
}

class GetAllChatHistoryInitial extends GetAllChatHistoryState {}

class GetAllChatHistoryLoading extends GetAllChatHistoryState {}

class GetAllChatHistorySuccess extends GetAllChatHistoryState {
  final GetChatHistoryModel response;
  const GetAllChatHistorySuccess(this.response);
}

class GetAllChatHistoryFailure extends GetAllChatHistoryState {
  final String error;
  const GetAllChatHistoryFailure(this.error);
}
