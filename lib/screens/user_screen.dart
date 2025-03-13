// ignore_for_file: use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:chit/providers/chit_provider.dart';
import 'package:chit/screens/add_user.dart';
import 'package:chit/screens/user_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends ConsumerState<UserListPage> {
  String searchQuery = '';
  late Map<int, Color> colorMap;

  @override
  void initState() {
    super.initState();
    colorMap = {};
  }

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
      appBar: AppBar(title: Text('Chit Customers')),
      body: Column(
        children: [
          if (chits.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
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
                chits.isEmpty
                    ? Center(child: Text("No users available."))
                    : filteredChits.isEmpty
                    ? Center(child: Text("No results found for your search."))
                    : ListView.builder(
                      itemCount: filteredChits.length,
                      itemBuilder: (context, index) {
                        final chit = filteredChits[index];

                        // Assign color once and store it
                        colorMap.putIfAbsent(
                          chit.id,
                          () => Color(
                            (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                          ).withOpacity(1.0),
                        );

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colorMap[chit.id]!,
                                child: Text(
                                  chit.id.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      chit.customerName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      "MMM yyyy",
                                    ).format(DateTime.parse(chit.createdAt)),
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                chit.customerMobileNumber,
                                style: TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TransactionListPage(
                                          chitId: chit.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 51, 178, 176),
        tooltip: "Add User",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          );
        },
        child: Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
      ),
    );
  }
}
