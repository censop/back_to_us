import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {

  String? currentPasswordError;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  ValueNotifier<bool> seeCurrentPassword = ValueNotifier(false);
  ValueNotifier<bool> seeNewPassword = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Change Password",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5),
            Text(
              "Your password should be at least 6 characters long."
            ),
            SizedBox(height:5),
            ValueListenableBuilder(
              valueListenable: seeCurrentPassword,
              builder: (context, value, child) {
                return CustomTextFormField(
                  controller: _currentPasswordController,
                  title: "Current Password",
                  validator: validateCurrentPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      seeCurrentPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      seeCurrentPassword.value = !seeCurrentPassword.value;
                    },
                  ),
                  obscureText: seeCurrentPassword.value,
                );
              },
            ),
            SizedBox(height:20),
            ValueListenableBuilder(
              valueListenable: seeNewPassword,
              builder: (context, value, child) {
                return CustomTextFormField(
                  controller: _newPasswordController,
                  title: "New Password",
                  validator: validateNewPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      seeNewPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      seeNewPassword.value = !seeNewPassword.value;
                    },
                  ),
                  obscureText: seeNewPassword.value,
                );
              },
            ),
            SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: darkModeNotifier,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkModeNotifier.value ? const Color.fromARGB(255, 130, 14, 42) : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    currentPasswordError = null;
                    
                    if (_formKey.currentState!.validate()) {
                      try {
                        User? user = FirebaseAuth.instance.currentUser;
                        
                        if (user != null) {
                          // Check current password
                          AuthCredential credentials = EmailAuthProvider.credential(
                            email: user.email!,
                            password: _currentPasswordController.text,
                          );
                          await user.reauthenticateWithCredential(credentials);
                          
                          // Update password in Firebase Auth
                          await user.updatePassword(_newPasswordController.text);
                          
                          // Update password in Firestore
                          await FirebaseFirestore.instance
                            .collection("users")
                            .doc(user.uid)
                            .update({"password": _newPasswordController.text});
                          
                          // Refresh user data
                          await FirebaseService.getAppUser();
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackbar(
                              content: Text("Password updated successfully."), 
                              backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
                          setState(() {
                            currentPasswordError = "You entered a wrong password.";
                          });
                          _formKey.currentState!.validate();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackbar(
                              content: Text("Password couldn't be updated."), 
                              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    "Save",
                    style: Theme.of(context).textTheme.labelLarge
                  ),
                );
              }
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                FirebaseService.forgotPassword(context);
              }, 
              child: Text("Forgot password?")
            ),
          ],
        ),
      ),
    );
  }

   String? validateCurrentPassword(value) {
    if (value.isEmpty) {
      return "Enter your current password.";
    }
    return currentPasswordError;
  }

  String? validateNewPassword(value) {
    if (_newPasswordController.text.length < 6 || value == null || value.isEmpty) {
      return "Password should have at least 6 characters.";
    }
      return null;
  }
}