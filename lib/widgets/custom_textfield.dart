import 'package:flutter/material.dart';
import 'package:qrcode/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final labelText;
  final keyboardType;
  final obscureText;
  final prefixIcon;
  final validator;
  final suffixIcon;

  CustomTextField(
      {@required this.controller,
      @required this.labelText,
      this.keyboardType,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.primaryColor),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: AppColors.primaryColor),
      cursorColor: AppColors.primaryColor,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
