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
