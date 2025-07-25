import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String title;
  final bool isPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool seePassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                seePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  seePassword = !seePassword;
                });
              },
            )
          : null,
        ),
        obscureText: widget.isPassword ? !seePassword : false,
      ),
    );
  }
}