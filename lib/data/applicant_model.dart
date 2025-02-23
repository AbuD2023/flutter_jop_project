class ApplicantModel {
  final String name;
  final int age;
  final String city;
  final String status;
  final String address;
  final String email;
  final String phone;
  final String imageUrl;

  ApplicantModel({
    required this.name,
    required this.age,
    required this.city,
    required this.status,
    required this.address,
    required this.email,
    required this.phone,
    this.imageUrl = 'assets/images/profile_default.png',
  });

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    return ApplicantModel(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      city: json['city'] ?? '',
      status: json['status'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['image_url'] ?? 'assets/images/profile_default.png',
    );
  }
} 