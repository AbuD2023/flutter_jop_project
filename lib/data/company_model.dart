class CompanyModel {
  final String name;
  final String location;
  final String logoPath;
  final String sector;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String establishmentDate;
  final int applicantsCount;
  final int acceptedCount;
  final int messagesCount;

  CompanyModel({
    required this.name,
    required this.location,
    required this.logoPath,
    required this.sector,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.establishmentDate,
    this.applicantsCount = 0,
    this.acceptedCount = 0,
    this.messagesCount = 0,
  });
}

class ApplicantModel {
  final String name;
  final String avatarPath;
  final int status; // 0: pending, 1: accepted, 2: rejected
  final String email;
  final String phone;
  final int age;
  final String city;
  final String district;
  final String address;

  ApplicantModel({
    required this.name,
    required this.avatarPath,
    required this.status,
    required this.email,
    required this.phone,
    required this.age,
    required this.city,
    required this.district,
    required this.address,
  });
} 