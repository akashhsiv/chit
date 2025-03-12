import 'package:chit/models/chit_model.dart';
import 'package:chit/providers/chit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  final int chitId;

  const TransactionListPage({super.key, required this.chitId});

  @override
  TransactionListPageState createState() => TransactionListPageState();
}

class TransactionListPageState extends ConsumerState<TransactionListPage> {
  String filterType = 'newest'; // Default filter type

  @override
  Widget build(BuildContext context) {
    final chits = ref.watch(chitProvider);
    final chit = chits.firstWhere(
      (c) => c.id == widget.chitId,
      orElse:
          () =>
              Chit(id: 0, customerName: "Unknown", customerMobileNumber: "N/A"),
    );

    final transactions =
        ref
            .watch(transactionProvider)
            .where((t) => t.chitId == widget.chitId)
            .toList();

    final totalAmount = transactions.fold(0, (sum, t) => sum + t.amount);

    List<ChitTransaction> sortedTransactions = List.from(transactions);

    // Sorting based on filter type
    switch (filterType) {
      case 'newest':
        sortedTransactions.sort(
          (a, b) => b.transactionDate.compareTo(a.transactionDate),
        );
        break;
      case 'oldest':
        sortedTransactions.sort(
          (a, b) => a.transactionDate.compareTo(b.transactionDate),
        );
        break;
      case 'highest':
        sortedTransactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'smallest':
        sortedTransactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chit.customerName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              chit.customerMobileNumber,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filterType = value;
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'newest', child: Text('Newest First')),
                  PopupMenuItem(value: 'oldest', child: Text('Oldest First')),
                  PopupMenuItem(
                    value: 'highest',
                    child: Text('Highest Amount'),
                  ),
                  PopupMenuItem(
                    value: 'smallest',
                    child: Text('Smallest Amount'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                'Total Amount: ₹$totalAmount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child:
                transactions.isEmpty
                    ? Center(child: Text('No transactions found!'))
                    : ListView.builder(
                      itemCount: sortedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = sortedTransactions[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              'Amount: ₹${transaction.amount}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description: ${transaction.description}'),
                                Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.transactionDate))}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context, ref);
        },
        child: Icon(Icons.playlist_add_outlined),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final int? amount = int.tryParse(amountController.text);
                final String description = descriptionController.text.trim();

                if (amount != null && amount > 0 && description.isNotEmpty) {
                  ref
                      .read(transactionProvider.notifier)
                      .addTransaction(
                        ChitTransaction(
                          chitId: widget.chitId,
                          amount: amount,
                          description: description,
                          transactionDate: DateTime.now().toIso8601String(),
                        ),
                      );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter valid details!')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
