
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    this.errorText,
    this.validator,
    this.suffixIcon,
    this.obscureText = false,
    this.editable = true,
  });

  final TextEditingController controller;
  final String title;
  final String? errorText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool editable;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          errorText: errorText,
          hintText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
        validator: validator,
        readOnly: editable,
      ),
    );
  }
}