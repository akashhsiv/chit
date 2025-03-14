import 'package:chit/modules/transaction/models/transaction.dart';
import 'package:chit/modules/transaction/providers/transaction_provider.dart';
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
  final formKey = GlobalKey<FormState>(); // Form Key for validation
  void clearValidationErrors() {
    if (formKey.currentState != null) {
      formKey.currentState!.validate(); // Revalidate form on every input
    }
  }

  bool amountEntered = false;
  bool descriptionEntered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(hintText: "Amount"),
                keyboardType: TextInputType.number,
                maxLength: 9,
                onChanged: (value) {
                  if (!amountEntered && value.isNotEmpty) {
                    setState(() {
                      amountEntered = true;
                    });
                  }
                  clearValidationErrors();
                },
                validator: (value) {
                  if (!amountEntered) {
                    return null;
                  }

                  if (value == null || value.isEmpty) {
                    return 'Enter a Amount';
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
                onChanged: (value) {
                  if (!descriptionEntered && value.isNotEmpty) {
                    setState(() {
                      descriptionEntered = true;
                    });
                  }
                  clearValidationErrors();
                },
                validator: (value) {
                  if (!descriptionEntered) {
                    return null;
                  }
                  if (value == null || value.isEmpty) {
                    return 'Enter a Description';
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
        backgroundColor: const Color.fromARGB(255, 29, 162, 160),

        onPressed: () {
          setState(() {
            amountEntered = true;
            descriptionEntered = true;
          });

          if (formKey.currentState!.validate()) {
            final int? amount = int.tryParse(amountController.text.trim());
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

              // Clear input fields after successful submission
              amountController.clear();
              descriptionController.clear();
              setState(() {
                amountEntered = false;
                descriptionEntered = false;
              });

              Navigator.pop(context);
            }
          }
        },

        child: const Icon(Icons.done_all_outlined, color: Colors.white),
      ),
    );
  }
}
