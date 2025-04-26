import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  late IO.Socket socket;
  SendMessageEvent(this.message, this.socket);
}

class ToggleSidebarEvent extends ChatEvent {
  final bool isVisible;
  ToggleSidebarEvent(this.isVisible);
}

class ResetChatEvent extends ChatEvent {}
