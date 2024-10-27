import 'package:flutter/material.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                image: const AssetImage(ImageStrings.handshake)),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPress: () {},
              buttonTxt: const Text(
                'Sign Up as a Recruitor',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              onPress: () {},
              buttonTxt: const Text(
                'Sign Up as a Job Seeker',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
