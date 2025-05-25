
class TransactionModel {
  final String? id;
  final String? senderId;
  //final String? receiverId;
  final String type; 
  final double amount;
  final String? description;
  final String? status;
  final String paymentMethod;
  final DateTime date;
  String? contractId;

  TransactionModel({
    this.id,
    this.senderId,
    //this.receiverId,
    required this.type,
    required this.amount,
    this.description,
    this.status = 'pending',
    required this.paymentMethod,
    required this.date,
    this.contractId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      senderId: json['sender_id'],
      //receiverId: json['receiver_id'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      description: json['description'],
      paymentMethod: json['payment_method'],
      status: json['status'] ?? 'pending',
      date: DateTime.parse(json['date']),
      contractId: json['contract'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      //if (receiverId != null) 'receiver_id': receiverId,
      'type': type,
      'amount': amount,
      if (description != null) 'description': description,
      'payment_method': paymentMethod,
      if (status != null) 'status': status,
      'date': date.toIso8601String(),
      'contract': contractId, 
    };
  }
}