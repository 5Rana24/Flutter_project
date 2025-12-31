import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.151.86.10:8000';

  static Future<Map<String, dynamic>> login(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'phone_number': phone}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String otp,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/virify-otp'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'otp': otp},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/profiles/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createProfile({
    required String token,
    required int userId,
    required String firstName,
    required String lastName,
    required String birthdate,
    required String imagePath,
    required String idImagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/users/profiles/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['id'] = userId.toString();
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['birthdate'] = birthdate;

    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    request.files.add(
      await http.MultipartFile.fromPath('ID_image', idImagePath),
    );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    return jsonDecode(resBody);
  }

  //////////////////////////////////////what i changed
  static Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse('$baseUrl/api/logout');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'status': 'error',
          'message': data['message'] ?? 'فشل تسجيل الخروج',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'خطأ في الاتصال بالسيرفر'};
    }
  }
}
