import 'package:ai_studio/model/get_prompt_by_id_model.dart';
import 'package:ai_studio/services/post_services/post_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class GetPromptByIdEvent {}

class GetPromptByIdBloc extends Bloc<GetPromptByIdEvent, GetPromptByIdState> {
  GetPromptByIdBloc() : super(GetPromptByIdInitial()) {
    on<GetPromptByIdRequested>(_onGetPromptByIdRequested);
  }

  Future<void> _onGetPromptByIdRequested(
      GetPromptByIdRequested event, Emitter<GetPromptByIdState> emit) async {
    emit(GetPromptByIdLoading());
    final response = await PostServices().getMessagesByPrompt(
      promptId: event.promptId,
      limit: event.limit,
      offset: event.offset,
    );
    if (response != null) {
      emit(GetPromptByIdSuccess(response));
    } else {
      emit(
        GetPromptByIdFailure(
          response!.message.toString(),
        ),
      );
    }
  }
}

class GetPromptByIdRequested extends GetPromptByIdEvent {
  final String promptId;
  final int limit;
  final int offset;

  GetPromptByIdRequested(
      {required this.promptId, required this.limit, required this.offset});
}

abstract class GetPromptByIdState {
  const GetPromptByIdState();
}

class GetPromptByIdInitial extends GetPromptByIdState {}

class GetPromptByIdLoading extends GetPromptByIdState {}

class GetPromptByIdSuccess extends GetPromptByIdState {
  final GetPromptByIdModel response;
  const GetPromptByIdSuccess(this.response);
}

class GetPromptByIdFailure extends GetPromptByIdState {
  final String error;
  const GetPromptByIdFailure(this.error);
}
