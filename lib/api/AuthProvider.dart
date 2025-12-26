import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/data/models/UserModel.dart';
import 'package:flutter_project/data/models/ProfileModel.dart';


class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _token;
  ProfileModel? _profile;

  ProfileModel? get profile => _profile;
  UserModel? get user => _user;
  String? get token => _token;

  /// تسجيل الدخول
  Future<String?> login(String phone) async {
    final url = Uri.parse('https://5a35ab3faed0.ngrok-free.app/api/auth/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'phone_number': phone});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("LOGIN RESPONSE = ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data["data"]["token"];
        final userJson = data["data"]["user"];
        _user = UserModel.fromJson(userJson);
        notifyListeners();

        return userJson["status"]; // ← هذا هو الصح
      } else {
        print("LOGIN FAILED: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('login error: $e');
      return null;
    }
  }
  Future<bool> verifyOtp(String code) async {
    if (_token == null) return false;

    final url = Uri.parse('https://5a35ab3faed0.ngrok-free.app/api/auth/virify-otp');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';

      request.fields['otp'] = code;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _user = UserModel.fromJson(data['data']['user']);
        notifyListeners();
        return true;
      } else {
        print("OTP verify failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print('verifyOtp error: $e');
      return false;
    }
  }

  Future<ProfileModel?> getProfile() async {
    if (_token == null) return null;

    final url = Uri.parse('https://5a35ab3faed0.ngrok-free.app/api/users/profiles/');
    final headers = {
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      print('PROFILE STATUS CODE: ${response.statusCode}');
      print('PROFILE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profileJson = data['data'];

        _profile = ProfileModel.fromJson(profileJson);
        notifyListeners();
        return _profile;
      }

      if (response.statusCode == 404) {
        _profile = null;
        notifyListeners();
        return null;
      }

      return null;

    } catch (e) {
      print('getProfile error: $e');
      return null;
    }
  }

  Future<bool> createProfile({
    required String firstName,
    required String lastName,
    required String birthdate,
    required String image,
    required String idImage,
  }) async {
    if (_token == null) return false;

    final url = Uri.parse('https://5a35ab3faed0.ngrok-free.app/api/users/profiles/');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $_token';

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['birthdate'] = birthdate;

      request.files.add(await http.MultipartFile.fromPath('image', image));
      request.files.add(await http.MultipartFile.fromPath('ID_image', idImage));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('createProfile failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('createProfile error: $e');
      return false;
    }
  }
}