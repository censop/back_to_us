import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(20, 100, 20, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "join Back To Us",
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height:20),
              Text(
                "Capture what matters.",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(height:20,),
            ],
          ),
        ),
      )
    );
  }
}


/*
Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 100),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              "Back To Us",
              style: Theme.of(context).textTheme.displayLarge!
            ),
            SizedBox(
              height: 20
            ),
            ElevatedButton(
              onPressed: () {}, 
              child: Text("Sign Up"),
            ),
            Spacer(),
            TextButton(
              onPressed: () {}, 
              child: Text("Log In"),
            ),
          ],
        ),
      ),
*/