import 'package:chit/models/chit_model.dart';
import 'package:chit/providers/chit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransaction extends ConsumerStatefulWidget {
  final int chitId;

 const AddTransaction({super.key, required this.chitId});

  @override
  ConsumerState<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: "Add Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Add Description" , hintMaxLines: 3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Transaction",
        onPressed: () {
          final int? amount = int.tryParse(amountController.text);
          final String description = descriptionController.text.trim();

          if (amount != null && description.isNotEmpty) {
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
          }
        },
        child: const Icon(Icons.done_all_outlined),
      ),
    );
  }
}
