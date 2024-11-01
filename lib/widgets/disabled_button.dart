import 'package:flutter/material.dart';

class CustomDisabledButton extends StatelessWidget {
  final VoidCallback onPress;
  final Widget buttonTxt;

  const CustomDisabledButton({
    super.key,
    required this.onPress,
    required this.buttonTxt,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode
        ? const Color.fromRGBO(92, 93, 102, 1)
        : const Color.fromRGBO(92, 93, 102, 1);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
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
