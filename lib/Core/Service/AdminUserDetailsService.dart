import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitsyriadashboard/Core/Modle/user_details_model.dart';
import 'package:visitsyriadashboard/Core/Storage/token_storage.dart';

class AdminUserDetailsService {
  static const String baseUrl = "https://app.visitsyria.fun/api/v1";

  /// 🟢 Get user by ID
  Future<UserDetailsModel> getUserById(String userId) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/users/$userId");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final userData = decoded["data"];
      return UserDetailsModel.fromJson(userData);
    } else {
      throw Exception(
        "Failed to fetch user. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }

  /// 🟡 Update user by ID (PUT)
  Future<UserDetailsModel> updateUser(String userId, Map<String, dynamic> body) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/users/$userId");
    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final userData = decoded["data"];
      return UserDetailsModel.fromJson(userData);
    } else {
      throw Exception(
        "Failed to update user. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }

  /// 🔴 Delete user by ID
  Future<bool> deleteUser(String userId) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/users/$userId");
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["status"] == "success";
    } else {
      throw Exception(
        "Failed to delete user. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }
}
