abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ToggleSidebarEvent extends ChatEvent {
  final bool isVisible;
  ToggleSidebarEvent(this.isVisible);
}
