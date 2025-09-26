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
  CollectionReference users = FirebaseFirestore.instance.collection("users");

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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (isCreatingUser) {
                      } else {
                        if (_formKey.currentState!.validate()) {
                          _signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                            username: _usernameController.text,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge,
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
    if (value == null || value.isEmpty || value.length < 6) {
      //TODO add uppercase and special char requirements
      passwordError = "Password should have at least 6 characters.";
      return passwordError;
    }
    passwordError = null;
    return passwordError;
  }

  String? validateEmail(value) {
    if (value == null || value.isEmpty || !value.contains("@")) {
      emailError = "Enter a valid e-mail.";
      return emailError;
    }
    emailError = null;
    return emailError;
  }

  String? validateUsername(value) {
    if (value.length == 0) {
      usernameError = "Enter a valid username.";
      return usernameError;
    }
    usernameError = null;
    return usernameError;
  }

  //signs up users when sign up button is pressed:
  Future<void> _signUp({
    required email,
    required password,
    required username,
  }) async {
    if (email == null || password == null) {
      return;
    }

    try {
      //authenticate user
      final userCreds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCreds.user?.updateDisplayName(username);
      await userCreds.user?.reload();

      setState(() {
        isCreatingUser = true;
      });

      final newUser = AppUser(
        uid: userCreds.user!.uid,
        email: email,
        username: username,
        createdAt: Timestamp.now(),
      );

      //upload user to data base
      users.doc(userCreds.user!.uid).set(newUser.toJson());
      setState(() {
        isCreatingUser = false;
      });

      loadAppData();

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(
        Routes.home, (Route<dynamic> route) => false
      );

      setState(() {
        emailError = null;
        passwordError = null;
      });
    } on FirebaseAuthException catch (e) {
      //TODO Exception Codes: email-already-in-use, invalid-email, operation-not-allowed ????, weak-password
      setState(() {
        isCreatingUser = false;
      });

      if (e.code == "email-already-in-use") {
        setState(() {
          emailError = "E-mail is already in use.";
        });
        return;
      } else if (e.code == "invalid-email") {
        setState(() {
          emailError = "Enter a valid e-mail.";
        });
        return;
      }
      if (e.code == "weak-password") {
        setState(() {
          passwordError == "Password should have at least 6 characters.";
        });
        return;
      } else {
        //unexpected error veriyor
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            content: Text("Unexpected error. Please try again later."),
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      }
    }
  }

  Future<void> loadAppData() async {
    setState(() {
      isLoading = true;
    });
    //you should fix this
    await Future.delayed(Duration(milliseconds: 500));
    await FirebaseService.getAppUser();
    setState(() {
      isLoading = false;
    });
  }
}
