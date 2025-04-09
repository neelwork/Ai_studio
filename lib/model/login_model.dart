class LoginModel {
  String? status;
  String? message;
  String? token;
  String? role;

  LoginModel({
    this.status,
    this.message,
    this.token,
    this.role,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "role": role,
      };
}
