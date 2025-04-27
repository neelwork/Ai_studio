class GetPromptByIdModel {
  String? status;
  String? message;
  PromptDetails? promptDetails;
  List<Message>? messages;
  Pagination? pagination;

  GetPromptByIdModel({
    this.status,
    this.message,
    this.promptDetails,
    this.messages,
    this.pagination,
  });

  factory GetPromptByIdModel.fromJson(Map<String, dynamic> json) =>
      GetPromptByIdModel(
        status: json["status"],
        message: json["message"],
        promptDetails: json["prompt_details"] == null
            ? null
            : PromptDetails.fromJson(json["prompt_details"]),
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "prompt_details": promptDetails?.toJson(),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Message {
  String? messageId;
  String? userMessage;
  String? aiResponse;
  dynamic imageUrl;
  DateTime? responseTime;
  String? isComplete;
  DateTime? createdAt;

  Message({
    this.messageId,
    this.userMessage,
    this.aiResponse,
    this.imageUrl,
    this.responseTime,
    this.isComplete,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        messageId: json["message_id"],
        userMessage: json["user_message"],
        aiResponse: json["ai_response"],
        imageUrl: json["image_url"],
        responseTime: json["response_time"] == null
            ? null
            : DateTime.parse(json["response_time"]),
        isComplete: json["is_complete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "user_message": userMessage,
        "ai_response": aiResponse,
        "image_url": imageUrl,
        "response_time": responseTime?.toIso8601String(),
        "is_complete": isComplete,
        "created_at": createdAt?.toIso8601String(),
      };
}

class Pagination {
  int? limit;
  int? offset;
  int? totalMessages;

  Pagination({
    this.limit,
    this.offset,
    this.totalMessages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        offset: json["offset"],
        totalMessages: json["total_messages"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "offset": offset,
        "total_messages": totalMessages,
      };
}

class PromptDetails {
  String? promptId;
  String? title;
  DateTime? createdAt;

  PromptDetails({
    this.promptId,
    this.title,
    this.createdAt,
  });

  factory PromptDetails.fromJson(Map<String, dynamic> json) => PromptDetails(
        promptId: json["prompt_id"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "prompt_id": promptId,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
      };
}
