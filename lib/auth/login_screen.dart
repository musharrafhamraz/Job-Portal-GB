import 'package:flutter/material.dart';
import 'package:jobfinder/auth/options.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    image: const AssetImage(ImageStrings.handshake)),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(controller: emailController, label: 'Email'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: passController, label: 'Password'),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPress: () {
                    final String email = emailController.text.trim();
                    final String password = emailController.text.trim();

                    if (email.isNotEmpty && password.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$email+$password')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please fill the required fields')));
                    }
                  },
                  buttonTxt: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignUpOptions();
                          }));
                        },
                        child: const Text('Sign Up'))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
