import 'dart:convert';
import 'dart:developer';
import 'package:ai_studio/model/delete_all_chat_model.dart';
import 'package:ai_studio/model/get_chat_history_model.dart';
import 'package:ai_studio/model/get_profile_model.dart';
import 'package:ai_studio/model/login_model.dart';
import 'package:ai_studio/model/signup_model.dart';
import 'package:ai_studio/model/update_user_model.dart';
import 'package:ai_studio/services/shared_preference/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:ai_studio/utils/api_endpoint.dart';

class PostServices {
  Future<LoginModel?> login(String email, String password) async {
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
        final data = json.decode(response.body);

        final result = LoginModel.fromJson(data);

        return result;
      }
    } catch (e) {
      log("Exception: $e");
      return null;
    }
  }

  Future<GetProfileModel?> getProfile() async {
    // Read the token from storage
    final token = await StorageService.read(StorageService.authToken);

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getProfile),
        headers: {
          'accept': 'application/json',
          'UserToken': token!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = GetProfileModel.fromJson(data);

        return result;
      }
    } catch (e) {
      log('Exception: $e');
    }

    return null;
  }

  Future<UpdateUserModel?> updateUser(
      String userName, String email, String password) async {
    final Map<String, dynamic> body = {
      'user_name': userName,
      'email': email,
      'password': password,
    };

    final token = await StorageService.read(StorageService.authToken);

    try {
      final response = await http.put(
        Uri.parse(ApiEndpoints.updateUser),
        headers: {
          'accept': 'application/json',
          'UserToken': token!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = UpdateUserModel.fromJson(data);

        return result;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<SignupModel?> createUser(
      String email, String password, String userName) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.createUser),
        body: jsonEncode({
          'user_name': userName,
          'email': email,
          'password': password,
        }),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      log("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final result = SignupModel.fromJson(data);

        return result;
      } else {
        final data = json.decode(response.body);

        final result = SignupModel.fromJson(data);

        return result;
      }
    } catch (e) {
      log("Exception: $e");
      return null;
    }
  }

  Future<GetChatHistoryModel?> getAllChatHistory() async {
    final token = await StorageService.read(StorageService.authToken);

    try {
      final response = await http.get(
        Uri.parse(
          'http://15.206.136.228/api/prompt/getUserPrompts?page=1&pageSize=1000',
        ),
        headers: {
          'accept': 'application/json',
          'UserToken': token!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final result = GetChatHistoryModel.fromJson(data);

        return result;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<DeleteAllChatModel?> deleteAllChats() async {
    final url = Uri.parse('http://15.206.136.228/api/prompt/delete-all-chat');

    final token = await StorageService.read(StorageService.authToken);

    final response = await http.delete(
      url,
      headers: {
        'accept': 'application/json',
        'UserToken': '$token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = DeleteAllChatModel.fromJson(data);

      return result;
    } else {
      print('Failed to delete chats. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return null;
  }
}
