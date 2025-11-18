
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_primary_elevated_button.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/routes.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> seePassword = ValueNotifier(true);

  bool isLoading = false;
  bool isLoggingIn = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError; 
  String? passwordError;

  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Log In",
                    style: Theme.of(context).textTheme.displayMedium,
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
                      style: Theme.of(context).textTheme.titleMedium
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
                  TextButton(
                    onPressed: () {
                      FirebaseService.forgotPassword(context);
                    }, 
                    child: Text("Forgot password?")
                  ),
                  SizedBox(height: 20),
                  CustomPrimaryElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()){
                        _onLoginPressed();
                      }
                    }, 
                    child: Text(
                      "Log In",
                    ),
                  ),
                  Divider(
                    height: 40,
                    indent: 50,
                    endIndent: 50,
                  ),
                  Text(
                    "Don't have an account yet?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        Routes.signUp,
                      );
                    },
                    child: Text("Join Back to Us"),
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
    if (value == null || value.isEmpty) return "Password cannot be empty.";
    passwordError = null; 
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "E-mail cannot be empty.";
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return "Enter a valid e-mail address.";
    }

    emailError = null;
    return null;
  }

  void _onLoginPressed() {
    if (isLoggingIn) return;
      _loginUser();
  }

  Future<void> _loginUser() async {
    try {
      setState(() => isLoggingIn = true);

      await FirebaseService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (r) => false);
    } on FirebaseAuthException catch (e) {
      setState(() => isLoggingIn = false);
      switch (e.code) {
        case "user-not-found":
        case "wrong-password": 
        case "invalid-credential":
          final String genericError = "Please check your email and password.";
          setState(() {
          emailError = genericError;
          passwordError = genericError;
          });
          break;
        case "invalid-email":
          setState(() => emailError = "Enter a valid e-mail.");
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
      if (mounted) setState(() => isLoggingIn = false);
    }
  }

  Future<void> loadAppData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseService.getAppUser();
    setState(() {
      isLoading = false;
    });
  }
}

