// ignore_for_file: use_build_context_synchronously

import 'package:chit/providers/chit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserPage extends ConsumerWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final RegExp phoneNumberRegex = RegExp(r'^[6-9]\d{9}$');
    final RegExp alphabetRegex = RegExp(r'^[a-zA-Z ]+$');

    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  } else if (!alphabetRegex.hasMatch(value)) {
                    return " Enter the Correct name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (!
                  /// The `phoneNumberRegex` variable is a regular expression used to
                  /// validate phone numbers. In this case, the regular expression
                  /// `RegExp(r'^[6-9]\d{9}$')` is checking if the phone number entered by
                  /// the user starts with a digit between 6 and 9 (inclusive) followed by
                  /// exactly 9 digits. This ensures that the phone number is a valid
                  /// 10-digit number starting with a digit between 6 and 9.
                  phoneNumberRegex.hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final name = nameController.text.trim();
                    final phoneNumber = phoneNumberController.text.trim();
                    await ref
                        .read(chitProvider.notifier)
                        .addChit(name, phoneNumber);

                    ScaffoldMessenger.of(
                      /// In the provided Dart code snippet, the `context` parameter
                      /// is being used in the `build` method of the `AddUserPage`
                      /// widget.
                      context,
                    ).showSnackBar(
                      SnackBar(content: Text('User added successfully!')),
                    );

                    Navigator.pop(context); // Go back after adding user
                  }
                },
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
