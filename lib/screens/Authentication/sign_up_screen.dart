
import 'package:back_to_us/routes.dart';
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
        ///TO DO username ekle!!!!!
      );
      print(userCreds);

      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
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
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Enter e_mail:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
            child: Text(
              "Enter password:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: TextFormField(
              controller: _passwordController,
             decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              _signUp(email: _emailController.text, password: _passwordController.text);
            }, 
            child: Text(
              "Sign Up",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white
              ),             
            ),
          ),
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
    );
  }
}