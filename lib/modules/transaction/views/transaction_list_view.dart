import 'package:chit/modules/transaction/views/transaction_list/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:chit/modules/chit/models/chit.dart';
import 'package:chit/modules/chit/providers/chit_provider.dart';
import 'package:chit/modules/transaction/models/transaction.dart';
import 'package:chit/modules/transaction/providers/transaction_provider.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  final int chitId;

  const TransactionListPage({super.key, required this.chitId});

  @override
  TransactionListPageState createState() => TransactionListPageState();
}

class TransactionListPageState extends ConsumerState<TransactionListPage> {
  String filterType = 'newest';
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());

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

    List<ChitTransaction> monthlyTransactions =
        transactions.where((t) {
          DateTime transactionDate = DateTime.parse(t.transactionDate);
          return DateFormat('MMMM').format(transactionDate) == selectedMonth;
        }).toList();

    final totalAmount = monthlyTransactions.fold(0, (sum, t) => sum + t.amount);

    List<ChitTransaction> sortedTransactions = List.from(monthlyTransactions);
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              chit.customerMobileNumber,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? newValue) {
                if (newValue != null && newValue != selectedMonth) {
                  setState(() {
                    selectedMonth = newValue;
                  });
                }
              },
              items: List.generate(12, (index) {
                String month = DateFormat(
                  'MMMM',
                ).format(DateTime(2025, index + 1, 1));
                return DropdownMenuItem(value: month, child: Text(month));
              }),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filterType = value;
              });
            },
            itemBuilder:
                (context) => [
                  _buildMenuItem('newest', Icons.access_time, 'Newest First'),
                  _buildMenuItem('oldest', Icons.history, 'Oldest First'),
                  _buildMenuItem(
                    'highest',
                    Icons.trending_up,
                    'Highest Amount',
                  ),
                  _buildMenuItem(
                    'smallest',
                    Icons.trending_down,
                    'Smallest Amount',
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child:
                  totalAmount == 0
                      ? SizedBox.shrink()
                      : Text(
                        '₹$totalAmount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
            ),
          ),
          Expanded(
            child: TransactionListView(transactions: sortedTransactions),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
        children: [
         
          FloatingActionButton(
            heroTag: 2,
            onPressed: () async {
              GoRouter.of(context).pushNamed(
                'addTransaction',
                pathParameters: {'chitId': chit.id.toString()},
              );
            
              setState(() {
                selectedMonth = DateFormat('MMMM').format(DateTime.now());
              });
            },
            backgroundColor: const Color.fromARGB(149, 51, 178, 176),
            child: const Icon(Icons.add),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
