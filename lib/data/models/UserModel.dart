class UserModel {
  final int id;
  final int userId;
  final String phoneNumber;
  final String status;
  final bool isAdmin;
  final bool isProvider;
  final bool isCustomer;

 /* final String? firstName;
  final String? lastName;
  final String? birthdate;
  final String? image;
  final String? idImage;
*/
  UserModel({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.status,
    required this.isAdmin,
    required this.isProvider,
    required this.isCustomer,
   /* this.firstName,
    this.lastName,
    this.birthdate,
    this.image,
    this.idImage,*/
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('user') ? json['user'] : json;

    return UserModel(
      id: data['id'],
      userId: json['user_id'],
      phoneNumber: data['phone_number'],
      status: data['status'],
      isAdmin: data['is_admin'] == 1,
      isProvider: data['is_provider'] == 1,
      isCustomer: data['is_customer'] == 1,
    /*  firstName: data['first_name'],
      lastName: data['last_name'],
      birthdate: data['birthdate'],
      image: data['image'],
      idImage: data['ID_image'],*/
    );
  }

 /* bool get isComplete {
    return firstName?.isNotEmpty == true &&
        lastName?.isNotEmpty == true &&
        birthdate?.isNotEmpty == true &&
        image?.isNotEmpty == true &&
        idImage?.isNotEmpty == true;
  }*/
}