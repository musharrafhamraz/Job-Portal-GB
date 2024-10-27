import 'package:flutter/material.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class RegisterAsJobseekerScreen extends StatefulWidget {
  const RegisterAsJobseekerScreen({super.key});

  @override
  State<RegisterAsJobseekerScreen> createState() =>
      _RegisterAsJobseekerScreenState();
}

class _RegisterAsJobseekerScreenState extends State<RegisterAsJobseekerScreen> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    var confirmController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
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
                  'Lets create an account!',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(controller: nameController, label: 'Full Name'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: emailController, label: 'Email'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: phoneController, label: 'Phone Number'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: passController, label: 'Password'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: confirmController, label: 'Confirm Password'),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPress: () {
                    final String name = nameController.text.trim();
                    final String email = emailController.text.trim();
                    final String phone = phoneController.text.trim();
                    final String pass = passController.text.trim();
                    final String confirmPass = confirmController.text.trim();

                    if (email.isNotEmpty &&
                        pass.isNotEmpty &&
                        name.isNotEmpty &&
                        phone.isNotEmpty &&
                        confirmPass.isNotEmpty) {
                      if (pass != confirmPass) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password donot match.')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Register Function execution.')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please fill the required fields')));
                    }
                  },
                  buttonTxt: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(onPressed: () {}, child: const Text('Login'))
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
