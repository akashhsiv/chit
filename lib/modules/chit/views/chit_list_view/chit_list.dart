// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chit/modules/transaction/views/transaction_list_view.dart';

class UserListView extends StatelessWidget {
  final List<dynamic> filteredChits;
  final Map<int, Color> colorMap = {};

  UserListView({super.key, required this.filteredChits});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorMap[chit.id]!,
                child: Text(
                  chit.id.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        chit.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        DateFormat(
                          "MMM yyyy",
                        ).format(DateTime.parse(chit.createdAt)),
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 7),
              subtitle: Text(
                chit.customerMobileNumber,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionListPage(chitId: chit.id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
