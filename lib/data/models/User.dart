import 'package:flutter/material.dart';
import 'package:flutter_project/api/reservation_service.dart';
import 'package:flutter_project/data/models/reservation.dart';

class UserModel extends ChangeNotifier{
  final String token;
  final int id;
  final String phoneNumber;
  final String status;
  final bool isAdmin;
  final bool isProvider;
  final bool isCustomer;

  final String? firstName;
  final String? lastName;
  final String? birthdate;
  final String? image;
  final String? idImage;
  Map<DateTimeRange, List<Reservation>> currentReservations = {};
  Map<DateTimeRange, List<Reservation>> previousReservations = {};
  Map<DateTimeRange, List<Reservation>> canceledReservations = {};


  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.status,
    required this.isAdmin,
    required this.isProvider,
    required this.isCustomer,
    this.firstName,
    this.lastName,
    this.birthdate,
    this.image,
    this.idImage,
    required this.token
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      token :user['data']['token'],
      id: user['id'],
      phoneNumber: user['phone_number'],
      status: user['status'],
      isAdmin: user['is_admin'] == 1,
      isProvider: user['is_provider'] == 1,
      isCustomer: user['is_customer'] == 1,
      firstName: user['first_name'],
      lastName: user['last_name'],
      birthdate: user['birthdate'],
      image: user['image'],
      idImage: user['ID_image'],
    );
  }

  Future<void> loadReservations() async {
  final reservations =
      await ReservationService.getUserReservations(token);

  currentReservations.clear();
  previousReservations.clear();
  canceledReservations.clear();

  for (final r in reservations) {
    if (r.startDate == null || r.endDate == null) continue;

    final range = DateTimeRange(
      start: r.startDate!,
      end: r.endDate!,
    );

    switch (r.status) {
      case 'pending':
        currentReservations.putIfAbsent(range, () => []).add(r);//to add a val to the same key: date
        break;
      
      case 'confirmed':
        currentReservations.putIfAbsent(range, () => []).add(r);
        break;

      case 'completed':
        previousReservations.putIfAbsent(range, () => []).add(r);
        break;

      case 'canceled':
        canceledReservations.putIfAbsent(range, () => []).add(r);
        break;
    }
  }

  notifyListeners();
}
  
  Future<void> createReservation( DateTime start, DateTime end,int houseId) async{
    final reservations =
      await ReservationService.createReservation(token: token,startDate: start, endDate: end , houseId: houseId );
      
      notifyListeners();
  }
  bool get isComplete {
    return firstName != null &&
        lastName != null &&
        birthdate != null &&
        image != null &&
        idImage != null;
  }
 
}
