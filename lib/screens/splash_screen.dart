import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/title_name_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage(ImageStrings.gb),
            ),
            const SizedBox(
              height: 60,
            ),
            const TitleName(),
            const Text(
              'Gilgit-Baltistan',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(height: 100, ImageStrings.handshake)
          ],
        ),
      ),
    );
  }
}
