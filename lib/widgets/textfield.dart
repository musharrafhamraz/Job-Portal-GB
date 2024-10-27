import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the app is in dark mode or light mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final Color borderColor = isDarkMode ? Colors.white : Colors.blue.shade400;
    final Color focusedBorderColor =
        isDarkMode ? Colors.white : Colors.blue.shade400;
    final Color labelColor = isDarkMode ? Colors.white : Colors.black;
    final Color textColor = isDarkMode ? Colors.white : Colors.blue.shade400;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(color: textColor), // Set text color based on theme
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
