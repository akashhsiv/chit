import 'package:chit/providers/chit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});

  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final RegExp phoneNumberRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp alphabetRegex = RegExp(r'^[a-zA-Z ]+$');

  String phoneMessage = '';
  Color phoneMessageColor = Colors.red; // Default color

  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(() {
      setState(() {
        phoneMessage = "${phoneNumberController.text.length}/10 digits entered";
        phoneMessageColor =
            phoneNumberController.text.length == 10 ? Colors.green : Colors.red;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align error messages properly
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  } else if (!alphabetRegex.hasMatch(value)) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  setState(() {
                    phoneMessage =
                        value.isNotEmpty
                            ? "Entered ${value.length} out of 10 digits"
                            : "";
                    phoneMessageColor =
                        value.length == 10 ? Colors.green : Colors.red;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (!phoneNumberRegex.hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              if (phoneMessage.isNotEmpty) // Show only once
                Text(
                  phoneMessage,
                  style: TextStyle(
                    color: phoneMessageColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final phoneNumber = phoneNumberController.text.trim();
                      await ref
                          .read(chitProvider.notifier)
                          .addChit(name, phoneNumber);
                
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User added successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                
                      Navigator.pop(context); // Go back after adding user
                    }
                  },
                  child: Text(
                    'Add User',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 70, 149, 155),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
