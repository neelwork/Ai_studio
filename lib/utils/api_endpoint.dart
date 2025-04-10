class ApiEndpoints {
  static const String baseUrl = 'http://15.206.136.228/api';
  static const String login = '$baseUrl/users/userLogin';
  static const String getProfile = '$baseUrl/users/getUserByToken';
  static const String updateUser = '$baseUrl/users/updateUser';
  static const String createUser = '$baseUrl/users/createUser';
}
