import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/routes.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isCreatingUser = false;
  bool isLoading = false;

  ValueNotifier<bool> seePassword = ValueNotifier(true);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? usernameError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //ONLY A PLACEHOLDER FOR NOW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Enter username:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  CustomTextFormField(
                    controller: _usernameController,
                    title: "Username",
                    validator: validateUsername,
                    errorText: usernameError,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Enter e-mail:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    title: "E-mail",
                    validator: validateEmail,
                    errorText: emailError,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Enter password:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: seePassword,
                    builder: (context, value, child) {
                      return CustomTextFormField(
                        controller: _passwordController,
                        title: "Password",
                        validator: validatePassword,
                        errorText: passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            seePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            seePassword.value = !seePassword.value;
                          },
                        ),
                        obscureText: seePassword.value,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  isCreatingUser
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _onSignUpPressed();
                            });
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                  SizedBox(height: 10),
                  /*TODO add terms and conditions page, add checkbox
                  TextButton(
                    onPressed: () {}, 
                    child: Text("Terms and Conditions")
                  ),*/
                  SizedBox(height: 60),
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(Routes.logIn);
                    },
                    child: Text("Log In"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      passwordError = "Password cannot be empty.";
      return passwordError;
    }
    if (value.length < 6) {
      passwordError = "Password should have at least 6 characters.";
      return passwordError;
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      passwordError = "Password must contain at least one uppercase letter.";
      return passwordError;
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      passwordError = "Password must contain at least one special character.";
      return passwordError;
    }

    passwordError = null;
    return passwordError;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      emailError = "E-mail cannot be empty.";
      return emailError;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      emailError = "Enter a valid e-mail address.";
      return emailError;
    }

    emailError = null;
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      usernameError = "Enter a valid username.";
      return usernameError;
    }

    if (value.trim().length > 30) {
      usernameError = "Username cannot exceed 30 characters.";
      return usernameError;
    }

    usernameError = null;
    return null;
  }

  void _onSignUpPressed() {
    if (isCreatingUser) return;

    if (_formKey.currentState!.validate()) {
      _signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );
    }
  }

  Future<void> _signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      setState(() => isCreatingUser = true);

      await FirebaseService.signUpUser(
        email: email,
        password: password,
        username: username,
      );

      await loadAppData();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isCreatingUser = false);

      switch (e.code) {
        case "email-already-in-use":
          setState(() => emailError = "E-mail is already in use.");
          break;
        case "invalid-email":
          setState(() => emailError = "Enter a valid e-mail.");
          break;
        case "weak-password":
          setState(() => passwordError = "Password should have at least 6 characters.");
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar(
              content: const Text("Unexpected error. Please try again later."),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      }
    } finally {
      if (mounted) setState(() => isCreatingUser = false);
    }
  }

  Future<void> loadAppData() async {
    setState(() => isLoading = true);
    await FirebaseService.getAppUser();
    if (mounted) setState(() => isLoading = false);
  }
}
