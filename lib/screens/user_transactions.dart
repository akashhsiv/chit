import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chit/models/chit_model.dart';
import 'package:chit/providers/chit_provider.dart';
import 'package:chit/screens/add_transaction.dart';

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
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: const Color.fromARGB(255, 255, 254, 254),
                value: selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
                items: List.generate(12, (index) {
                  String month = DateFormat(
                    'MMMM',
                  ).format(DateTime(2025, index + 1, 1));
                  return DropdownMenuItem(
                    value: month,
                    child: Text(
                      month,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) {
              setState(() {
                filterType = value;
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'newest',
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Newest First',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'oldest',
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Oldest First',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'highest',
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Highest Amount',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'smallest',
                    child: Row(
                      children: [
                        Icon(Icons.trending_down, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Smallest Amount',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
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
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.black,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '₹$totalAmount spent in $selectedMonth',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
            ),
          ),
          Expanded(
            child:
                sortedTransactions.isEmpty
                    ? Center(
                      child: Text('No transactions found !'),
                    )
                    : ListView.builder(
                      itemCount: sortedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = sortedTransactions[index];
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.attach_money,
                                color: Colors.blue,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${transaction.amount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transaction.description,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy hh:mm a').format(
                                      DateTime.parse(
                                        transaction.transactionDate,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 29, 162, 160),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransaction(chitId: widget.chitId),
            ),
          );
        },
        child: Icon(Icons.add_circle_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

 }
}
