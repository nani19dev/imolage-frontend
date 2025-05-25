class ContractModel {
  final String? id;
  final DateTime startDate;
  final DateTime endDate;
  final double rent;
  final double? currentRentPaid;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  //final String? propertyId;
  final String? apartmentId;
  //final List<String>? landlordIds;
  //final List<String> tenantIds;

  ContractModel({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.rent,
    this.currentRentPaid = 0,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    //this.propertyId,
    this.apartmentId,
    //this.landlordIds,
    //required this.tenantIds,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      rent: double.parse(json['rent']),
      currentRentPaid: double.parse(json['current_rent_payed']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      //propertyId: json['property'],
      apartmentId: json['apartment'],
      //landlordIds: json['landlord'].map<String>((user) => user['id']).toList() ?? [],
      //tenantIds: json['tenant'].map<String>((user) => user['id']).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'rent': rent,
      if (currentRentPaid != null) 'current_rent_payed': currentRentPaid,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      //if (propertyId != null) 'property': propertyId,
      if (apartmentId != null) 'apartment': apartmentId,
      //if (landlordIds != null) 'landlord': landlordIds!.map((id) => {'id': id}).toList(),
      //'tenant': tenantIds.map((id) => {'id': id}).toList(),
    };
  }

  static findByApartmentId(List<ContractModel> list, String apartmentId) {
    try {
      return list.firstWhere((ContractModel contract) => contract.apartmentId == apartmentId || contract.apartmentId == apartmentId);
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        return null; 
      }
    }
  }

  static findActive(List<ContractModel> list) {
    try {
      return list.firstWhere((ContractModel contract) => contract.status == 'active');
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        return null; 
      }
    }
  }
  
}