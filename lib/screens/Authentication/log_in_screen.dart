
import 'package:back_to_us/Services/firebase_service.dart';
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
      body:isLoading 
      ? Center(child: CircularProgressIndicator())
      : SafeArea(
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      //validating the form before attempting to login
                    if (_formKey.currentState!.validate()){
                      _logIn(email: _emailController.text, password: _passwordController.text);
                    }
                    }, 
                    child: Text(
                      "Log In",
                      style: Theme.of(context).textTheme.labelLarge
                    ),
                  ),
                  SizedBox(height:10),
                  TextButton(
                    onPressed: () {
                      FirebaseService.forgotPassword(context);
                    }, 
                    child: Text("Forgot password?")
                  ),
                  SizedBox(height: 60),
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
    if (value == null || value.isEmpty || value.length <6) { //TODO add uppercase and special char requirements
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

    //signs up users when sign up button is pressed:
  Future<void> _logIn({required email, required password}) async {

    if (email == null || password == null ) {
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      await loadAppData();

      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (Route<dynamic> route) => false,
      );

      setState(() {
        emailError = null;
        passwordError = null;
      });

    }    

    on FirebaseAuthException catch (e) {  //Exception Codes: wrong-password, invalid-email, user-disabled, user-not-found
      if (e.code == "user-not-found") {
        setState(() {
          emailError = "User doesn't exist."; 
        });
        return;
      } 
      else if (e.code == "invalid-email") {
        setState(() {
          emailError = "Enter a valid e-mail.";
        });
        return;
      }
      if (e.code == "wrong-password") {
        setState(() {
          passwordError = "Password is wrong.";
        });
        return;
      }
      else { 
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            content: Text("Unexpected error. Please try again later."), 
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer
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

