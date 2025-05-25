class AppUserModel {
  final String? id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? address;

  AppUserModel({
    this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth?.toIso8601String(), 
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
    };
  }
}