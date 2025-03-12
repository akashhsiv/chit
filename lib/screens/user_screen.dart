// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:chit/providers/chit_provider.dart';
import 'package:chit/screens/add_user.dart';
import 'package:chit/screens/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends ConsumerState<UserListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final chits = ref.watch(chitProvider);
    final transactions = ref.watch(transactionProvider);

    final filteredChits =
        chits.where((chit) {
          final userTransactions =
              transactions.where((t) => t.chitId == chit.id).toList();
          final lastTransaction =
              userTransactions.isNotEmpty ? userTransactions.last : null;

          return chit.customerName.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              (lastTransaction != null &&
                  lastTransaction.amount.toString().contains(searchQuery));
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Chit Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hoverColor: const Color.fromARGB(137, 76, 0, 0),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child:
                filteredChits.isEmpty
                    ? Center(
                      child: Text(
                        'No customers exist, please add one.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredChits.length,
                      itemBuilder: (context, index) {
                        final chit = filteredChits[index];
                        final transactions = ref
                            .read(transactionProvider.notifier)
                            .getTransactionsByChitId(chit.id);
                        final lastTransaction =
                            transactions.isNotEmpty ? transactions.last : null;

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.primaries[Random().nextInt(
                                    Colors.primaries.length,
                                  )],
                              child: Text(
                                chit.id.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(chit.customerName),
                            subtitle:
                                lastTransaction != null
                                    ? Text(
                                      'Last Transaction:Rs ${lastTransaction.amount} on \n${DateFormat('dd/MM/yyyy').format(DateTime.parse(lastTransaction.transactionDate))}',
                                    )
                                    : Text('No transactions yet'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          TransactionListPage(chitId: chit.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add User",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          );
        },
        child: Icon(Icons.person_add_alt_1_outlined),
      ),
    );
  }
}
