class ProfileModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String? image;
  final String? idImage;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    this.image,
    this.idImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthdate: json['birthdate'],
      image: json['image'],
      idImage: json['ID_image'],
    );
  }
}