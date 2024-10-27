import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Please Provide your Email Address',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: emailController,
              maxLines: 1,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPress: () async {
                String email = emailController.text.trim();

                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: email);
                Fluttertoast.showToast(
                    msg: 'Reset Email sent!',
                    backgroundColor: Colors.blue,
                    textColor: Colors.white);

                Navigator.of(context).pop();
              },
              buttonTxt: const Text(
                'Send Email Reset Email',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
