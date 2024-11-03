import 'package:flutter/material.dart';

class RecMessageScreen extends StatelessWidget {
  const RecMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GBHires'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          color: Colors.blue,
        ),
      ),
    );
  }
}
