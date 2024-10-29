import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback onPress;
  final Widget buttonTxt;

  const CustomOutlineButton({
    super.key,
    required this.onPress,
    required this.buttonTxt,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color? background_color =
        isDarkMode ? Colors.blue[700] : Colors.blue[900];
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          // backgroundColor: background_color,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: buttonTxt,
      ),
    );
  }
}
