class Reservation {
  int? id;
  int? userId;
  int? houseId;

  DateTime? startDate;
  DateTime? endDate;

  double? totalPrice;
  String? status;

  DateTime? createdAt;
  DateTime? updatedAt;

  Reservation();


  Reservation.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  userId = json['user_id'];
  houseId = json['house_id'];

  // ✅ availability endpoint
  if (json.containsKey('start') && json.containsKey('end')) {
    startDate = DateTime.parse(json['start']);
    endDate = DateTime.parse(json['end']);
  }

  // ✅ full reservation endpoint
  if (json.containsKey('start_date')) {
    startDate = json['start_date'] != null
        ? DateTime.parse(json['start_date'])
        : null;
  }

  if (json.containsKey('end_date')) {
    endDate = json['end_date'] != null
        ? DateTime.parse(json['end_date'])
        : null;
  }

  totalPrice = (json['total_price'] as num?)?.toDouble();
  status = json['status'];

  createdAt = json['created_at'] != null
      ? DateTime.parse(json['created_at'])
      : null;

  updatedAt = json['updated_at'] != null
      ? DateTime.parse(json['updated_at'])
      : null;
}



  
}
