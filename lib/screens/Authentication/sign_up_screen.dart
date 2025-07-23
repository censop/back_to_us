import 'package:back_to_us/screens/Authentication/log_in_screen.dart';
import 'package:back_to_us/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State <SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool signedUp = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  //signs up users when sign up button is pressed:
  Future<void> _signUp({required email, required password}) async {

    if (email == null || password == null ) {
      return;
    }

    try {
      final userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      print(userCreds);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }    
    on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
    }
  }


  //ONLY A PLACEHOLDER FOR NOW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            "Sign Up",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text("Enter e_mail:")
          ),   
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: TextFormField(
              controller: _emailController,
             decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
           Container(
            margin: EdgeInsets.all(20),
            child: Text("Enter password:")
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: TextFormField(
              controller: _passwordController,
             decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _signUp(email: _emailController.text, password: _passwordController.text);

              if (signedUp) {

              }
            }, 
            child: Text("Sign Up"),
          ),
          Text(
            "Already have an account?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LogInScreen(),
                ),
              );
            }, 
            child: Text("Log In"),
          ),          
        ],
      ),
    );
  }
}