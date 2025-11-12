class UserDetailsModel {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String mobile;
  final String imageUrl;
  final bool isAdmin;
  final bool isActive;
  final bool isDeactivated;
  final String provider;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDetailsModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.imageUrl,
    required this.isAdmin,
    required this.isActive,
    required this.isDeactivated,
    required this.provider,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'] ?? json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      isActive: json['isActive'] ?? false,
      isDeactivated: json['isDeactivated'] ?? false,
      provider: json['provider'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "mobile": mobile,
      "imageUrl": imageUrl,
      "isAdmin": isAdmin,
      "isActive": isActive,
      "isDeactivated": isDeactivated,
      "provider": provider,
      "emailVerified": emailVerified,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  String get fullName => "$firstName $lastName".trim();
}
