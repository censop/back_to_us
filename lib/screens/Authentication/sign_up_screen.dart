
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:back_to_us/routes.dart';
import 'package:back_to_us/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State <SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? emailError; 
  String? passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  //signs up users when sign up button is pressed:
  Future<void> _signUp({required email, required password}) async {

    if (email == null || password == null) {
      return;
    }

    try {
      final userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        //TODO username ekle!!!!! 
      );
      print(userCreds);

      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (Route<dynamic> route) => false,
      );
      setState(() {
        emailError = null;
        passwordError = null;
      });

    }    
    on FirebaseAuthException catch (e) {  //TODO Exception Codes: email-already-in-use, invalid-email, operation-not-allowed ????, weak-password  
      if (e.code == "email-already-in-use") {
      setState(() {
        emailError = "E-mail is already in use."; 
      });
      return;
      } 
      else if (e.code == "invalid-email") {
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
      }
      else { //unexpected error veriyor
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            content: Text("Unexpected error. Please try again later."), 
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer
          ),
        );  
      }
    }
  }


  //ONLY A PLACEHOLDER FOR NOW

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              "Sign Up",
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            CustomTextFormField(
              controller: _passwordController, 
              title: "Password", 
              isPassword: true,
              validator: validatePassword,
              errorText: passwordError,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()){
                  _signUp(email: _emailController.text, password: _passwordController.text);
                }
              }, 
              child: Text(
                "Sign Up",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white
                ),             
              ),
            ),
            SizedBox(height:10),
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
                Navigator.of(context).pushReplacementNamed(
                  Routes.logIn,
                );
              }, 
              child: Text("Log In"),
            ),          
          ],
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
}