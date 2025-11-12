import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = "https://app.visitsyria.fun/api/v1";

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": email, "password": password}),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }
}
