import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.hintText,
    this.onChanged,
    // this.controller,
    this.obscureText = false,
  }) : super(key: key);

  String? hintText;
  void Function(String)? onChanged;
  bool? obscureText;
  // TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: controller,
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is Required';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.yellowAccent,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
