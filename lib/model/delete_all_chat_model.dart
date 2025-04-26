class DeleteAllChatModel {
  String? status;
  String? message;

  DeleteAllChatModel({
    this.status,
    this.message,
  });

  factory DeleteAllChatModel.fromJson(Map<String, dynamic> json) =>
      DeleteAllChatModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
