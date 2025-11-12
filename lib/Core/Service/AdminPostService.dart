import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visitsyriadashboard/Core/Modle/post_model.dart';
import 'package:visitsyriadashboard/Core/Storage/token_storage.dart';

class AdminPostService {
  static const String baseUrl = "https://app.visitsyria.fun/api/v1";

  /// 🟢 Get all posts
  Future<List<PostModel>> getAllPosts() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/posts");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final postsData = decoded["data"]["posts"] as List<dynamic>;
      return postsData.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "Failed to fetch posts. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }

  /// 🟡 Get all pending posts
  Future<List<PostModel>> getPendingPosts() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/posts/pending");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final postsData = decoded["data"]["posts"] as List<dynamic>;
      return postsData.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "Failed to fetch pending posts. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }

  /// ✅ Approve a post by ID
  Future<PostModel> approvePost(String postId) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/posts/$postId/approve");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final postData = decoded["data"];
      return PostModel.fromJson(postData);
    } else {
      throw Exception(
        "Failed to approve post. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }

  /// 🔴 Reject a post by ID (with reason)
  Future<PostModel> rejectPost(String postId, String reason) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("No access token found. Please login.");

    final url = Uri.parse("$baseUrl/admin/posts/$postId/reject");
    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"rejectionReason": reason}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final postData = decoded["data"];
      return PostModel.fromJson(postData);
    } else {
      throw Exception(
        "Failed to reject post. Code: ${response.statusCode} — ${response.body}",
      );
    }
  }
}
