import 'package:bloc/bloc.dart';
import '../../model/chat_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc()
      : super(ChatState(
          messages: [
            // ChatMessage(
            //   text: "Hi Jay!\nHow can I help you?",
            //   isUser: false,
            //   timestamp: DateTime.now(),
            // ),
          ],
          isSidebarVisible: false,
          isFirstMessageSent: false,
        )) {
    on<SendMessageEvent>(_onSendMessage);
    on<ToggleSidebarEvent>(_onToggleSidebar);
    on<ResetChatEvent>(_onResetChat);
  }

  void _onResetChat(ResetChatEvent event, Emitter<ChatState> emit) {
    emit(ChatState(
      messages: [
        ChatMessage(
          text: "Hi Jay!\nHow can I help you?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
      isSidebarVisible: false,
      isFirstMessageSent: false,
    ));
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final userMessage = ChatMessage(
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    event.socket.emit('send_message', {"message": event.message});

    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isFirstMessageSent: true,
      isSidebarVisible: true,
    ));

    event.socket.on('send_message', (data) {
      final aiResponse = ChatMessage(
        text: data['message'],
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, aiResponse],
      ));
    });
  }

  // void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {

  //   if (event.message.trim().isEmpty) return;

  //   final userMessage = ChatMessage(
  //     text: event.message,
  //     isUser: true,
  //     timestamp: DateTime.now(),
  //   );

  //   // Add user message
  //   emit(state.copyWith(

  //     messages: [...state.messages, userMessage],
  //     isFirstMessageSent: true,
  //     isSidebarVisible: true,
  //   ));

  //   // Simulate AI response - use await to keep the event handler active
  //   await Future.delayed(const Duration(seconds: 1));

  //   // Check if we can still emit
  //   if (emit.isDone) return;

  //   final aiResponse = ChatMessage(
  //     text:
  //         "As a manager, here is a summary of the key points from the document:\n\n"
  //         "[Main Topic]: [Brief summary of the document's overall purpose]\n\n"
  //         "Key Sections:\n"
  //         "• [Section 1 Title]: [Summary of this section]\n"
  //         "• [Section 2 Title]: [Summary of this section]\n"
  //         "• [Section 3 Title]: [Summary of this section]\n\n"
  //         "Important Insights: [List any crucial takeaways]\n"
  //         "Actionable Points: [If applicable, include recommended actions]",
  //     isUser: false,
  //     timestamp: DateTime.now(),
  //   );

  //   emit(state.copyWith(
  //     messages: [...state.messages, aiResponse],
  //   ));
  // }

  void _onToggleSidebar(ToggleSidebarEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      isSidebarVisible: event.isVisible,
    ));
  }
}
