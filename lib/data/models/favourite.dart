import 'package:flutter_project/data/models/House.dart';
class Favourite {
  int? favouriteId;
  int? userId;
  int? houseId;

  Favourite({
    required this.favouriteId,
    required this.userId,
    required this.houseId,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      favouriteId: json['id'], // id الخاص بالمفضلة
      userId: json['pivot']['user_id'],
      houseId: json['pivot']['house_id'],
    );
  }
}
