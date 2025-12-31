import 'package:flutter/material.dart';
import 'package:flutter_project/api/favoruite_service.dart';
import 'package:flutter_project/api/reservation_service.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:flutter_project/data/models/favourite.dart';

class UserModel extends ChangeNotifier {
  final String token= "3|IpPBTXrZr2zSntJH9xkf3huUMX3ugq67hyOjk6jM65be8b0a";
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
  List<Reservation> currentReservations = [];
  List<Reservation> previousReservations = [];
  List<Reservation> canceledReservations = [];
  List<Favourite> _favourites = [];
  bool _isLoadingReservations = false;
  bool get isLoadingReservations => _isLoadingReservations;

  List<Favourite> get favourites => _favourites;

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
    // required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      //token: user['data']['token'],
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

  ImageProvider get getProfileImg {
    if (image != null && image!.isNotEmpty) {
      // نحاول تحميل الصورة من السيرفر
      return NetworkImage(image!);
    } else {
      // إذا لم تكن موجودة أو فارغة، نرجع الصورة الافتراضية من assets
      return AssetImage('images/user.png');
    }
  }

  //i should see it
  Future<void> loadUserReservations() async {
    _isLoadingReservations = true;
    notifyListeners();

    try {
      final reservations = await ReservationService.getUserReservations(
        token,
      );

      // sorted by nearest to today
      reservations.sort(
        (a, b) => a.startDate!
            .difference(DateTime.now())
            .abs()
            .compareTo(b.startDate!.difference(DateTime.now()).abs()),
      );

      currentReservations.clear();
      previousReservations.clear();
      canceledReservations.clear();

      for (final r in reservations) {
        if (r.startDate == null || r.endDate == null) continue;

        switch (r.status) {
          case 'pending':
          case 'confirmed':
            currentReservations.add(r);
            break;

          case 'completed':
            previousReservations.add(r);
            break;

          case 'canceled':
            canceledReservations.add(r);
            break;
        }
      }
    } catch (e) {
      debugPrint("Failed to load reservations: $e");
    } finally {
      _isLoadingReservations = false;
      notifyListeners();
    }
  }

  Future<void> createReservation(
    DateTime start,
    DateTime end,
    int houseId,
  ) async {
    final reservations = await ReservationService.createReservation(
      token: token,
      startDate: start,
      endDate: end,
      houseId: houseId,
    );

    notifyListeners();
  }

  //to extract the unique days
  List<DateTime> getBookingDates(List<Reservation> source) {
    final dates = <DateTime>{};

    for (final r in source) {
      if (r.startDate == null || r.endDate == null) continue;

      DateTime day = DateTime(
        r.startDate!.year,
        r.startDate!.month,
        r.startDate!.day,
      );

      final end = DateTime(r.endDate!.year, r.endDate!.month, r.endDate!.day);

      while (!day.isAfter(end)) {
        dates.add(day);
        day = day.add(const Duration(days: 1));
      }
    }

    final result = dates.toList()..sort((a, b) => a.compareTo(b));

    return result;
  }

  List<Reservation> reservationsForRange(
    List<Reservation> source,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    return source.where((r) {
      if (r.startDate == null || r.endDate == null) return false;

      return r.startDate!.isBefore(rangeEnd) && r.endDate!.isAfter(rangeStart);
    }).toList();
  }

  List<House> housesForReservationRange(
    List<Reservation> source,
    DateTime rangeStart,
    DateTime rangeEnd,
    List<House> allHouses,
  ) {
    final rangeReservations = reservationsForRange(
      source,
      rangeStart,
      rangeEnd,
    );

    final houseIds = rangeReservations
        .map((r) => r.houseId)
        .whereType<int>()
        .toSet();

    return allHouses.where((h) => houseIds.contains(h.id)).toList();
  }

  // I should see
  Future<void> loadFavourites() async {
    _favourites = await FavoruiteService().getFavourites(
      token,
    );
    notifyListeners();
  }

  // I should see
  bool isFavourite(House house) {
    return _favourites.any((f) => f.houseId == house.id);
  }

  // I should see
  Future<void> addToFavourite(House house) async {
    await FavoruiteService().addToFavourite(
      token: token,
      houseId: house.id!,
    );
    await loadFavourites();
  }

  Future<void> removeFromFavourite(House house) async {
    final fav = _favourites.firstWhere((f) => f.houseId == house.id);

    await FavoruiteService().deleteFavourite(
      token: token,
      favouriteId: fav.favouriteId!,
    );
    await loadFavourites();
  }

  List<House> getFavouriteHouses(List<House> allHouses) {
    //the need of allHouses: _favApts has house id so i need the apt with this id
    final favIds = favourites.map((f) => f.houseId).toSet();
    return allHouses.where((h) => favIds.contains(h.id)).toList() ?? [];
  }

  bool get isComplete {
    return firstName != null &&
        lastName != null &&
        birthdate != null &&
        image != null &&
        idImage != null;
  }
}
