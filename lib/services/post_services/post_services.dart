import 'dart:convert';
import 'dart:developer';
import 'package:ai_studio/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:ai_studio/utils/api_endpoint.dart';

class PostServices {
  static Future<LoginModel?> login(String email, String password) async {
    const String url = ApiEndpoints.login;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final result = LoginModel.fromJson(data);

        return result;
      } else {
        return null;
      }
    } catch (e) {
      log("Exception: $e");
      return null;
    }
  }
}
