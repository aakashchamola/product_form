import 'package:flutter/material.dart';

class DropDownField extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final String helperText;
  final void Function(String?)? onChanged; // Make onChanged nullable
  final String? Function(String?)? validator;

  const DropDownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.helperText,
    this.onChanged, // Make onChanged nullable to allow disabling the dropdown
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        decoration: InputDecoration(
          labelText: labelText,
          helperText: helperText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: onChanged, // Dropdown is disabled if onChanged is null
        validator: validator,
        disabledHint: Text(value ?? ''), // Display current value when disabled
      ),
    );
  }
}
