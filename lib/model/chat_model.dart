import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final List<Widget>? attachments;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.attachments,
  });
}