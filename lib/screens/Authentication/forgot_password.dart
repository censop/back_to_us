import 'package:back_to_us/Services/notifiers.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';





class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController =  TextEditingController();
  String? emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Enter your e-mail:",
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
          CustomTextFormField(
            controller: _emailController, 
            title: "E-mail",
            errorText: emailError,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await _sendEmail();
            }, 
            child: Text(
              "Reset Password",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          content: Text("New password request is sent. Check your inbox."),
          backgroundColor: Theme.of(context).colorScheme.secondary
        ),
      );
      setState(() {
        emailError = null;
      });
    }
    on FirebaseAuthException catch (e) {
      print(e.message);
      setState(() {
        emailError = "Try another e-mail.";
      });
    }
  }
}

