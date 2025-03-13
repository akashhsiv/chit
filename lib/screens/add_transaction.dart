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
  final RegExp numberRegex = RegExp(r'^\d+$'); // Validates only numbers
  final _formKey = GlobalKey<FormState>(); // Form Key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(hintText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a valid amount';
                  } else if (!numberRegex.hasMatch(value)) {
                    return 'Amount must be a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintMaxLines: 3,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a valid description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Transaction",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
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
          }
        },
        child: const Icon(Icons.done_all_outlined),
      ),
    );
  }
}
