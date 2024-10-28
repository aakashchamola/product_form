import 'package:flutter/material.dart';

class CheckBoxField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final IconData? icon; // Optional icon parameter

  const CheckBoxField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon, // Initialize the optional icon parameter
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Row(
        children: [
          if (icon != null) ...[
            // Check if the icon is provided
            Icon(icon,
                color: value
                    ? Colors.blue
                    : Colors.grey), // Change color based on checkbox state
            const SizedBox(width: 8), // Spacing between icon and text
          ],
          Text(label),
        ],
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
