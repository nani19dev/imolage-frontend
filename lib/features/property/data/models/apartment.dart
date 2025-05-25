
class ApartmentModel {
  final String? id;
  final String name;
  final String type;
  final String? description;
  final String status;
  //final int? size_sqft; 
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String propertyId;

  ApartmentModel({
    this.id,
    required this.name,
    required this.type,
    this.description,
    this.status = 'available',
    //this.size_sqft, 
    this.createdAt,
    this.updatedAt,
    required this.propertyId,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      status: json['status'] ?? 'available',
      //size_sqft: json['size_sqft'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      propertyId: json['property']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      'status': status,
      //if (size_sqft != null) 'size_sqft': size_sqft, 
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      'property': propertyId,
    };
  }
}