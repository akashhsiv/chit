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
                  } else if (!phoneNumberRegex.hasMatch(value)) {
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

                    ScaffoldMessenger.of(context).showSnackBar(
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
