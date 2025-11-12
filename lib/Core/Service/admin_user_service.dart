import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitsyriadashboard/Core/Modle/user_model.dart';
import '../Storage/token_storage.dart';


class AdminUserService {
  static const String baseUrl = "https://app.visitsyria.fun/api/v1";

  Future<List<UserModel>> getAllUsers() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/users");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final usersData = decoded["data"]["users"] as List<dynamic>;
      return usersData.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "Failed to fetch users. Code: ${response.statusCode} — ${response.body}");
    }
  }
}
