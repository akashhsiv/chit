// ignore_for_file: use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'package:chit/modules/chit/providers/chit_provider.dart';
import 'package:chit/modules/chit/views/chit_list_view/chit_list.dart';
import 'package:chit/modules/transaction/providers/transaction_provider.dart';
import 'package:chit/modules/chit/views/add_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChitListPage extends ConsumerStatefulWidget {
  const ChitListPage({super.key});

  @override
  ChitListPageState createState() => ChitListPageState();
}

class ChitListPageState extends ConsumerState<ChitListPage> {
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
      appBar: AppBar(title: const Text('Chit Customers')),
      body: Column(
        children: [
          if (chits.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
              ),
            ),
          Expanded(
            child:
                chits.isEmpty
                    ? const Center(child: Text("No users available."))
                    : filteredChits.isEmpty
                    ? const Center(
                      child: Text("No results found for your search."),
                    )
                    : UserListView(filteredChits: filteredChits),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 51, 178, 176),
        tooltip: "Add User",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserPage()),
          ).then((_) => setState(() => searchQuery = ""));
        },
        child: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
      ),
    );
  }
}
