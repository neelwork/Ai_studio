class GetProfileModel {
  String? status;
  String? message;
  User? user;

  GetProfileModel({
    this.status,
    this.message,
    this.user,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) =>
      GetProfileModel(
        status: json["status"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  int? userId;
  String? userName;
  String? email;
  String? password;

  User({
    this.userId,
    this.userName,
    this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "email": email,
        "password": password,
      };
}
