
import 'package:frontend/features/auth/data/models/appuser.dart';

class PropertyModel {
  final String? id;
  final String name;
  final String type;
  final String? description;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AppUserModel>? landlords; 
  String? apartmentId;

  PropertyModel({
    this.id,
    required this.name,
    required this.type,
    this.description,
    this.status = 'available',
    this.createdAt,
    this.updatedAt,
    this.landlords,
    this.apartmentId
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      status: json['status'] ?? 'available',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      landlords: (json['landlord'] as List).map((landlordJson) => AppUserModel.fromJson(landlordJson)).toList(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (landlords != null) 'landlord': landlords!.map((landlord) => landlord.toJson()).toList(),
    };
  }

}