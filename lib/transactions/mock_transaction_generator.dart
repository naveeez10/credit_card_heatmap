import 'package:credit_card_heatmap/transactions/transactions.dart';
import 'package:mock_data/mock_data.dart';

List<Transaction> generateMockTransactions() {
  List<Transaction> transactions = [];
  DateTime now = DateTime.now();

  for (int days = 0; days < 365; days++) {
    DateTime date = now.subtract(Duration(days: days));
    int transactionCount = mockInteger(1, 20);

    for (int j = 0; j < transactionCount; j++) {
      transactions.add(
        Transaction(
          id: mockUUID(),
          dateTime: date.add(Duration(minutes: mockInteger(0, 1440))),
          amount: mockInteger(1, 1000),
          description: mockString(),
        ),
      );
    }
  }

  return transactions;
}
