import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chit/modules/transaction/models/transaction.dart';

class TransactionListView extends StatelessWidget {
  final List<ChitTransaction> transactions;

  const TransactionListView({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(child: Text('No transactions found!'));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${transaction.amount}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy hh:mm a',
                    ).format(DateTime.parse(transaction.transactionDate)),
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                ],
              ),
              subtitle: Text(
                transaction.description,
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
