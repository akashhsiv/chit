import 'dart:convert';

class Chit {
  final int id;
  final String customerName;
  final String customerMobileNumber;
  final String createdAt;

  Chit({
    required this.id,
    required this.customerName,
    required this.customerMobileNumber,
  }) : createdAt = DateTime.now().toIso8601String();
}

class ChitTransaction {
  final int chitId;
  final int amount;
  final String description;
  final String transactionDate;

  ChitTransaction({
    required this.chitId,
    required this.amount,
    required this.description,
    required this.transactionDate,
  });
  
  factory ChitTransaction.fromJson(String json) {
    final data = jsonDecode(json);
    return ChitTransaction(
      chitId: data['chitId'],
      amount: data['amount'],
      description: data['description'],
      transactionDate: data['transactionDate'],
    );
  }

  String toJson() {
    return jsonEncode({
      'chitId': chitId,
      'amount': amount,
      'description': description,
      'transactionDate': transactionDate,
    });
  }
}
