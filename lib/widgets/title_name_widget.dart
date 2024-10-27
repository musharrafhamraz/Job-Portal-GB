import 'package:flutter/material.dart';

class TitleName extends StatelessWidget {
  const TitleName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'GB ',
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 60.0,
              fontWeight: FontWeight.bold),
        ),
        const Text('Hires',
            style: TextStyle(
              color: Colors.black,
              fontSize: 55.0,
            )),
      ],
    );
  }
}
