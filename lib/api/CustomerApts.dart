import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:http/http.dart' as http;

class Customerapts {
  static const String baseUrl = "http://10.151.86.10:8000";
  Future<List<House>> getAllApts(String token) async {
    List<House> allHouses = [];
    int currentPage = 1;
    int lastPage = 1;

    const int maxRetries = 10;
    const Duration retryDelay = Duration(seconds: 2);

    while (currentPage <= lastPage) {
      int attempt = 0;
      bool pageLoaded = false;

      while (!pageLoaded && attempt < maxRetries) {
        try {
          final url = Uri.parse('$baseUrl/api/users/houses?page=$currentPage');

          final response = await http.get(
            url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer 3|IpPBTXrZr2zSntJH9xkf3huUMX3ugq67hyOjk6jM65be8b0a',
            },
          );

          if (response.statusCode != 200) {
            throw Exception("Status ${response.statusCode}");
          }

          final js = jsonDecode(response.body);
          final data = js['data'];
          final List list = data['data'];

          final houses = list.map((e) => House.fromJson(e)).toList();

          allHouses.addAll(houses);

          currentPage = data['current_page'];
          lastPage = data['last_page'];

          currentPage++; // ننتقل فقط بعد نجاح الصفحة
          pageLoaded = true;

          print("✅ Page loaded successfully");
        } catch (e) {
          attempt++;
          print(
            "⚠️ Failed page $currentPage (attempt $attempt/$maxRetries): $e",
          );

          if (attempt < maxRetries) {
            print("⏳ Retrying in ${retryDelay.inSeconds}s...");
            await Future.delayed(retryDelay);
          }
        }
      }

      if (!pageLoaded) {
        print("❌ Giving up on page $currentPage");
        break; // توقف كامل
      }
    }

    print("🏁 Total houses loaded: ${allHouses.length}");
    return allHouses;
  }

  Future<List<House>> getAptsByPage(String token) async {
    final url = Uri.parse('$baseUrl/api/users/houses');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer 3|IpPBTXrZr2zSntJH9xkf3huUMX3ugq67hyOjk6jM65be8b0a',
      },
    );

    if (response.statusCode == 200) {
      print("hello world");

      final js = jsonDecode(response.body);

      // الشقق موجودة داخل:  data → data
      final List list = js['data']['data'];

      return list.map((item) => House.fromJson(item)).toList();
    } else {
      print("Error loading houses: ${response.statusCode}");
      return [];
    }
  }
}
