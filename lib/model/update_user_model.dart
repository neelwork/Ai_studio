class UpdateUserModel {
  String? status;
  String? message;
  Data? data;

  UpdateUserModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? userName;
  String? email;
  String? password;
  DateTime? updatedAt;

  Data({
    this.userName,
    this.email,
    this.password,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userName: json["user_name"],
        email: json["email"],
        password: json["password"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "password": password,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
