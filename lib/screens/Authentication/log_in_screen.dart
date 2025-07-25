
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

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  //signs up users when sign up button is pressed:
  Future<void> _logIn({required email, required password}) async {

    if (email == null || password == null ) {
      return;
    }

    try {
      final userCreds = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      print(userCreds);

      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (Route<dynamic> route) => false,
      );
    }    
    on FirebaseAuthException catch (e) {  //Exception Codes: email-already-in-use, invalid-email, operation-not-allowed, weak-password  
      setState(() {
        
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ),          
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Enter password:",
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
          CustomTextFormField(
            controller: _passwordController, 
            title: "Password", 
            isPassword: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              _logIn(email: _emailController.text, password: _passwordController.text);
            }, 
            child: Text(
              "Log In",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white
              ),
            ),
          ),
          SizedBox(height:10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.forgotPassword,
              );
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
    );
  }
}

