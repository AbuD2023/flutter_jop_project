class LoginResponseModel {
  final String state;
  final String token;
  final String userType;
  final int id;

  LoginResponseModel({
    required this.state,
    required this.token,
    required this.userType,
    required this.id,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      state: json['state'] ?? '',
      token: json['token'] ?? '',
      userType: json['userType'] ?? '',
      id: json['id'] ?? 0,
    );
  }
} 