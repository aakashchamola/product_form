import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String helperText;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final int? maxlength;
  final String? prefixText; // New parameter for prefix text

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.helperText,
    this.inputType = TextInputType.text,
    this.validator,
    this.maxlength,
    this.prefixText, // Include the new parameter in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          helperText: helperText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          prefixText: prefixText, // Use the prefixText here
        ),
        keyboardType: inputType,
        maxLength: maxlength,
        validator: validator,
      ),
    );
  }
}
