import 'package:frontend/features/property/data/models/apartment.dart';

class RoomModel {
  final String id;
  final String? type;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ApartmentModel apartment;

  RoomModel({
    required this.id,
    this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.apartment,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      apartment: ApartmentModel.fromJson(json['apartment']), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'apartment': apartment.toJson(),
    };
  }
}