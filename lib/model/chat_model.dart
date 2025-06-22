import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final List<Widget>? attachments;
  final bool showImage;
  final bool isTyping;
  final int typingProgress;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.attachments,
    required this.showImage,
    this.isTyping = false,
    this.typingProgress = 0,
  });

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? imageUrl,
    List<Widget>? attachments,
    bool? showImage,
    bool? isTyping,
    int? typingProgress,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      attachments: attachments ?? this.attachments,
      showImage: showImage ?? this.showImage,
      isTyping: isTyping ?? this.isTyping,
      typingProgress: typingProgress ?? this.typingProgress,
    );
  }
}