import 'package:back_to_us/screens/Authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:back_to_us/screens/home_screen.dart';

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
            "Log In",
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
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _logIn(email: _emailController.text, password: _passwordController.text);
            }, 
            child: Text("Log In"),
          ),
          Text(
            "Don't have an account yet?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            },
            child: Text("Join Back to Us"),
          ),          
        ],
      ),
    );
  }
}