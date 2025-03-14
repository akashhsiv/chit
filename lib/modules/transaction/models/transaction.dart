import 'dart:convert';

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
