// ignore_for_file: use_build_context_synchronously

import 'package:chit/modules/chit/providers/chit_provider.dart';
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

  bool nameStartedTyping = false;
  bool phoneNumberStartedTyping = false;
  Color phoneMessageColor = Colors.red;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void clearValidationErrors() {
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
  }

  void showOverlaySnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 10, // Adjust position
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }


  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(() {
      setState(() {
        phoneMessageColor =
            phoneNumberController.text.length == 10
                ? Colors.green
                : (phoneNumberController.text.isEmpty
                    ? Colors.red
                    : Colors.orange);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  if (!nameStartedTyping && value.isNotEmpty) {
                    setState(() {
                      nameStartedTyping = true;
                    });
                  }
                  clearValidationErrors();
                },
                validator: (value) {
                  if (!nameStartedTyping) {
                    return null; // Skip validation until typing starts
                  }
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  } else if (!alphabetRegex.hasMatch(value)) {
                    return "Enter a valid name (only letters and spaces)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Phone Number Field
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  if (!phoneNumberStartedTyping && value.isNotEmpty) {
                    setState(() {
                      phoneNumberStartedTyping = true;
                    });
                  }
                  clearValidationErrors();
                },
                validator: (value) {
                  if (!phoneNumberStartedTyping) return null;
                  if (value == null || value.isEmpty) {
                    return 'Phone Number is required';
                  }
                  if (!phoneNumberRegex.hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Add User Button
              Center(
                child: ElevatedButton(
                onPressed: () async {
  setState(() {
    nameStartedTyping = true;
    phoneNumberStartedTyping = true;
  });

  if (formKey.currentState!.validate()) {
    final name = nameController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();

    await ref.read(chitProvider.notifier).addChit(name, phoneNumber);

    showOverlaySnackBar(context, "User added successfully!"); // Stacked Snackbar

    // Clear input fields
    nameController.clear();
    phoneNumberController.clear();
    setState(() {
      nameStartedTyping = false;
      phoneNumberStartedTyping = false;
    });
    formKey.currentState?.reset();

    // Pop immediately
    Navigator.pop(context);
  }
},
                child: Text("Submit ",
                    style: TextStyle(color: Color.fromARGB(255, 70, 149, 155)),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
