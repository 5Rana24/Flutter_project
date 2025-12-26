import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_project/api/reservation_service.dart';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:http/http.dart' as http;

class House {
  int? id;
  int? userId;
  int? cityId;
  int? zoneId;
  String? description;
  String? imagePath;
  String? status;
  double? latitude;
  double? longitude;
  String? locationDetails;
  double? price;
  int? area;
  int? roomsCount;
  int? houseFloor;
  String? category;
  String? houseStatus;
  String? houseFurniture;
  String? houseDestinations;
  String? ownershipType;
  String? rentalDuration;
  bool? hasParking;
  bool? hasBalcony;
  bool? hasElevator;
  String? createdAt;
  String? updatedAt;
  String? cityName;
  String? zoneName;
  List<Reservation> reservations = [];
  String get fullImageUrl {
    if (imagePath == null || imagePath!.isEmpty) {
      return "";
    }

    if (imagePath!.startsWith("http")) {
      return imagePath!;
    }

    // تحويل المسار من storage/app/public → storage
    final fixedPath = imagePath!.replaceFirst(
      "storage/app/public/",
      "storage/",
    );

    return "https://5f86981a5274.ngrok-free.app/$fixedPath";
  }

  //   String get fullImageUrl {
  //   if (imagePath == null || imagePath!.isEmpty) {
  //     return ""; // لا يوجد صورة
  //   }

  //   // إذا الرابط كامل (من النت)
  //   if (imagePath!.startsWith("http://") || imagePath!.startsWith("https://")) {
  //     return imagePath!;
  //   }

  //   // إذا مجرد مسار من السيرفر
  //   return "https://5f86981a5274.ngrok-free.app$imagePath";
  // }
  House() {
    cityName = "rana";
    zoneName = "syyi";
    price = 1200;
    description = "nkjnenjckmmkl";
  }

  //////////////////////////////////Book an Apt
  Future<Reservation> reserve({
    required DateTime startDate,
    required DateTime endDate,
    required String token,
  }) async {
    final reservation = await ReservationService.createReservation(
      houseId: id!,
      startDate: startDate,
      endDate: endDate,
      token: token,
    );

    reservations.add(reservation);
    return reservation;
  }

  House.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cityId = json['city_id'];
    zoneId = json['zone_id'];
    cityName = json['city']?['ar_name'];
    zoneName = json['zone']?['ar_name'];

    description = json['description'];
    imagePath = json['image_path'];
    status = json['status'];

    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();

    locationDetails = json['location_details'];
    price = (json['price'] as num?)?.toDouble();

    area = json['area'];
    roomsCount = json['rooms_count'];
    houseFloor = json['house_floor'];

    category = json['category'];
    houseStatus = json['house_status'];
    houseFurniture = json['house_furniture'];
    houseDestinations = json['house_destinations'];
    ownershipType = json['ownership_type'];
    rentalDuration = json['rental_duration'];

    // تحويل 0/1 إلى bool
    hasParking = json['has_parking'] == 1;
    hasBalcony = json['has_balcony'] == 1;
    hasElevator = json['has_elevator'] == 1;

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  List<DateTime> getBookedDays() {
  final List<DateTime> days = [];

  for (final reservation in reservations) {
    if (reservation.startDate == null || reservation.endDate == null) continue;

    DateTime current = reservation.startDate!;
    final end = reservation.endDate!;

    while (!current.isAfter(end)) {
      days.add(DateTime(current.year, current.month, current.day));
      current = current.add(const Duration(days: 1));
    }
  }

  return days;
}
  Future<void> loadReservations() async {
    if (id == null) return;
    print(" 👌👌 Loading Reservations of the house");
    reservations = await ReservationService.getHouseReservations(id!);
  }
}
