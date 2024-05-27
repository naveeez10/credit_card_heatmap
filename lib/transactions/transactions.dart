class Transaction {
  final String id;
  final DateTime dateTime;
  final int amount;
  final String description;

  Transaction({
    required this.id,
    required this.dateTime,
    required this.amount,
    required this.description,
  });
}
