import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:silver_ai/model/delete_all_chat_model.dart';
import 'package:silver_ai/model/get_chat_history_model.dart';
import 'package:silver_ai/model/get_profile_model.dart';
import 'package:silver_ai/model/get_prompt_by_id_model.dart';
import 'package:silver_ai/model/login_model.dart';
import 'package:silver_ai/model/signup_model.dart';
import 'package:silver_ai/model/update_user_model.dart';
import 'package:silver_ai/services/shared_preference/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:silver_ai/utils/api_endpoint.dart';

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

      debugPrint('Login Response Status: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');

      final data = json.decode(response.body);
      final result = LoginModel.fromJson(data);
      return result;
    } catch (e) {
      debugPrint("Login Exception: $e");
      return LoginModel(
        status: 'false',
        message: 'An error occurred during login',
      );
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

      debugPrint("Create User Status Code: ${response.statusCode}");
      debugPrint("Create User Response Body: ${response.body}");

      final data = json.decode(response.body);
      final result = SignupModel.fromJson(data);
      return result;
    } catch (e) {
      debugPrint("Create User Exception: $e");
      return SignupModel(
        status: 'false',
        message: 'An error occurred during signup',
      );
    }
  }

  Future<GetChatHistoryModel?> getAllChatHistory() async {
    final token = await StorageService.read(StorageService.authToken);

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.mithrex.in/api/prompt/getUserPrompts?page=1&pageSize=1000',
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
    final url = Uri.parse('https://api.mithrex.in/api/prompt/delete-all-chat');

    final token = await StorageService.read(StorageService.authToken);

    final response = await http.delete(
      url,
      headers: {
        'accept': 'application/json',
        'UserToken': '$token',
      },
    );

    print('deleteAllChats Status Code :: ${response.statusCode}');
    print('deleteAllChats Body :: ${response.body}');
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

  Future<GetPromptByIdModel?> getMessagesByPrompt({
    required String promptId,
    int limit = 10000,
    int offset = 0,
  }) async {
    final url = Uri.parse(

      'https://api.mithrex.in/api/message/getMessagesByPrompt?prompt_id=$promptId&limit=1000&offset=0',
    );

    final token = await StorageService.read(StorageService.authToken);

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'UserToken': '$token',
      },
    );

    log('get by id Response status: ${response.statusCode}');
    print("get by id Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = GetPromptByIdModel.fromJson(data);

      return result;
    }
    return null;
  }
}
