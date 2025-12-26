import 'dart:convert';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl = "https://5a35ab3faed0.ngrok-free.app";

  //get User reservations All 
  static Future<List<Reservation>> getUserReservations(String token) async {
  final url = Uri.parse(
    "$baseUrl/api/users/reservations/history",
  );

  final response = await http.get(
    url,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer 24|VoXfwZbnYNBBwNTEHGSCw9zvpYO4HbK1OSLqH6zKb074f813",
    },
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    final List reservationsJson = decoded['data']['data'];

    return reservationsJson
        .map((e) => Reservation.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to load reservation history");
  }
  }


  /////////////get house's Booked Days
  static Future<List<Reservation>> getHouseReservations(int houseId) async {
    final url = Uri.parse(
      "$baseUrl/api/users/reservations/availability/$houseId",
    );

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer 24|VoXfwZbnYNBBwNTEHGSCw9zvpYO4HbK1OSLqH6zKb074f813",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print("${decoded['data']}");
      final List data = decoded['data'];

      return data.map((e) => Reservation.fromJson(e)).toList();
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception("Failed to load reservations");
    }
  }

  static Future<Reservation> createReservation({
    required int houseId,
    required DateTime startDate,
    required DateTime endDate,
    required String token, // JWT
  }) async {
    final url = Uri.parse("$baseUrl/api/users/reservations/");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization":
            "Bearer 24|VoXfwZbnYNBBwNTEHGSCw9zvpYO4HbK1OSLqH6zKb074f813",
      },
      body: jsonEncode({
        "house_id": houseId,
        "start_date": startDate.toIso8601String().split('T').first,
        "end_date": endDate.toIso8601String().split('T').first,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      print(decoded['data']);
      return Reservation.fromJson(decoded['data']);
    } else if(response.statusCode == 409)//Conflict
    { 
      //To show the error from back
      final decoded = jsonDecode(response.body);
      final errorMessage = (decoded['error'] as List<dynamic>).join("\n");
      throw ApiException(errorMessage);
    }
    else {
      throw Exception("Failed to create reservation");
    }
  }
}
  class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
