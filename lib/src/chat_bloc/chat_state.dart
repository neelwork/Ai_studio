import '../../model/chat_model.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isSidebarVisible;
  final bool isFirstMessageSent;

  ChatState({
    required this.messages,
    required this.isSidebarVisible,
    required this.isFirstMessageSent,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSidebarVisible,
    bool? isFirstMessageSent,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSidebarVisible: isSidebarVisible ?? this.isSidebarVisible,
      isFirstMessageSent: isFirstMessageSent ?? this.isFirstMessageSent,
    );
  }
}