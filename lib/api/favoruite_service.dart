import 'dart:convert';
import 'package:flutter_project/data/models/favourite.dart';
import 'package:http/http.dart' as http;

class FavoruiteService {
  static const String baseUrl = "http://10.151.86.10:8000";

  //get Fav List
  Future<List<Favourite>> getFavourites(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/favorite'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List data = decoded['data'];

      return data.map<Favourite>((e) => Favourite.fromJson(e)).toList();
    } else {
      throw Exception('Failed to get favourites + ${response.statusCode}');
    }
  }

  //Add apt to fav
  Future<bool> addToFavourite({
    required String token,
    required int houseId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/favorite'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'house_id': houseId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // تمت الإضافة بنجاح
    } else {
      throw Exception('Failed to add favourite + ${response.statusCode}');
    }
  }

  //delete an apt
  Future<bool> deleteFavourite({
    required String token,
    required int favouriteId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/users/favorite/$favouriteId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true; // تم الحذف بنجاح
    } else {
      throw Exception('Failed to delete favourite + ${response.statusCode} ');
    }
  }
}
