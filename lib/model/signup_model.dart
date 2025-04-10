class SignupModel {
  String? status;
  String? message;
  Data? data;
  String? token;
  String? role;

  SignupModel({
    this.status,
    this.message,
    this.data,
    this.token,
    this.role,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        token: json["token"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "token": token,
        "role": role,
      };
}

class Data {
  String? password;
  String? userType;
  int? id;
  DateTime? updatedAt;
  String? email;
  String? userName;
  DateTime? createdAt;

  Data({
    this.password,
    this.userType,
    this.id,
    this.updatedAt,
    this.email,
    this.userName,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        password: json["password"],
        userType: json["user_type"],
        id: json["id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        email: json["email"],
        userName: json["user_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "user_type": userType,
        "id": id,
        "updated_at": updatedAt?.toIso8601String(),
        "email": email,
        "user_name": userName,
        "created_at": createdAt?.toIso8601String(),
      };
}
