
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
        child: Padding(
          //TODO 20 100 20 100 uygun değil mediaquery kullanarak oranlarla bu değerleri yaz
          padding: EdgeInsetsGeometry.fromLTRB(20, 100, 20, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "join Back To Us",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height:20),
              Text(
                "Capture what matters.",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(height:20,),
              ElevatedButton(
                onPressed: _onSelectLogIn, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  
                ),
                child: Text(
                  "Log In",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
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