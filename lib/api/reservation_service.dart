import 'dart:convert';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl = "http://10.151.86.10:8000";
  //get User reservations All
  static Future<List<Reservation>> getUserReservations(String token) async {
    final url = Uri.parse("$baseUrl/api/users/reservations/history");

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List reservationsJson = decoded['data']['data'];

      return reservationsJson.map((e) => Reservation.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load reservation history");
    }
  }

  /////////////get house's Booked Days
  static Future<List<Reservation>> getHouseReservations(
    int houseId,
    String token,
  ) async {
    final url = Uri.parse(
      "$baseUrl/api/users/reservations/availability/$houseId",
    );

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
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

  static Future<Reservation> updateReservation({
    required int reservationId,
    required DateTime startDate,
    required DateTime endDate,
    required String token, // JWT
  }) async {
    final url = Uri.parse("$baseUrl/api/users/reservations/$reservationId");

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "start_date": startDate.toIso8601String().split('T').first,
        "end_date": endDate.toIso8601String().split('T').first,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ السيرفر يعيد reservation كاملة
      return Reservation.fromJson(decoded['data']);
    }
    // 🔴 Conflict (تواريخ محجوزة)
    else if (response.statusCode == 409) {
      final decoded = jsonDecode(response.body);
      throw ApiException(parseError(decoded['error']));
    }
    // 🔴 No enoght money
    else if (response.statusCode == 400 || response.statusCode == 401) {
      final decoded = jsonDecode(response.body);
      throw ApiException(parseError(decoded['error']));
    }
    // 🔴 أي خطأ آخر
    else {
      throw Exception("Failed to update reservation (${response.statusCode})");
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
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
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
    } else if (response.statusCode == 409) //Conflict
    {
      //To show the error from back
      final decoded = jsonDecode(response.body);
      dynamic error = decoded['error'];
      if (error != null)
        throw ApiException(parseError(error));
      else {
        print(response.body);
        throw Exception(
          "Failed to create reservation +${response.statusCode} ",
        );
      }
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      final decoded = jsonDecode(response.body);
      dynamic error = decoded['error'];
      if (error != null)
        throw ApiException(parseError(error));
      else {
        print(response.body);
        throw Exception(
          "Failed to create reservation +${response.statusCode} ",
        );
      }
      // throw ApiException(parseError(decoded['error']));
    } else if (response.statusCode == 422) {
      final decoded = jsonDecode(response.body);
      dynamic error = decoded['error'];
      if (error != null)
        throw ApiException(parseError(error));
      else {
        print(response.body);
        throw Exception(
          "Failed to create reservation +${response.statusCode} ",
        );
      }
      // throw ApiException(parseError(decoded['error']));
    } else {
      print(response.body);
      throw Exception("Failed to create reservation +${response.statusCode} ");
    }
  }

  static Future<Reservation> cancelReservation({
    required int reservationId,
    required String token,
    String? cancellationReason,
  }) async {
    final url = Uri.parse("$baseUrl/api/users/reservations/$reservationId");

    final response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        if (cancellationReason != null)
          "cancellation_reason": cancellationReason,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return Reservation.fromJson(decoded['data']);
      print("Canellation has been successfuly");
    }
    // 🔴 لا يمكن الإلغاء
    else if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 409) {
      final decoded = jsonDecode(response.body);
      throw ApiException(parseError(decoded['error']));
    }
    // 🔴 أي خطأ آخر
    else {
      throw Exception("Failed to cancel reservation (${response.statusCode})");
    }
  }
}

//dealing what type is the error
String parseError(dynamic error) {
  if (error == null) return "Unknown error";

  if (error is String) {
    return error;
  }

  if (error is List) {
    return error.join('\n');
  }

  if (error is Map) {
    return error.values
        .map((e) => e is List ? e.join('\n') : e.toString())
        .join('\n');
  }

  return error.toString();
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
