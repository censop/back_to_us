
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void _onSelectSignUp() {
    Navigator.pushNamed(
      context, 
      Routes.signUp,
    );
  }

  void _onSelectLogIn() {
    Navigator.pushNamed(
      context, 
      Routes.logIn,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "join Back To Us",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height:20),
              Text(
                "Capture what matters.",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height:20,),
              ElevatedButton(
                onPressed: _onSelectLogIn, 
                child: Text(
                  "Log In",
                  style: Theme.of(context).textTheme.labelLarge
                ),
              ),
              SizedBox(height:40),
              Text(
                "Don't have an account yet?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: _onSelectSignUp, 
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );

  
  }
}